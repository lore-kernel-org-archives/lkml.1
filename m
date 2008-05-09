Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbYEIMOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbYEIMOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 08:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbYEIMOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 08:14:35 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:54990 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755258AbYEIMOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 08:14:34 -0400
Subject: Re: IRQ affinities (was: boot cgroup questions)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Jackson <pj@sgi.com>
Cc: maxk@qualcomm.com, menage@google.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080509070314.f86aece4.pj@sgi.com>
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
	 <20080414133902.7878cfce.pj@sgi.com> <1210329926.13978.224.camel@twins>
	 <20080509061727.5057de1f.pj@sgi.com> <1210333738.13978.246.camel@twins>
	 <20080509070314.f86aece4.pj@sgi.com>
Content-Type: text/plain
Date: Fri, 09 May 2008 14:14:30 +0200
Message-Id: <1210335270.13978.252.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-09 at 07:03 -0500, Paul Jackson wrote:
> Peter wrote:
> > I see two use-cases:
> > 
> >  - Isolation
> >  - NUMA node devices
> 
> Ok ... so let me propose an entirely different solution.
> 
> No doubt it has some terrible flaw, but I'll just have to
> await your replies to see what that is.
> 
> How about we have:
> 
>  1) Yet another text config file in /etc, this one containing
>     lines having two fields:
> 	* a list of IRQs, and
> 	* a cpumask.
>     This file would specify which CPUs should handle which IRQs.
> 
>  2) A utility that can be run, after changing the above file, 
>     to poke the proper cpumask to each IRQ, as specified in
>     the file.
> 
> (Obligatory "simple" marketing claim: the above requires no
> kernel changes.)
> 
> What am I missing?

Two points:

 - we can't currently set irq affinities for non-existent (aka new) IRQs
 - its a shame to duplicate the masks - most of this information would
also be used in the cpuset structure used to place the tasks.




