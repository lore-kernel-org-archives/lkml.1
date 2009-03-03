Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbZCCR4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbZCCR4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 12:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZCCRzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 12:55:53 -0500
Received: from fifo99.com ([67.223.236.141]:44454 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZCCRzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 12:55:52 -0500
Subject: Re: [patch 3/3] xtensa: ccount clocksource
From: Daniel Walker <dwalker@fifo99.com>
To: Johannes Weiner <jw@emlix.com>
Cc: Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
       Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <E1LeXJ1-00071v-Dy@mailer.emlix.com>
References: <E1LeXCe-0006wA-5k@mailer.emlix.com>
	 <E1LeXJ1-00071v-Dy@mailer.emlix.com>
Content-Type: text/plain
Date: Tue, 03 Mar 2009 09:55:45 -0800
Message-Id: <1236102945.5937.1.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 16:30 +0100, Johannes Weiner wrote:
> @ -29,6 +30,19 @@ unsigned long ccount_per_jiffy;              /* per 
>  unsigned long nsec_per_ccount;         /* nsec per ccount increment
> */
>  #endif
>  
> +static cycle_t ccount_read(void)
> +{
> +       return (cycle_t)get_ccount();
> +}
> +
> +static struct clocksource ccount_clocksource = {
> +       .name = "ccount",
> +       .rating = 200,
> +       .read = ccount_read,
> +       .mask = CLOCKSOURCE_MASK(32),
> +       .mult = NSEC_PER_CCOUNT,
> +};

You don't want to use the shift field?

Daniel

