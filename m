Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbZHGROZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbZHGROZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 13:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbZHGROY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 13:14:24 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:37816 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbZHGROY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 13:14:24 -0400
Message-ID: <4A7C5FAB.2020304@csr.com>
Date: Fri, 07 Aug 2009 18:08:59 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Anton Vorontsov <avorontsov@ru.mvista.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Pierre Ossman <pierre@ossman.eu>,
       Kumar Gala <galak@kernel.crashing.org>, Ben Dooks <ben@fluff.org>,
       Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
       sdhci-devel@lists.ossman.eu, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 3/4] sdhci-of: Fix high-speed cards recognition
References: <20090807163940.GA29192@oksana.dev.rtsoft.ru> <20090807165015.GB524@oksana.dev.rtsoft.ru>
In-Reply-To: <20090807165015.GB524@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Aug 2009 17:08:59.0102 (UTC) FILETIME=[C11417E0:01CA1781]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:
> eSDHC fails to recognize some SDHS cards, throwing timeout errors:
> 
>   mmc0: error -110 whilst initialising SD card
> 
> That's because we calculate timeout value in a wrong way: on eSDHC
> hosts the timeout clock is derivied from the SD clock, which is set
> dynamically.

I've seen an reference design for an SDHC controller do this also.

> +/* Controller has dynamic timeout clock management */
> +#define SDHCI_QUIRK_DYNAMIC_TIMEOUT_CLOCK		(1<<24)

This comment and define would be better if it matched terms used in the
spec.  Suggest:

/* Controller uses SDCLK instead of TMCLK for data timeouts. */
#define SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK  (1 << 24)

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


'member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom'
