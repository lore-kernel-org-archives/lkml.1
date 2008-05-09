Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbYEIKpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbYEIKpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 06:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbYEIKp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 06:45:29 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:57130 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYEIKp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 06:45:28 -0400
Subject: Re: boot cgroup questions
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Jackson <pj@sgi.com>
Cc: Max Krasnyanskiy <maxk@qualcomm.com>, menage@google.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080414133902.7878cfce.pj@sgi.com>
References: <47D73086.2030008@qualcomm.com>
	 <6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>
	 <47D7411E.1000009@qualcomm.com>
	 <6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>
	 <47D74595.4080100@qualcomm.com>
	 <6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>
	 <20080311235939.1ebee8e3.pj@sgi.com> <47D81FE1.6030205@qualcomm.com>
	 <20080312135746.89456f2a.pj@sgi.com> <47D82AD2.1070108@qualcomm.com>
	 <20080312143253.3dd72c7f.pj@sgi.com> <47D83858.4030806@qualcomm.com>
	 <20080312153712.bc5df7a1.pj@sgi.com> <47D8593A.6040503@qualcomm.com>
	 <20080312183059.6716d630.pj@sgi.com> <47D87BE5.4010702@qualcomm.com>
	 <20080313020300.92244956.pj@sgi.com> <47FE5655.10900@qualcomm.com>
	 <20080414133902.7878cfce.pj@sgi.com>
Content-Type: text/plain
Date: Fri, 09 May 2008 12:45:26 +0200
Message-Id: <1210329926.13978.224.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-14 at 13:39 -0500, Paul Jackson wrote:
> Max wrote:
> > I mean you guys were talking about how wonderful 
> > and flexible cpusets are, but we cannot seem to use the flexibility because 
> > the apps are designed for a flat layout
> 
> No.  Not flat.  Not at all flat.
> 
> We routinely and normally have an interesting hierarchy of cpusets
> below /dev/cpuset.  However that hierarchy is determined by the
> nesting of subsets of the nodes (CPUs and/or Memory) on the system.
> 
> These subsets of nodes in the /dev/cpuset hierarchy may well map
> nicely into the subsets of CPUs that can receive a particular set
> of IRQs, however that map is not bijective.  Of particular interest
> here, it's not injective, meaning that multiple cpusets might and
> will commonly receive the same set of IRQs.  You can force this map
> to be injective by elaborating the cpuset hierarchy to reflect both
> this new assignment of IRQs and the (CPU and/or Memory) node subset
> hiearchy that it currently reflects, but that will break code that
> was expecting the directory tree below /dev/cpuset to directly and
> only reflect the node hierarchy.
> 
> In less mathematically obtuse wording, sure you can add more directory
> layers below /dev/cpuset, to handle IRQ assignments, but that will
> break code that was expecting the /dev/cpuset directory tree to only
> reflect the nesting of (CPU and/or Memory) nodes.

Sorry for being rather late to the game - other stuff keeps me from
doing anything much here :-(.

Anyway, the current applications don't support IRQ assingment anyway.
That's a new feature; and its quite common that new features require
code changes.

So I'm not seeing the problem - don't change code and stuff works as
before - change code and you get new stuff.

So I'm arguing in favour of the IRQs as tasks idea that might need extra
hierarchy levels.

