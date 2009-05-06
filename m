Return-Path: <linux-kernel-owner+w=401wt.eu-S1756459AbZEFHRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbZEFHRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 03:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757760AbZEFHQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 03:16:51 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:58965 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932AbZEFHQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 03:16:49 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/5] usb_debug: implement multi urb write
Date: Wed, 6 May 2009 09:16:56 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1241575205-12199-1-git-send-email-jason.wessel@windriver.com> <1241575205-12199-2-git-send-email-jason.wessel@windriver.com>
In-Reply-To: <1241575205-12199-2-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200905060916.56384.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n467HZqu012814

Am Mittwoch, 6. Mai 2009 04:00:01 schrieb Jason Wessel:
in static void usb_debug_write_bulk_callback(struct urb *urb)> +Â Â Â Â Â Â Â if (status) {> +Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â dbg("nonzero write bulk status received: %d", status);> +Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â return;> +Â Â Â Â Â Â Â }
[..]> +Â Â Â Â Â Â Â spin_lock_irqsave(&priv->tx_lock, flags);> +Â Â Â Â Â Â Â --priv->tx_outstanding_urbs;> +Â Â Â Â Â Â Â spin_unlock_irqrestore(&priv->tx_lock, flags);
That's a clear bug. If a URB finishes, you must decrease the counter, alwaysand without exception, even if status indicates an error.
	Regards		Oliver
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
