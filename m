Return-Path: <linux-kernel-owner+w=401wt.eu-S1758717AbZCAXvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717AbZCAXvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 18:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757104AbZCAXvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 18:51:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59116 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbZCAXvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 18:51:45 -0500
Date: Mon, 2 Mar 2009 01:10:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] xen: core dom0 support
Message-ID: <20090302001016.GK26292@one.firstfloor.org>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org> <49A8DF28.4050301@goop.org> <87eixi35ew.fsf@basil.nowhere.org> <49AB1B75.2060200@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AB1B75.2060200@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes.  A big part of what I'm doing is trying to keep the Xen changes 
> self-contained to try and minimize their system-wide impact.  Basically 
> it comes down to that if you use (mostly existing) kernel APIs in the 
> way they're intended to be used, then things just work out for both Xen 
> and native cases.  The whole point of keeping the kernel modular is so 
> that if people implement and use the the interfaces correctly, the 

That's a big if. It sounds good in theory, but I in practice
it will be different. Kernel interfaces tend to have hidden assumptions
too that matter and the more special case code is in there the more
additional hidden assumptions will be there too.

> internal details shouldn't matter very much.  Often the process of 
> adding Xen support has resulted in putting clear, well defined 
> interfaces into parts of the kernel where previously things were, well, 
> in need of cleaning up.

That's true, but it's still much more complex than before semantically.
> 
> >For example things like: doesn't use PAT with Xen or apparently very
> >different routing are somewhat worrying because it means it's a
> >completely different operation modus with Xen that needs to be taken
> >care of later, adding to complexity.
> >  
> 
> Unless we're planning on dropping support for processes with no or 
> broken PAT support, we're always going to have to deal with the non-PAT 
> case.

These are all really old hardware[1], no modern 3d chips etc. Xen on the 
other hand ..

[1] afaik you have to go back to PPro to get real PAT bugs.

> >Unfortunately it also looks like that Xen the HV does things
> >more and more different from what mainline kernel does so 
> >these differences will likely continue to grow over time.
> 
> I hope that won't be the case. As part of considering any change to Xen 

My impression from looking occasionally at Xen source is like this
at least. It used to be that Xen was basically Linux 2.4 with
some tweaks in many ways, but now it's often completely new code
doing things in very different ways.  Basically a real fork diverging
more and more.

That said there's probably no way around merging the Dom0 support too,
but I think it should be clearly said that it has a quite high
long term cost for Linux. Hopefully it's worth it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
