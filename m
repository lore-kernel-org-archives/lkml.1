Return-Path: <linux-kernel-owner+w=401wt.eu-S1762812AbYEIMhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762812AbYEIMhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 08:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbYEIMgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 08:36:54 -0400
Received: from relay1.sgi.com ([192.48.171.29]:35649 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755499AbYEIMgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 08:36:53 -0400
Date: Fri, 9 May 2008 07:36:50 -0500
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: maxk@qualcomm.com, menage@google.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: IRQ affinities (was: boot cgroup questions)
Message-Id: <20080509073650.045d037d.pj@sgi.com>
In-Reply-To: <1210335270.13978.252.camel@twins>
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
	<20080414133902.7878cfce.pj@sgi.com>
	<1210329926.13978.224.camel@twins>
	<20080509061727.5057de1f.pj@sgi.com>
	<1210333738.13978.246.camel@twins>
	<20080509070314.f86aece4.pj@sgi.com>
	<1210335270.13978.252.camel@twins>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, responding to pj:
> > What am I missing?
> 
> Two points:
> 
>  - we can't currently set irq affinities for non-existent (aka new) IRQs
>  - its a shame to duplicate the masks - most of this information would
>    also be used in the cpuset structure used to place the tasks.

Ok.  Let me twist this a turn tighter then.

The first of your two points, a default affinitiy mask for new irqs,
would seem to require a kernel change.  But that change could be a
single cpumask, settable in /sys somewhere, specifying the default
affinity.  If that's all we needed, it would be easy.

The second of your two points, "duplicating masks", seems more delicate.

The space of named cpusets (the directory pathnames below the usual
mount point, /dev/cpuset) is not really much more compact than the
set of interesting cpumasks.  But I suppose your point is that some
of the -particular- cpumasks already named by the cpuset hierarchy
are tantilizingly close to the set of interesting cpumasks needed for
irq affinity ... close given some combination of union, intersection,
set difference and compliment operations, given my usual bias toward
looking at such things as this using set theory mechanisms.  That is,
for example, one might want all the CPUs in cpusets foo, bar and baz,
except the CPUs in cpuset blip, to handle IRQs so and so.

Let me think on that ... it's my nap time now.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
