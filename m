Return-Path: <linux-kernel-owner+w=401wt.eu-S1760345AbZAWNqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760345AbZAWNqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 08:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756288AbZAWNqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 08:46:11 -0500
Received: from aun.it.uu.se ([130.238.12.36]:65220 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232AbZAWNqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 08:46:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18809.51738.660327.55822@harpo.it.uu.se>
Date: Fri, 23 Jan 2009 14:46:02 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: Unneeded assignment to tsk in recent x86 change, v2
In-Reply-To: <5787cf470901212333m749085ebjda40e869ab4bdffc@mail.gmail.com>
References: <5787cf470901212333m749085ebjda40e869ab4bdffc@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uros Bizjak writes:
 > On Wed, Jan 21, 2009 at 10:13 PM, Mikael Pettersson <mikpe@it.uu.se> wrote:
 > 
 > Impact: Cleanup.
 > 
 > Remove unneeded assignment to tsk in recent x86 change.
 > 
 > >  > Hm, I'm not sure I see the inconsistency here. Care to explain this
 > >  > inconsistency in a couple of words?
 > >
 > > You're initialising some variables in their declarations, and some
 > > using assignments at the start of the procedure body. In particular,
 > > for some reason you don't initialise 'mm' in its declaration even
 > > though you could do so for consistency with 'tsk'.
 > >
 > > However, I'm strongly in favour of separating declarations and
 > > initialisations (esp. ones that need actual computations), so
 > > rather than subjecting 'mm' to the treatment you gave 'tsk',
 > > just leave the code alone.
 > >
 > 
 > Patch v2 with the second hunk removed is attached to this message.
 > 
 > Thanks,
 > Uros.
 > diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
 > index 93a563b..621e9b3 100644
 > --- a/arch/x86/mm/fault.c
 > +++ b/arch/x86/mm/fault.c
 > @@ -421,7 +421,6 @@ static noinline void pgtable_bad(struct pt_regs *regs,
 >  	printk(KERN_ALERT "%s: Corrupted page table at address %lx\n",
 >  	       tsk->comm, address);
 >  	dump_pagetable(address);
 > -	tsk = current;
 >  	tsk->thread.cr2 = address;
 >  	tsk->thread.trap_no = 14;
 >  	tsk->thread.error_code = error_code;

ACKed, but an equivalent patch from Johannes Weiner has already been committed
to the x86 git tree.
