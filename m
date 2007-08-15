Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbXHOLvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbXHOLvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 07:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbXHOLvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 07:51:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58111 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbXHOLva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 07:51:30 -0400
Date: Wed, 15 Aug 2007 13:51:18 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Eric Sandeen <sandeen@redhat.com>
cc: 7eggert@gmx.de, linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>, security@kernel.org
Subject: Re: [PATCH V3] limit minixfs printks on corrupted dir i_size,
 CVE-2006-6058
In-Reply-To: <46C09AE0.5010902@redhat.com>
Message-ID: <Pine.LNX.4.58.0708151345220.3232@be1.lrz>
References: <8Qlff-3jX-29@gated-at.bofh.it> <8Qn7m-6li-27@gated-at.bofh.it>
 <E1IJFr4-0000is-Ox@be1.lrz> <46C09AE0.5010902@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+WNd1pe5SI10vOX/JUq53f1xjONSYETpNQT/M
 IXGS2A3oNDKNaArt34shBtlhZDcvc0Lzlr21OgHDp/c+nW/kq5
 tLb9G/iAtYOB9AOt4cOEA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007, Eric Sandeen wrote:
> Bodo Eggert wrote:

> > Warning: I'm only looking at the patch.
> >
> > You are supposed to print an error message for a user, not to write in a
> > chat window to a 1337 script kiddie. OK, you just matched the current style,
> > and your patch is IMHO OK for a quick security fix, but:
> >
> > - Security fixes should be CCed to the security mailing list, shouldn't they?
> >   (It might be security@ or stable@, I'll remember tomorrow, but then I'd
> >    forget to comment)
> > - Imagine you have three mounts containing a minix fs, how can you tell which
> >   one is the the defective one?
> > - The message says "minix_bmap", while the patch suggests it's in
> >   block_to_path. Therefore I asume "minix_bmap" to have only random
> >   informational value.
> > - Does block < 0 or block > $size make a difference?
> > - the printk lacks the loglevel.
> > - Asuming minix supports error handling, shouldn't it do something?
> >
> > I'd suggest a message saying something like "minix: Bad block address on
> > device 08:15, needs fsck".
> >   
> Ok, do you like this slightly better?  It states the subsystem, the 
> function with the error, the block nr. in the case of a too-large block,
> and the block device on which the error occurred.

- how long is BDEVNAME_SIZE? Will it fit on the stack?
- Does it include thespace for \0?

I asume you copied other users, and the other users will do it right (or 
at least not terribly wrong:), but I can't dig the code right now.

>  Honestly minix.fsck
> doesn't handle the situation well either, so at this point I hesitate
> to recommend it in the print.  :)

*g*
-- 
Top 100 things you don't want the sysadmin to say:
79. What's this "any" key I'm supposed to press?
