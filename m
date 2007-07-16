Return-Path: <linux-kernel-owner+w=401wt.eu-S1765497AbXGPWbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765497AbXGPWbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbXGPWaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:30:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54391 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762966AbXGPWaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:30:21 -0400
Date: Mon, 16 Jul 2007 15:29:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, geert@linux-m68k.org,
       zippel@linux-m68k.org, jdike@karaya.com, alan@lxorguk.ukuu.org.uk,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: uninline check_signature()
Message-Id: <20070716152923.ce4a5c5a.akpm@linux-foundation.org>
In-Reply-To: <20070716221257.GA12230@osiris.ibm.com>
References: <200707161802.l6GI2tNp007390@hera.kernel.org>
	<20070716221257.GA12230@osiris.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 00:12:57 +0200
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Mon, Jul 16, 2007 at 06:02:55PM +0000, Linux Kernel Mailing List wrote:
> > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=cc2ea416b2aa04d0c34ff2281a23dae5b76b7b3b
> > Commit:     cc2ea416b2aa04d0c34ff2281a23dae5b76b7b3b
> > Parent:     4e7bd66318b3ae60fbba7d886d9a98b71ffbf74e
> > Author:     Andrew Morton <akpm@linux-foundation.org>
> > AuthorDate: Sun Jul 15 23:41:38 2007 -0700
> > Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
> > CommitDate: Mon Jul 16 09:05:50 2007 -0700
> > 
> >     uninline check_signature()
> >     
> >     This is a rather bizarre thing to have inlined in io.h.  Stick it in lib/
> >     instead.
> >     
> >     While we're there, despaghetti it a bit, and fix its off-by-one behaviour when
> >     passed a zero length.
> >     
> >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > ---
> >  include/linux/io.h    |   29 ++---------------------------
> >  lib/Makefile          |    2 +-
> >  lib/check_signature.c |   26 ++++++++++++++++++++++++++
> >  3 files changed, 29 insertions(+), 28 deletions(-)
> 
> Hmm.. this breaks s390 and probably m68k and UML as well:
> 
>   CC      lib/check_signature.o
> lib/check_signature.c: In function 'check_signature':
> lib/check_signature.c:19: error: implicit declaration of function 'readb'

Yep.  They were already broken, only less so.

> Actually we tried to fix this, but it looks like there was no final
> conclusion: http://lkml.org/lkml/2007/6/28/98
> 
> Now what? Revert until things have been sorted out?

No, no revert, please.  If the architecture doesn't support readb() then we
need some reliable way of working that out within Kconfig.

