Return-Path: <linux-kernel-owner+w=401wt.eu-S934009AbXILCeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934009AbXILCeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 22:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbXILCeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 22:34:11 -0400
Received: from ozlabs.org ([203.10.76.45]:43072 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbXILCeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 22:34:09 -0400
From: Michael Neuling <mikey@neuling.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: akpm@linux-foundation.org, paulus@samba.org, Alan Cox <alan@redhat.com>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] powerpc: add new required termio functions 
In-reply-to: <alpine.LFD.0.999.0709111915350.16478@woody.linux-foundation.org> 
References: <8018.1189562679@neuling.org> <alpine.LFD.0.999.0709111915350.16478@woody.linux-foundation.org>
Comments: In-reply-to Linus Torvalds <torvalds@linux-foundation.org>
   message dated "Tue, 11 Sep 2007 19:17:42 -0700."
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 21.4.1
Date: Wed, 12 Sep 2007 12:34:08 +1000
Message-ID: <10146.1189564448@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 12 Sep 2007, Michael Neuling wrote:
> >
> > The "tty: termios locking functions break with new termios type" patch
> > (f629307c857c030d5a3dd777fee37c8bb395e171) breaks the powerpc compile.
> 
> Really?
> 
> It shouldn't. The use of kernel_termios_to_user_termios_1() is conditional 
> on the architecture having a define for TCGETS2, and I think they match 
> up. I see:
> 
> 	[torvalds@woody linux]$ git grep -l kernel_termios_to_user_termios_1 in
clude | wc -l
> 	10
> 	[torvalds@woody linux]$ git grep -l TCGETS2 include | wc -l
> 	10
> 
> and in neither case is ppc in that list of architecures.
> 
> So maybe you just read the patch without actually testing whether it 
> actually broke powerpc?

Not, I actually compiled it.

> Or is something subtler going on?

Looks like those new calls are not protected by the TCGETS2 define.
Adding those ifdefs seems like the correct fix.  

Mikey


