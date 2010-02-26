Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936140Ab0BZNIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 08:08:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:60228 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936021Ab0BZNIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 08:08:46 -0500
Subject: Re: [PATCH] mtd: misplaced parenthesis in find_boot_record()
From: David Woodhouse <dwmw2@infradead.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-mtd@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B79C344.60908@gmail.com>
References: <4B79C344.60908@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Feb 2010 13:08:40 +0000
Message-ID: <1267189720.30247.10867.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-15 at 22:57 +0100, Roel Kluin wrote:
> The parenthesis was misplaced, upon error a one was shown.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

> ---
> diff --git a/drivers/mtd/inftlmount.c b/drivers/mtd/inftlmount.c
> index 32e82ae..a269c62 100644
> --- a/drivers/mtd/inftlmount.c
> +++ b/drivers/mtd/inftlmount.c
> @@ -102,7 +102,7 @@ static int find_boot_record(struct INFTLrecord *inftl)
>  		/* To be safer with BIOS, also use erase mark as discriminant */
>  		if ((ret = inftl_read_oob(mtd, block * inftl->EraseSize +
>  					  SECTORSIZE + 8, 8, &retlen,
> -					  (char *)&h1) < 0)) {
> +					  (char *)&h1)) < 0) {

Ick.

This code is broken because it's fugly. You can see the causality just
by looking at it.

Why on earth would you fix the bug but not fix the fugliness which
caused it?

   ret = inftl_read_oob(...);
   if (ret < 0) {



-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

