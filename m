Return-Path: <linux-kernel-owner+w=401wt.eu-S1764216AbYBWUhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764216AbYBWUhs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 15:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759048AbYBWUhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 15:37:19 -0500
Received: from qb-out-0506.google.com ([72.14.204.229]:64721 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334AbYBWUhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 15:37:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sQ97p0nZYTtRpFFMwzxdOWg3SgdRQiyhl3WlekNwA0WYo9NW4Of47jmRpa3+2JLBYRAVoeYXWIKf9SWxPkrxFXILZDpVqo0Gz6wqqvxqs8n4XrOaGSPvswr4z8sxWANlUrxdQwizR0BDY1nwbq/ywwn44GrDs6MlXOUiozY6CGU=
Message-ID: <f19298770802231237m520e0158ldce3ae422796ae3b@mail.gmail.com>
Date: Sat, 23 Feb 2008 23:37:13 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH] Fix the bcm43xx driver breakage in 2.6.24/25.
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
       "Stefano Brivio" <stefano.brivio@polimi.it>,
       "Jeff Garzik" <jgarzik@pobox.com>, "Greg KH" <greg@kroah.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200802231720.21920.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47C01D03.9030601@gmail.com> <200802231720.21920.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 7:20 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Saturday 23 February 2008 14:17:55 Alexey Zaytsev wrote:
>  > diff --git a/drivers/net/wireless/bcm43xx/Kconfig b/drivers/net/wireless/bcm43xx/Kconfig
>  > index 0159701..afb8f43 100644
>  > --- a/drivers/net/wireless/bcm43xx/Kconfig
>  > +++ b/drivers/net/wireless/bcm43xx/Kconfig
>  > @@ -1,6 +1,6 @@
>  >  config BCM43XX
>  >       tristate "Broadcom BCM43xx wireless support (DEPRECATED)"
>  > -     depends on PCI && IEEE80211 && IEEE80211_SOFTMAC && WLAN_80211 && EXPERIMENTAL
>  > +     depends on PCI && IEEE80211 && IEEE80211_SOFTMAC && WLAN_80211 && (!SSB_B43_PCI_BRIDGE || SSB != y) && EXPERIMENTAL
>
>  so if SSB is m it will break module auto-loading, right?
>

Right.
If ssb == m, you can at least unload the ssb module manually, or
specify the right
module to load. In the first patch I sent to you, it was
"!SSB_B43_PCI_BRIDGE" instead of
"(!SSB_B43_PCI_BRIDGE || SSB != y)", but I thought that there is no reason to
completely hide the bcm43xx option if ssb is compiled as module.
