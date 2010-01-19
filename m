Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630Ab0ASWgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab0ASWgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 17:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754428Ab0ASWgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 17:36:13 -0500
Received: from mail.perches.com ([173.55.12.10]:1302 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab0ASWgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 17:36:13 -0500
Subject: Re: [RFC] [PATCH] watchdog_info separation and constify
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Florian Fainelli <florian@openwrt.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       uclinux-dist-devel@blackfin.uclinux.org, linux-omap@vger.kernel.org
In-Reply-To: <20100119221647.GC29306@sirena.org.uk>
References: <20100119211759.GE3804@infomag.iguana.be>
	 <1263937351.18117.69.camel@Joe-Laptop.home>
	 <20100119221647.GC29306@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 14:36:11 -0800
Message-ID: <1263940571.18117.86.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 22:16 +0000, Mark Brown wrote:
> On Tue, Jan 19, 2010 at 01:42:31PM -0800, Joe Perches wrote:
> > Maybe a standard #define WATCHDOG_NAME <foo>
> > .identity = WATCHGOD_NAME
> 
> I don't really see that the indrection via the #define would buy us
> anything?

Maybe not, just a suggestion.
There are already 17 uses though.

It might have some value like DRV_NAME does or
any other frequent #define used in printks or
#include code.

It may be useful standardization prior to or post
some generic watchdog code consolidation.

$ grep -r --include=*.[ch] -Poh "^#define\s*\w+NAME\b" drivers | \
  sed -r -e 's/\s+/ /g' | sort | uniq -c | sort -rn | head -10
    334 #define DRV_NAME
    137 #define DRIVER_NAME
     59 #define MODULE_NAME
     25 #define DRVNAME
     21 #define DRV_MODULE_NAME
     18 #define DEVICE_NAME
     17 #define WATCHDOG_NAME
     15 #define MY_NAME
     12 #define BOARD_MAP_NAME
     11 #define DSS_SUBSYS_NAME


