Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbZFQI3C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbZFQI3C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 04:29:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbZFQI2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 04:28:48 -0400
Received: from mail.hevs.ch ([153.109.23.10]:55582 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430AbZFQI2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 04:28:47 -0400
X-Greylist: delayed 1180 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jun 2009 04:28:47 EDT
From: Marc Pignat <marc.pignat@hevs.ch>
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 5/6] atmel-mci: Power control option for each MMC Slot
Date: Wed, 17 Jun 2009 10:08:57 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.26-2-686; KDE/4.2.2; i686; ; )
Cc: Rob Emanuele <rob@emanuele.us>, nicolas.ferre@atmel.com,
       haavard.skinnemoen@atmel.com, linux-kernel@vger.kernel.org
References: <1245200079-6323-1-git-send-email-rob@emanuele.us> <1245200079-6323-5-git-send-email-rob@emanuele.us>
In-Reply-To: <1245200079-6323-5-git-send-email-rob@emanuele.us>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906171008.58382.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Wednesday 17 June 2009 02:54:38 Rob Emanuele wrote:
> Add support to the atmel-mci driver for a VCC pin in order to conserve power by removing power from an MMC Slot.
...

> @@ -1544,6 +1544,13 @@ static int __init atmci_init_slot(struct atmel_mci *host,
>  		}
>  	}
>  
> +	if (gpio_is_valid(slot->vcc_pin)) {
> +		if (gpio_request(slot->vcc_pin, "mmc_pow")) {

gpio_request will check for "gpio_is_valid" so this is not necessary.

> +			dev_dbg(&mmc->class_dev, "no power pin available\n");
> +			slot->vcc_pin = -EBUSY;
> +		}
> +	}
> +
...

Best regards

Marc
