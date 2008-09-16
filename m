Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbYIPUop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbYIPUop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 16:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbYIPUod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 16:44:33 -0400
Received: from phoenix.slamd64.com ([217.10.145.2]:45832 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbYIPUod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 16:44:33 -0400
Message-ID: <39295.87.81.255.5.1221597846.squirrel@phoenix.slamd64.com>
In-Reply-To: <20080916195134.GB14879@srcf.ucam.org>
References: <48CFC03A.8020708@lwfinger.net> <200809161742.15527.mb@bu3sch.de>
    <48CFE820.7010305@lwfinger.net>
    <20080916195134.GB14879@srcf.ucam.org>
Date: Tue, 16 Sep 2008 20:44:06 -0000 (UTC)
Subject: Re: Regression in 2.6.27-rcX caused by commit 
     bc19d6e0b74ef03a3baf035412c95192b54dfc6f
From: "Carlos Corbacho" <carlos@strangeworlds.co.uk>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Cc: "Larry Finger" <larry.finger@lwfinger.net>,
       "Adel Gadllah" <adel.gadllah@gmail.com>,
       "wireless" <linux-wireless@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>, "Michael Buesch" <mb@bu3sch.de>,
       bcm43xx-dev@lists.berlios.de
User-Agent: SquirrelMail/1.4.13
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [0.0.0.0]); Tue, 16 Sep 2008 20:44:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/net/wireless/b43/rfkill.c
> b/drivers/net/wireless/b43/rfkill.c
> index fec5645..e8b2acb 100644
> --- a/drivers/net/wireless/b43/rfkill.c
> +++ b/drivers/net/wireless/b43/rfkill.c
> @@ -49,21 +49,18 @@ static void b43_rfkill_update_state(struct b43_wldev
> *dev)
>  	struct b43_rfkill *rfk = &(dev->wl->rfkill);
>
>  	if (!dev->radio_hw_enable) {
> -		rfk->rfkill->state = RFKILL_STATE_HARD_BLOCKED;
> +		rfkill_force_state(rfk->rfkill, RFKILL_STATE_HARD_BLOCKED);
>  		return;
>  	}
>
>  	if (!dev->phy.radio_on)
> -		rfk->rfkill->state = RFKILL_STATE_SOFT_BLOCKED;
> +		rfkill_force_state(rfk->rfkill, RFKILL_STATE_SOFT_BLOCKED);
>  	else
> -		rfk->rfkill->state = RFKILL_STATE_UNBLOCKED;
> -
> +		rfkill_force_state(rfk->rfkill, RFKILL_STATE_UNBLOCKED);
>  }

Just this should be enough to fix the regression for 2.6.27 (and should be
trivial to port to b43legacy) in the immediate term (I was planning to
send something similar).

The rest of the patch is out-of-scope for 2.6.27, but is definitely along
he right lines, IMHO (and it would be good if we can get a working version
of it in to 2.6.28). I may try and look at it later, as I do have my b43
hardware handy.

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
