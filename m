Return-Path: <linux-kernel-owner+w=401wt.eu-S1763617AbZCaWJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763617AbZCaWJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763504AbZCaWI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:08:57 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:46728 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763512AbZCaWI4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:08:56 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Larry Finger <Larry.Finger@lwfinger.net>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/2 V2] kaweth: Fix locking to be SMP-safe
Date: Wed, 1 Apr 2009 00:13:04 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.29-9-default; KDE/4.1.3; x86_64; ; )
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <49d264dd.YwbXLw18YaD1tQqD%Larry.Finger@lwfinger.net>
In-Reply-To: <49d264dd.YwbXLw18YaD1tQqD%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904010013.05494.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 31 März 2009 20:45:49 schrieb Larry Finger:

> @@ -796,7 +799,7 @@ static int kaweth_start_xmit(struct sk_b

> @@ -848,7 +851,7 @@ skip:
>  		net->trans_start = jiffies;
>  	}
>
> -	spin_unlock(&kaweth->device_lock);
> +	spin_unlock_irq(&kaweth->device_lock);

Here you enable interrupts. Are you sure ndo_start_xmit is never
called with interrupts disabled?

	Regards
		Oliver

