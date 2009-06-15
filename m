Return-Path: <linux-kernel-owner+w=401wt.eu-S1765290AbZFOSZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765290AbZFOSZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763692AbZFOSZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:25:37 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:55696 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765216AbZFOSZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:25:37 -0400
MIME-Version: 1.0
In-Reply-To: <4A3674B0.8050004@atmel.com>
References: <c8284b5b0906121802h3545fbfflf498fbba30fe42be@mail.gmail.com>
	 <4A3674B0.8050004@atmel.com>
Date: Mon, 15 Jun 2009 11:17:36 -0700
X-Google-Sender-Auth: 61bd12cc37d9f83f
Message-ID: <c8284b5b0906151117j14c0ced0oe7530d9cce33d5bd@mail.gmail.com>
Subject: Re: [PATCH 5/6] Unified AVR32/AT91 MCI Driver Support for a VCC Pin
From: Rob Emanuele <poorarm@shoreis.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Andrew Victor <avictor.za@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       drzeus-mmc@drzeus.cx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas,

On Mon, Jun 15, 2009 at 9:20 AM, Nicolas Ferre<nicolas.ferre@atmel.com> wrote:
> Rob Emanuele :
>> Add support to the atmel-mci driver for a VCC pin in order to conserve
>> power if the MMC interface is powered down.
>
> Can you elaborate a bit more. In particular, I do not understand the
> concept of "vcc_pin_act_low".
>

Like the original at91_mci driver, this patch adds the ability to use
a pin to toggle 3.3V power going to the SD Card.  In my case the pin
is tied to a International Rectifier 6420 P-type MOSFET since a port
pin alone cannot drive the SD Card.  When I pull the vcc_pin low, 3.3V
can reach the SD Card to power it.  The "vcc_pin_act_low" (pin active
low) determines which way the pin should be pulled to enable power to
the SD Card.  If vcc_pin_act_low is true, when the card needs to get
powered up, it sets the vcc_pin low.  Other board designs may need a
pin driven high to power the SD Card.

Thanks,

Rob
