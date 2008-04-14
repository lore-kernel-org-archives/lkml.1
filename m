Return-Path: <linux-kernel-owner+w=401wt.eu-S934082AbYDNSjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082AbYDNSjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932354AbYDNSjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:39:10 -0400
Received: from relay1.sgi.com ([192.48.171.29]:52637 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764007AbYDNSjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:39:08 -0400
Date: Mon, 14 Apr 2008 13:39:02 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: menage@google.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: boot cgroup questions
Message-Id: <20080414133902.7878cfce.pj@sgi.com>
In-Reply-To: <47FE5655.10900@qualcomm.com>
References: <47D73086.2030008@qualcomm.com>
	<6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>
	<47D7411E.1000009@qualcomm.com>
	<6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>
	<47D74595.4080100@qualcomm.com>
	<6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>
	<20080311235939.1ebee8e3.pj@sgi.com>
	<47D81FE1.6030205@qualcomm.com>
	<20080312135746.89456f2a.pj@sgi.com>
	<47D82AD2.1070108@qualcomm.com>
	<20080312143253.3dd72c7f.pj@sgi.com>
	<47D83858.4030806@qualcomm.com>
	<20080312153712.bc5df7a1.pj@sgi.com>
	<47D8593A.6040503@qualcomm.com>
	<20080312183059.6716d630.pj@sgi.com>
	<47D87BE5.4010702@qualcomm.com>
	<20080313020300.92244956.pj@sgi.com>
	<47FE5655.10900@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max wrote:
> I mean you guys were talking about how wonderful 
> and flexible cpusets are, but we cannot seem to use the flexibility because 
> the apps are designed for a flat layout

No.  Not flat.  Not at all flat.

We routinely and normally have an interesting hierarchy of cpusets
below /dev/cpuset.  However that hierarchy is determined by the
nesting of subsets of the nodes (CPUs and/or Memory) on the system.

These subsets of nodes in the /dev/cpuset hierarchy may well map
nicely into the subsets of CPUs that can receive a particular set
of IRQs, however that map is not bijective.  Of particular interest
here, it's not injective, meaning that multiple cpusets might and
will commonly receive the same set of IRQs.  You can force this map
to be injective by elaborating the cpuset hierarchy to reflect both
this new assignment of IRQs and the (CPU and/or Memory) node subset
hiearchy that it currently reflects, but that will break code that
was expecting the directory tree below /dev/cpuset to directly and
only reflect the node hierarchy.

In less mathematically obtuse wording, sure you can add more directory
layers below /dev/cpuset, to handle IRQ assignments, but that will
break code that was expecting the /dev/cpuset directory tree to only
reflect the nesting of (CPU and/or Memory) nodes.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
