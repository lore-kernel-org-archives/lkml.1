Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbYI1QOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbYI1QOn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 12:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYI1QOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 12:14:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:42551 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYI1QOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 12:14:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=d3tFVfRQIPcMoMF2Hpy9sl7PuFknW7kLzH0dIDk95NU4Fg4AH/e/abLj9svXqjATiR
         QKCeY7UrhBZMNkt4F375qQ3UYjGAMw+oP/JmMk/f8Yl4NP4k6ZaIaJalqgYH87eiwko5
         TFwIi0PWS9vv38ypNBfQWn42ksxh8LLJuq6Nk=
Message-ID: <48DFAD63.4010007@gmail.com>
Date: Sun, 28 Sep 2008 18:14:27 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Gregory Nietsky <gregory@dnstelecom.co.za>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: Re: [ath5k-devel] [PATCH 1/1] Ath5k: add AP mode
References: <1222519728-14989-1-git-send-email-jirislaby@gmail.com> <48DF6535.8080407@dnstelecom.co.za>
In-Reply-To: <48DF6535.8080407@dnstelecom.co.za>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2008 01:06 PM, Gregory Nietsky wrote:
> 
> Quick Observation  ...
> 
> it appears IEEE80211 types have been replaced with NL80211 types in
> kernel ... so would the following not be more correct and is opmode not
> defined as
> 
> struct ath5k_softc {
> ....
>        enum nl80211_iftype     opmode;
> .....

It already is.

> @@ -2130,14 +2129,15 @@ ath5k_beacon_config(struct ath5k_softc *sc)
> 
>                sc->imask |= AR5K_INT_SWBA;
> 
> -               if (ath5k_hw_hasveol(ah)) {
> -                       spin_lock(&sc->block);
> -                       ath5k_beacon_send(sc);
> -                       spin_unlock(&sc->block);
> -               }
> +               if (sc->opmode == NL80211_IFTYPE_ADHOC) {
> +                       if (ath5k_hw_hasveol(ah)) {
> +                               spin_lock(&sc->block);
> +                               ath5k_beacon_send(sc);
> +                               spin_unlock(&sc->block);
> +                       }
> +               } else
> +                       ath5k_beacon_update_timers(sc, -1);

Yeah, that's the correct hunk, thanks. I sent a non-updated version.

