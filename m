Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbXLRXhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbXLRXhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 18:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbXLRXgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 18:36:52 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60694 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753566AbXLRXgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 18:36:51 -0500
Date: Tue, 18 Dec 2007 15:36:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marcin =?ISO-8859-1?Q?=5F=5Flusarz?= <marcin.slusarz@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/storage/initializers.c: fix signedness difference
Message-Id: <20071218153642.cf8c6a0b.akpm@linux-foundation.org>
In-Reply-To: <20071209212337.GA9440@joi>
References: <20071209212337.GA9440@joi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Dec 2007 22:23:42 +0100
Marcin __lusarz <marcin.slusarz@gmail.com> wrote:

> usb/storage/initializers.c: fix signedness difference
> 
> Signed-off-by: Marcin __lusarz <marcin.slusarz@gmail.com>
> ---
>  drivers/usb/storage/initializers.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/storage/initializers.c b/drivers/usb/storage/initializers.c
> index ee5b42a..187dd1e 100644
> --- a/drivers/usb/storage/initializers.c
> +++ b/drivers/usb/storage/initializers.c
> @@ -66,7 +66,8 @@ int usb_stor_ucr61s2b_init(struct us_data *us)
>  {
>  	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap*) us->iobuf;
>  	struct bulk_cs_wrap *bcs = (struct bulk_cs_wrap*) us->iobuf;
> -	int res, partial;
> +	int res;
> +	unsigned int partial;
>  	static char init_string[] = "\xec\x0a\x06\x00$PCCHIPS";
> 
>  	US_DEBUGP("Sending UCR-61S2B initialization packet...\n");

Often we just wouldn't bother about something this minor.

But I see later on that we pass the address of `partial' into some other
function and I am guessing that this produces some warning with some tool
which you didn't tell us about? 
