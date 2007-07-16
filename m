Return-Path: <linux-kernel-owner+w=401wt.eu-S932075AbXGPWNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbXGPWNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXGPWNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:13:22 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:17249 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbXGPWNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:13:21 -0400
Date: Tue, 17 Jul 2007 00:12:57 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, geert@linux-m68k.org,
       zippel@linux-m68k.org, jdike@karaya.com, alan@lxorguk.ukuu.org.uk,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: uninline check_signature()
Message-ID: <20070716221257.GA12230@osiris.ibm.com>
References: <200707161802.l6GI2tNp007390@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707161802.l6GI2tNp007390@hera.kernel.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 06:02:55PM +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=cc2ea416b2aa04d0c34ff2281a23dae5b76b7b3b
> Commit:     cc2ea416b2aa04d0c34ff2281a23dae5b76b7b3b
> Parent:     4e7bd66318b3ae60fbba7d886d9a98b71ffbf74e
> Author:     Andrew Morton <akpm@linux-foundation.org>
> AuthorDate: Sun Jul 15 23:41:38 2007 -0700
> Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
> CommitDate: Mon Jul 16 09:05:50 2007 -0700
> 
>     uninline check_signature()
>     
>     This is a rather bizarre thing to have inlined in io.h.  Stick it in lib/
>     instead.
>     
>     While we're there, despaghetti it a bit, and fix its off-by-one behaviour when
>     passed a zero length.
>     
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  include/linux/io.h    |   29 ++---------------------------
>  lib/Makefile          |    2 +-
>  lib/check_signature.c |   26 ++++++++++++++++++++++++++
>  3 files changed, 29 insertions(+), 28 deletions(-)

Hmm.. this breaks s390 and probably m68k and UML as well:

  CC      lib/check_signature.o
lib/check_signature.c: In function 'check_signature':
lib/check_signature.c:19: error: implicit declaration of function 'readb'

Actually we tried to fix this, but it looks like there was no final
conclusion: http://lkml.org/lkml/2007/6/28/98

Now what? Revert until things have been sorted out?
