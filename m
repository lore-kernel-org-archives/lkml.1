Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbZG0LSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbZG0LSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 07:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756073AbZG0LSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 07:18:12 -0400
Received: from relay.atmel.no ([80.232.32.139]:51767 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756066AbZG0LSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 07:18:12 -0400
Date: Mon, 27 Jul 2009 13:17:58 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Ben Nizette <ben@niasdigital.com>
Cc: kernel <kernel@avr32linux.org>,
       "Egtvedt, Hans-Christian" <Hans-Christian.Egtvedt@atmel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] favr32: improve touchscreen response
Message-ID: <20090727131758.050ca571@hskinnemoen-d830>
In-Reply-To: <1246002577.9414.62.camel@linux-51e8.site>
References: <1240195013.24329.38.camel@linux-51e8.site>
	<1246002577.9414.62.camel@linux-51e8.site>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Nizette wrote:
> Hi Haavard,
> 
> This has hce's ack, any chance of getting it in .31?

Yeah, should be a good chance :-) Sorry for taking so long.

It doesn't apply, however. I ended up doing this:

diff --git a/arch/avr32/boards/favr-32/setup.c b/arch/avr32/boards/favr-32/setup.c
index 46c9b0a..75f19f4 100644
--- a/arch/avr32/boards/favr-32/setup.c
+++ b/arch/avr32/boards/favr-32/setup.c
@@ -72,6 +72,10 @@ static struct ads7846_platform_data ads7843_data = {
 	.debounce_max		= 20,
 	.debounce_rep		= 4,
 	.debounce_tol		= 5,
+
+	.keep_vref_on		= true,
+	.settle_delay_usecs	= 500,
+	.penirq_recheck_delay_usecs = 100,
 };
 
 static struct spi_board_info __initdata spi1_board_info[] = {

It appears to compile, but please verify that it's still correct.

Haavard
