Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642AbYJaLcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbYJaLcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 07:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbYJaLcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 07:32:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:35469 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbYJaLcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 07:32:24 -0400
Subject: Re: 2.6.28-rc1: NVRAM being corrupted on ppc64 preventing boot
	(bisected)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Paul Mackerras <paulus@samba.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
In-Reply-To: <18698.59790.393775.139313@cargo.ozlabs.ibm.com>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org>
	 <20081030142632.GA15645@csn.ul.ie>
	 <18698.7794.500191.189515@cargo.ozlabs.ibm.com>
	 <20081031103646.GA24395@csn.ul.ie>
	 <18698.59790.393775.139313@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Fri, 31 Oct 2008 22:31:37 +1100
Message-Id: <1225452697.8004.211.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-31 at 22:18 +1100, Paul Mackerras wrote:
> Mel Gorman writes:
> 
> > Yaboot in my case and I've heard it affected a DVD installation. I don't
> > know for sure if it affects netboot but as I think it's something the
> > kernel is doing, it probably doesn't matter how it gets loaded?
> 
> I do need to know whether it was the vmlinux or the zImage.pseries
> that you were loading with yaboot.  That commit you identified affects
> the contents of an ELF note in the zImage.pseries that firmware looks
> at, as well as a structure in the kernel itself that gets passed as an
> argument to a call to firmware.  If you were loading a vmlinux with
> yaboot when you saw the corruption occur then that narrows things down
> a bit.

Unless missed something, I think it's narrowed already. When loaded from
yaboot, there is no relevant difference between zImage and vmlinux here.
IE. yaboot parses the ELF header of the zImage itself and ignores the
special notes anyway so only the CAS firmware call is relevant in both
cases, no ?

Cheers,
Ben.


