Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbXLDWp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbXLDWp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbXLDWpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:45:50 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46249 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752010AbXLDWpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:45:49 -0500
Date: Tue, 4 Dec 2007 23:45:43 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] x86: Unify include/asm-x86/linkage_[32|64].h
Message-ID: <20071204224543.GH15974@stusta.de>
References: <1196801629.10408.26.camel@brick> <20071204213247.GA11216@elte.hu> <1196806868.10408.33.camel@brick> <20071204222717.GA25974@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071204222717.GA25974@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 11:27:17PM +0100, Ingo Molnar wrote:
> 
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > On Tue, 2007-12-04 at 22:32 +0100, Ingo Molnar wrote:
> > > * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> > > 
> > > > I'm not sure if the definition of asmlinkage and prevent_tail_call can 
> > > > be omitted as well and let the linux/linkage.h version get picked up 
> > > > instead.
> > > 
> > > no, we cannot remove them - asmlinkage is needed for the syscall 
> > > entry (and other entry code) to work, the and the prevent_tail_call 
> > > works around a compiler bug. (which might or might not be fixed in 
> > > latest gcc - but we generally dont remove workarounds unless we are 
> > > really sure it's fine.)
> > 
> > OK, but if this patch is acceptable, then there is no more places in 
> > the tree that define the FASTCALL macro, other than the empty default 
> > in include/linux/linkage.h.  So I think a second step would be to 
> > start to get rid of FASTCALL callers elsewhere in the tree...thoughts?
> 
> the removal of FASTCALL is fine: the default (and only) compiler model 
> for x86 (32-bit) is regparm(3), so the regparm(3) macro is equivalent to 
> the empty one in linux/linkage.h.
>...

But please ensure that they stay in assembler code also used by UML.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

