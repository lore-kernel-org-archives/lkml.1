Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbXLDHpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbXLDHpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 02:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbXLDHpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 02:45:09 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:58720 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbXLDHpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 02:45:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TEmgvvJCmUVyclLv31PPKNGhT0HXFaefRWYtnoDPDo3K6WrJqStdmQ0RRMK45vdQEIjQ4QJdIzs8H9mHD7NyXsTumU0gU4qWoyV44KDg8iphQQAH5HKa/cPXBHEvBFdxe/leDKJqw8NHlRS+782g+cQoHHW1g0cgTwYUU0OG8Fo=
Message-ID: <84144f020712032345r6fc1f44cg5f35b23bdb8191be@mail.gmail.com>
Date: Tue, 4 Dec 2007 09:45:06 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [PATCH] pktcdvd : add kobject_put when kobject register fails
Cc: petero2@telia.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071204013144.GA2850@darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071204013144.GA2850@darkstar.lan>
X-Google-Sender-Auth: 24c7a31f6819b807
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Dec 4, 2007 3:31 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
> Kobject_put should be called when kobject register functioin fails, so the
> the kobj ref count touch zero and then the proper cleanup routines will be
> called.

[snip]

> diff -upr linux/drivers/block/pktcdvd.c linux.new/drivers/block/pktcdvd.c
> --- linux/drivers/block/pktcdvd.c       2007-11-30 13:13:44.000000000 +0800
> +++ linux.new/drivers/block/pktcdvd.c   2007-11-30 13:24:08.000000000 +0800
> @@ -117,8 +117,10 @@ static struct pktcdvd_kobj* pkt_kobj_cre
>         p->kobj.parent = parent;
>         p->kobj.ktype = ktype;
>         p->pd = pd;
> -       if (kobject_register(&p->kobj) != 0)
> +       if (kobject_register(&p->kobj) != 0) {
> +               kobject_put(&p->kobj);
>                 return NULL;

This looks wrong to me. AFAICT the only thing that can fail
kobject_register() is kobject_add() and it cleans up after itself. Am
I missing something here?

                           Pekka
