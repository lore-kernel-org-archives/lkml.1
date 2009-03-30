Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbZC3QPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbZC3QPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 12:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZC3QPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 12:15:36 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:35523 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbZC3QPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 12:15:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UrgzmBYUYFd2Ci8vkIMUu20StPjihy6mUV3oEFOWu5ZIZBWYV+tt6oKn/QFuHylQvu
         Kfp4MwNktbK/1iVZgUwinSm9Tbpwmq0OP2YN/V9LADJQjIbgASyf48bd9xiHLA80EK3N
         vpWZEc9e70kuFD2Cj8vZFEjY1ePRmTHuNftBA=
MIME-Version: 1.0
In-Reply-To: <49CBF73E.2010808@oracle.com>
References: <20090326190130.54fc6fde.sfr@canb.auug.org.au>
	 <49CBF73E.2010808@oracle.com>
Date: Mon, 30 Mar 2009 18:15:30 +0200
X-Google-Sender-Auth: 95d1dacc00ee49fc
Message-ID: <10f740e80903300915n7eba3a51hd20ede39c76a9421@mail.gmail.com>
Subject: Re: [PATCH -next] exofs: fix printk format warnings
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 23:44, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix exofs printk format warnings:
>
> fs/exofs/inode.c:184: warning: format '%zx' expects type 'size_t', but argument 6 has type 'long unsigned int'
> fs/exofs/inode.c:291: warning: format '%zx' expects type 'size_t', but argument 6 has type 'long unsigned int'
> fs/exofs/inode.c:373: warning: format '%zx' expects type 'size_t', but argument 7 has type 'long unsigned int'
> fs/exofs/inode.c:461: warning: format '%zx' expects type 'size_t', but argument 6 has type 'long unsigned int'
> fs/exofs/inode.c:534: warning: format '%zx' expects type 'size_t', but argument 7 has type 'long unsigned int'
> fs/exofs/inode.c:610: warning: format '%zx' expects type 'size_t', but argument 5 has type 'long unsigned

It also wouldn't hurt to
  - kill EXOFS_DBGMSG()
  - s/EXOFS_DBGMSG/pr_debug/g
  - #define pr_fmt(fmt) "%s: " fmt, __func__

That way we always get printf()-style warning checking, even if
CONFIG_EXOFS_DEBUG
is not enabled.

Similar for EXOFS_ERR() -> pr_err()

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
