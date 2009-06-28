Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbZF1UUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbZF1UUq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 16:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZF1UUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 16:20:38 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:60095 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbZF1UUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 16:20:37 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Arseniy Lartsev <ars3n@yandex.ru>, USB list <linux-usb@vger.kernel.org>
Subject: Re: PROBLEM: USB ACM device does not work
Date: Sun, 28 Jun 2009 22:20:49 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.30-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200906282229.35713.ars3n@yandex.ru>
In-Reply-To: <200906282229.35713.ars3n@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906282220.50313.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 28. Juni 2009 20:29:26 schrieb Arseniy Lartsev:
> I've got a piece of hardware (this one:
> http://masterkit.ru/main/set.php?num=1153) which acts like an USB ACM
> device and is handeled by the cdc_acm module. /dev/ttyACM0 does appear
> but any attempt to write something to the device with a simple
> "echo something >/dev/ttyACM0" fails with "Invalid argument" error.
>
> The reason is that the driver calls usb_submit_urb in acm_start_wb()
> but doesn't set interval in the urb structure, so it remains zero and
> causes usb_submit_urb to return -EINVAL. Reading from device also does
> not work due to the same problem in acm_rx_tasklet().

This is supposed to write to bulk endpoints. There's no reason interval
would need to be specified. Something is very odd. Please post "lsusb -v".

	Regards
		Oliver

