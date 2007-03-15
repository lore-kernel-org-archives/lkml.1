Return-Path: <linux-kernel-owner+w=401wt.eu-S932794AbXCOTJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbXCOTJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932699AbXCOTIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:08:49 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36748 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbXCOTIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:08:42 -0400
Date: Thu, 15 Mar 2007 11:08:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pavel@ucw.cz, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] swsusp: Do not use page flags
Message-Id: <20070315110816.8b4102b3.akpm@linux-foundation.org>
In-Reply-To: <200703122219.21171.rjw@sisk.pl>
References: <200703122214.02657.rjw@sisk.pl>
	<200703122219.21171.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 12 Mar 2007 22:19:20 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> +int create_basic_memory_bitmaps(void)
> +{
> +	struct memory_bitmap *bm1, *bm2;
> +	int error = 0;
> +
> +	BUG_ON(forbidden_pages_map || free_pages_map);
> +
> +	bm1 = kzalloc(sizeof(struct memory_bitmap), GFP_ATOMIC);
> +	if (!bm1)
> +		return -ENOMEM;
> +
> +	error = memory_bm_create(bm1, GFP_ATOMIC | __GFP_COLD, PG_ANY);
> +	if (error)
> +		goto Free_first_object;
> +
> +	bm2 = kzalloc(sizeof(struct memory_bitmap), GFP_ATOMIC);
> +	if (!bm2)
> +		goto Free_first_bitmap;
> +
> +	error = memory_bm_create(bm2, GFP_ATOMIC | __GFP_COLD, PG_ANY);
> +	if (error)

What is the risk that we'll go OOM here?  GFP_ATOMIC is rather unreliable.

And why _does_ suspend use GFP_ATOMIC all over the place?
