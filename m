Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbYFJL60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbYFJL60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 07:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYFJL6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 07:58:16 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:44327 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbYFJL6P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 07:58:15 -0400
Date: Tue, 10 Jun 2008 13:58:04 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Ben Nizette <bn@niasdigital.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kernel@avr32linux.org
Subject: Re: Latest gpio gumph
Message-ID: <20080610135804.1dabc170@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <200805292018.50051.david-b@pacbell.net>
References: <1211942475.27810.37.camel@moss.renham>
	<200805280201.24256.david-b@pacbell.net>
	<20080528112109.47747cb5@hskinnemo-gx745.norway.atmel.com>
	<200805292018.50051.david-b@pacbell.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 10 Jun 2008 11:57:17.0226 (UTC) FILETIME=[212808A0:01C8CAF1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell <david-b@pacbell.net> wrote:
> [ Re that one avr32 patch: ]
> 
> On Wednesday 28 May 2008, Haavard Skinnemoen wrote:
> > I'm not really opposed to the second change; I would have applied it if
> > it came separately. But I think the first change is wrong.
> 
> OK, then feel free to strip out the first chunk and just take that.

Applied the patch below. Thanks.

Haavard

>From bab0d89419e2d30199420da0af29a8b5662af018 Mon Sep 17 00:00:00 2001
From: David Brownell <dbrownell@users.sourceforge.net>
Date: Tue, 10 Jun 2008 13:55:52 +0200
Subject: [PATCH] avr32: minor GPIO handling updates

On the odd chance some code uses a pin as a GPIO IRQ without calling
gpio_request() or gpio_direction_input(), the debug dump should still
show its pin status.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 arch/avr32/mach-at32ap/pio.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/mach-at32ap/pio.c b/arch/avr32/mach-at32ap/pio.c
index 38a8fa3..60da03b 100644
--- a/arch/avr32/mach-at32ap/pio.c
+++ b/arch/avr32/mach-at32ap/pio.c
@@ -318,6 +318,8 @@ static void pio_bank_show(struct seq_file *s, struct gpio_chip *chip)
 		const char *label;
 
 		label = gpiochip_is_requested(chip, i);
+		if (!label && (imr & mask))
+			label = "[irq]";
 		if (!label)
 			continue;
 
-- 
1.5.5.3

