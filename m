Return-Path: <linux-kernel-owner+w=401wt.eu-S1764229AbXHABHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764229AbXHABHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 21:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759558AbXHABGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 21:06:50 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57309 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbXHABGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 21:06:49 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46AFDC9A.1050901@s5r6.in-berlin.de>
Date: Wed, 01 Aug 2007 03:06:34 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: jack@hawkeye.stone.uk.eu.org
CC: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Mikael Starvik <starvik@axis.com>
Subject: Re: [Patch 01/16] Remove unnecessary kmalloc casts from the cris
 arch.
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org> <20070731125438.132063000@hawkeye.stone.uk.eu.org>
In-Reply-To: <20070731125438.132063000@hawkeye.stone.uk.eu.org>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jack@hawkeye.stone.uk.eu.org wrote:
> --- a/arch/cris/arch-v32/mm/intmem.c
> +++ b/arch/cris/arch-v32/mm/intmem.c
> @@ -28,7 +28,7 @@ static void crisv32_intmem_init(void)
>  	static int initiated = 0;
>  	if (!initiated) {
>  		struct intmem_allocation* alloc =
> -		  (struct intmem_allocation*)kmalloc(sizeof *alloc, GFP_KERNEL);
> +				kmalloc(sizeof *alloc, GFP_KERNEL);
>  		INIT_LIST_HEAD(&intmem_allocations);
>  		intmem_virtual = ioremap(MEM_INTMEM_START, MEM_INTMEM_SIZE);
>  		initiated = 1;
> 

Would be nice if you increased the indentation of the kmalloc line for
better readability, now that the expression is shorter.

In the rest of arch/cris/arch-v32/mm/intmem.c, one tab is typically used
for such continuation indentations.  However, intmem.c is not a prime
example for good whitespace usage, so you could as well use two tabs.

Also note that there are two more kmallocs with unnecessary cast in the
same file, at least in 2.6.23-rc1.  Would be nice if you cleaned up the
whole file at once.

There is also a shadowing of a local variable (tmp) by another local
variable of the same name.  Maybe you could submit another cleanup patch
for that too while you are at it?
-- 
Stefan Richter
-=====-=-=== =--- ----=
http://arcgraph.de/sr/
