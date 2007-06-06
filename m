Return-Path: <linux-kernel-owner+w=401wt.eu-S934148AbXFFASQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934148AbXFFASQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 20:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765730AbXFFASE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 20:18:04 -0400
Received: from smtp-out.google.com ([216.239.45.13]:17805 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763875AbXFFASB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 20:18:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:to:cc:subject:message-id:in-reply-to:
	references:x-mailer:mime-version:content-type:content-transfer-encoding;
	b=nJmOGH6HfagJ4lYGbhA3c3djKdh8MTIlcyupsAEgYRBIncUiNRyuXSbhqhbwBTAGh
	ws5YdSR0jf2eNfsGNBWFA==
Date: Tue, 5 Jun 2007 17:17:45 -0700
From: Andrew Morton <akpm@google.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, "Ingo Korb" <ingo@akana.de>
Subject: Re: [PATCH 1/3] Char: stallion, don't fail with less than max
 panels
Message-Id: <20070605171745.1ea5b88f.akpm@google.com>
In-Reply-To: <1058130869771517818@wsc.cz>
References: <1058130869771517818@wsc.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Jun 2007 23:20:57 +0200 (CEST)
Jiri Slaby <jirislaby@gmail.com> wrote:

> stallion, don't fail with less than max panels
>

Why not?

What problem is this patch fixing, and how does it fix it?

What are the consequences of not having this patch in the kernel?

etc.  More complete changlogs, please.

> 
> diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
> index e45113a..265abad 100644
> --- a/drivers/char/stallion.c
> +++ b/drivers/char/stallion.c
> @@ -2172,7 +2172,7 @@ static int __devinit stl_initech(struct stlbrd *brdp)
>  		}
>  		status = inb(ioaddr + ECH_PNLSTATUS);
>  		if ((status & ECH_PNLIDMASK) != nxtid)
> -			goto err_fr;
> +			break;
>  		panelp = kzalloc(sizeof(struct stlpanel), GFP_KERNEL);
>  		if (!panelp) {
>  			printk("STALLION: failed to allocate memory "
