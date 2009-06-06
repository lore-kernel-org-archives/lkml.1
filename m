Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbZFFK4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbZFFK4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 06:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbZFFK4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 06:56:08 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:54060 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbZFFK4G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 06:56:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=s4GZ3lyC9d6OranelHYXm9re4YNa17X3b4VbviAiKf/NEXxEgaCItDzpjTlY1dpZC+
         ci1bwE1cmTj2WZP6V+1Td4P24BBTuLOMv/W9XV23FV8uMqVJmRRflud6423vks55fqeh
         z/aP1sc6ebtz7EvQk0dZ4icomovkfTTSfRsB0=
MIME-Version: 1.0
In-Reply-To: <1244285472.3185.36.camel@myhost>
References: <1244285472.3185.36.camel@myhost>
Date: Sat, 6 Jun 2009 13:56:07 +0300
X-Google-Sender-Auth: d86f09aa0700f8b4
Message-ID: <84144f020906060356v20cb0f8bk83e702de751f9f5e@mail.gmail.com>
Subject: Re: [PATCH] no need for checking it
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Figo.zhang" <figo1802@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Ian Abbott <abbotti@mev.co.uk>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       David Schleef <ds@schleef.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 6, 2009 at 1:51 PM, Figo.zhang <figo1802@gmail.com> wrote:
> vfree() does it's own NULL checking,so no need for check before
> calling it.
>
> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> ---
>  drivers/staging/comedi/drivers.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers.c
> b/drivers/staging/comedi/drivers.c
> index 6e13e45..ce50e85 100644
> --- a/drivers/staging/comedi/drivers.c
> +++ b/drivers/staging/comedi/drivers.c
> @@ -495,9 +495,9 @@ int comedi_buf_alloc(struct comedi_device *dev,
> struct comedi_subdevice *s,
>                                vmap(pages, n_pages, VM_MAP,
>                                PAGE_KERNEL_NOCACHE);
>                }
> -               if (pages) {
> -                       vfree(pages);
> -               }
> +               vfree(pages);
> +               pages = NULL;

Why the assignment to NULL? It looks redundant to me.

> +
>                if (async->prealloc_buf == NULL) {
>                        /* Some allocation failed above. */
>                        if (async->buf_page_list) {
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
