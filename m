Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbYH3SF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbYH3SF2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 14:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYH3SFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 14:05:14 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:41963 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbYH3SFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 14:05:13 -0400
Date: Sat, 30 Aug 2008 13:05:03 -0500
From: David Fries <david@fries.net>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org, p_gortmaker@yahoo.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] ne.c fix, res->name
Message-ID: <20080830180503.GI25161@spacedout.fries.net>
References: <20080830024425.GA24929@spacedout.fries.net> <20080831.000357.70223885.anemo@mba.ocn.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080831.000357.70223885.anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Sat, 30 Aug 2008 13:05:05 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 12:03:57AM +0900, Atsushi Nemoto wrote:
> On Fri, 29 Aug 2008 21:44:25 -0500, David Fries <david@fries.net> wrote:
> > +	if (!strcmp(res->name, BAD_STR))
> > +		dev->mem_end = BAD;
> 
> The res->name might be NULL.  You should check it first.
> 
> 	if (res->name && !strcmp(res->name, BAD_STR))
> 		dev->mem_end = BAD;

The name gets a valid string by that point in time.

drivers/base/platform.c:257
int platform_device_add(struct platform_device *pdev)

        for (i = 0; i < pdev->num_resources; i++) {
                struct resource *p, *r = &pdev->resource[i];

                if (r->name == NULL)
                        r->name = pdev->dev.bus_id;

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
