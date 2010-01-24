Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143Ab0AXRPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab0AXRPZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 12:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700Ab0AXRPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 12:15:24 -0500
Received: from www84.your-server.de ([213.133.104.84]:50484 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab0AXRPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 12:15:23 -0500
Subject: Re: [PATCH 1/4] kernel/kfifo.c: fix "interger as NULL pointer"
 warning.
From: Stefani Seibold <stefani@seibold.net>
To: Thiago Farina <tfransosi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1264349038-1766-1-git-send-email-tfransosi@gmail.com>
References: <1264349038-1766-1-git-send-email-tfransosi@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 24 Jan 2010 18:15:24 +0100
Message-ID: <1264353324.5592.1.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 24.01.2010, 11:03 -0500 schrieb Thiago Farina:
> kernel/kfifo.c:83:35: warning: Using plain integer as NULL pointer
> 

I don't know where you get this kind of warning. But passing 0 for a
NULL pointer is ANSI C standard.

> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> ---
>  kernel/kfifo.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/kfifo.c b/kernel/kfifo.c
> index 32c5c15..6fe4a56 100644
> --- a/kernel/kfifo.c
> +++ b/kernel/kfifo.c
> @@ -80,7 +80,7 @@ int kfifo_alloc(struct kfifo *fifo, unsigned int size, gfp_t gfp_mask)
>  
>  	buffer = kmalloc(size, gfp_mask);
>  	if (!buffer) {
> -		_kfifo_init(fifo, 0, 0);
> +		_kfifo_init(fifo, NULL, 0);
>  		return -ENOMEM;
>  	}
>  


