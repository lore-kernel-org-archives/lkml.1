Return-Path: <linux-kernel-owner+w=401wt.eu-S1751368AbZL1KVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbZL1KVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:21:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbZL1KVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:21:10 -0500
Received: from relay.atmel.no ([80.232.32.139]:51108 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbZL1KVJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:21:09 -0500
Date: Mon, 28 Dec 2009 11:20:28 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Peter =?UTF-8?B?SMO8d2U=?= <PeterHuewe@gmx.de>
Cc: "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Ma <pma@mediamatech.com>, linux-kernel@vger.kernel.org,
       linux-mmc@vger.kernel.org
Subject: Re: [PATCH] arch/avr32: Fix build failure for avr32 caused by typo
Message-ID: <20091228112028.5babace2@hskinnemoen-d830>
In-Reply-To: <200912281059.30450.PeterHuewe@gmx.de>
References: <200912252008.45602.PeterHuewe@gmx.de>
	<20091228091318.454c4713@hcegtvedt.norway.atmel.com>
	<200912281059.30450.PeterHuewe@gmx.de>
Organization: Atmel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hüwe <PeterHuewe@gmx.de> wrote:
> Great, thanks for the update.
> The only thing that still catches my eye is that the kzalloc line can fail, so 
> you should perhaps add something like
> if (!slave) {
> 	printk(KERN_ERR "No memory left for at32ap700x: at32_add_device_mc");
> 	goto fail;
> }

I agree, except that this is extremely unlikely to happen, so we should
either drop the printk() or use pr_debug() in order to waste as little
memory as possible in production systems.

I think your first patch is good as it is, so I will apply it. Please
send any additional fixes as a separate patch.

Haavard
