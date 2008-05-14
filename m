Return-Path: <linux-kernel-owner+w=401wt.eu-S1762319AbYENOwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762319AbYENOwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756616AbYENOwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:52:23 -0400
Received: from [198.99.130.12] ([198.99.130.12]:45684 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1761591AbYENOwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:52:22 -0400
Date: Wed, 14 May 2008 10:52:10 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       "Kirill A. Shutemov" <k.shutemov@gmail.com>
Subject: Re: UML build issue with v2.6.26-rc2-129-g9604006
Message-ID: <20080514145210.GA8639@c2.user-mode-linux.org>
References: <200805141301.30027.toralf.foerster@gmx.de> <20080514112217.GC2520@hacking> <20080514125548.GA6373@c2.user-mode-linux.org> <200805141503.20065.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805141503.20065.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 03:03:17PM +0200, Toralf Förster wrote:
> > > Hmm, it seems that I can't reproduce it with your .config.
> > > And <asm/user.h> does exist.
> > 
> > I bet he's using the headers exported by the current kernel, not what
> > his distro gives him.
> > 
> > 			Jeff
> > 
> 
> Right, IIRC I ran into this some times ago under Gentoo Linux.

Commit c1445db9f72db0537c43a2eab6e1b0f6741162f5 unexported asm/user.h
(and linux/user.h):

     Author: Kirill A. Shutemov <k.shutemov@gmail.com>
     Date:   Thu Feb 7 00:15:53 2008 -0800

         Unexport asm/user.h and linux/user.h
    
        Do not export asm/user.h and linux/user.h during make
        headers_install.

As far as I can see, this renders PTRACE_[SG]ETFPREGS and
PTRACE_[SG]ETFPXREGS unusable, as userspace has no way to figure out
what size buffer to pass in.

I think we either need to make user_i387_struct and user_fxsr_struct
available someplace else, or re-export user.h.

	  	    	     Jeff

-- 
Work email - jdike at linux dot intel dot com
