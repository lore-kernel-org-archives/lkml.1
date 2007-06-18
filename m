Return-Path: <linux-kernel-owner+w=401wt.eu-S1761061AbXFRK1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761061AbXFRK1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbXFRK1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 06:27:39 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:54078 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbXFRK1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 06:27:39 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 18 Jun 2007 06:25:17 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Denis Cheng <crquan@gmail.com>
cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: the memset operation on a automatic array
 variable should be optimized out by data initialization
In-Reply-To: <467658db.0f98600a.5a55.ffffdd79@mx.google.com>
Message-ID: <Pine.LNX.4.64.0706180623280.11972@localhost.localdomain>
References: <467658db.0f98600a.5a55.ffffdd79@mx.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Denis Cheng wrote:

> From: Denis Cheng <crquan@gmail.com>
>
> the explicit memset call could be optimized out by data initialization,
> thus all the fill working can be done by the compiler implicitly.
>
> Signed-off-by: Denis Cheng <crquan@gmail.com>
>
> ---
> Is there some comments on this?
>
> --- arch/x86_64/mm/init.c.orig	2007-06-07 10:08:04.000000000 +0800
> +++ arch/x86_64/mm/init.c	2007-06-18 14:43:15.000000000 +0800
> @@ -406,8 +406,7 @@ void __cpuinit zap_low_mappings(int cpu)
>  #ifndef CONFIG_NUMA
>  void __init paging_init(void)
>  {
> -	unsigned long max_zone_pfns[MAX_NR_ZONES];
> -	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
> +	unsigned long max_zone_pfns[MAX_NR_ZONES] = { 0, };

the drawback i see to this is that it's *visually* misleading.  it
*appears* that what the programmer is trying to do is just initialize
the first element, not all of them -- regardless of the actual effect.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
