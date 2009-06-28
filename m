Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbZF1U6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbZF1U6H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 16:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZF1U5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 16:57:55 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:54066 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbZF1U5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 16:57:54 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Arseniy Lartsev <ars3n@yandex.ru>, USB list <linux-usb@vger.kernel.org>
Subject: Re: PROBLEM: USB ACM device does not work
Date: Sun, 28 Jun 2009 22:58:07 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.30-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200906282229.35713.ars3n@yandex.ru>
In-Reply-To: <200906282229.35713.ars3n@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906282258.08277.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 28. Juni 2009 20:29:26 schrieb Arseniy Lartsev:
> The reason is that the driver calls usb_submit_urb in acm_start_wb()
> but doesn't set interval in the urb structure, so it remains zero and
> causes usb_submit_urb to return -EINVAL. Reading from device also does

That simply does not make sense. Have you confirmed that this check:

	switch (xfertype) {
	case USB_ENDPOINT_XFER_ISOC:
	case USB_ENDPOINT_XFER_INT:
		/* too small? */
		if (urb->interval <= 0)
			return -EINVAL;

really triggers?

	Regards
		Oliver

