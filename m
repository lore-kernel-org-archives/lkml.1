Return-Path: <linux-kernel-owner+w=401wt.eu-S1757493AbZLITqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbZLITqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757333AbZLITq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:46:28 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:46493 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256AbZLITq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:46:26 -0500
Date: Wed, 9 Dec 2009 20:46:31 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Julia Lawall <julia@diku.dk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/12] drivers/s390: Correct size given to memset
Message-ID: <20091209194631.GA4351@osiris.boeblingen.de.ibm.com>
References: <Pine.LNX.4.64.0912092024100.1870@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0912092024100.1870@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 08:24:28PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Memset should be given the size of the structure, not the size of the pointer.
...
> -	memset(tcat, 0, sizeof(tcat));
> +	memset(tcat, 0, sizeof(*tcat));
>  	/* Calculate tcw input/output count and tcat transport count. */
>  	count = calc_dcw_count(tccb);
>  	if (tcw->w && (tcw->flags & TCW_FLAGS_OUTPUT_TIDA))
> @@ -269,7 +269,7 @@ EXPORT_SYMBOL(tccb_init);
>   */
>  void tsb_init(struct tsb *tsb)
>  {
> -	memset(tsb, 0, sizeof(tsb));
> +	memset(tsb, 0, sizeof(*tsb));

Applied. Thank you!
