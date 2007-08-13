Return-Path: <linux-kernel-owner+w=401wt.eu-S965293AbXHMAAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965293AbXHMAAe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 20:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758210AbXHMAAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 20:00:23 -0400
Received: from canuck.infradead.org ([209.217.80.40]:35597 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbXHMAAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 20:00:22 -0400
Subject: Re: [PATCH] [MTD] Fix CFI build error with meaningless
	nonfunctional .config
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070812162417.GA15412@elte.hu>
References: <20070806161537.GA1269@elte.hu>
	 <1186717841.7282.104.camel@shinybook.infradead.org>
	 <20070810074140.GB28264@elte.hu>
	 <1186731902.3571.1.camel@shinybook.infradead.org>
	 <20070812162417.GA15412@elte.hu>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 08:00:11 +0800
Message-Id: <1186963211.3973.25.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-3.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-12 at 18:24 +0200, Ingo Molnar wrote:
> just found another one via randconfig, it fails with:
> 
>  In file included from drivers/mtd/chips/map_rom.c:16:
>  include/linux/mtd/map.h:128:2: error: #error "No bus width supported. What's the point?"
>
> config attached below. Because it's so nice to be able to keep a 
> randconfig build-test running overnight, i think this needs to be 
> fixed  too. (even if with just a runtime BUG())



On Fri, 2007-08-10 at 11:50 +0800, David Woodhouse wrote:
> -#error "No bus width supported. What's the point?"
> +#warning "No CONFIG_MTD_MAP_BANK_WIDTH_xx selected. No NOR chip support can work"
> +static inline int map_bankwidth(void *map)
> +{
> +       BUG(); 
> 
-- 
dwmw2

