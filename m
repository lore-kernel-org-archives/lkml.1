Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895Ab0A0XzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0A0XzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740Ab0A0XzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:55:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753719Ab0A0XzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:55:21 -0500
Date: Wed, 27 Jan 2010 15:55:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: jon - <crayzeejon@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH] Generic PS/2 mouse detected on Fujitsu Lifebook
 B-Series  model laptop instead of LBPS/2 Fujitsu Lifebook TouchScreen
Message-Id: <20100127155514.cc743fa4.akpm@linux-foundation.org>
In-Reply-To: <a05e21071001250812x4461e4a0re7f46f7cd28c4162@mail.gmail.com>
References: <a05e21071001250812x4461e4a0re7f46f7cd28c4162@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(suitable cc's added)

On Mon, 25 Jan 2010 16:12:43 +0000
jon - <crayzeejon@gmail.com> wrote:

> From: Jon Dodgson <crayzeejon@gmail.com>
> 
> Fix Detection of Lifebook B-Series Laptop touch screen with DMI
> product Name string 'Lifebook B Series'
> 
> Signed-off-by: Jon Dodgson <crayzeejon@gmail.com>
> 
> ---
> diff -Nurb linux-2.6.26.2/drivers/input/mouse/lifebook.c
> linux-2.6.26.2_patched/drivers/input/mouse/lifebook.c
> --- linux-2.6.26.2/drivers/input/mouse/lifebook.c    2008-08-06
> 17:19:01.000000000 +0100
> +++ linux-2.6.26.2_patched/drivers/input/mouse/lifebook.c    2010-01-25
> 02:56:41.000000000 +0000
> @@ -51,6 +51,12 @@
>     {
>         .ident = "LifeBook B",
>         .matches = {
> +            DMI_MATCH(DMI_PRODUCT_NAME, "Lifebook B Series"),
> +        },
> +    },
> +    {
> +        .ident = "LifeBook B",
> +        .matches = {
>             DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook B Series"),
>         },
>     },

So the problem is "LifeBook" versus "Lifebook"?  These matches are
case-sensitive?

I don't know what kernel you were patching, but current kernels no
longer have the ".ident" initialisation in that table.  If it _was_
still there then I'd wonder why you set the ident to "LifeBook B"
rather than "Lifebook B".

Your email client wordwrapped the patch and replaced its tabs with
spaces.

Anyway, thanks.  Please work this with Dmitry.
