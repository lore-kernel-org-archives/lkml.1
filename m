Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbYH0T0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbYH0T0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 15:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYH0T0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 15:26:34 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:38910 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbYH0T0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 15:26:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uLT0Antfmc9X9Pi/JOBdRd217SkltKreUhAY2UAfucI5omdgxgCn4jR3sCVM7dEpkQ
         z6wECkbYn26qO7S/SyPAiaWZYH4zCfQVqt3K1l+GkvrJ296XoUNwaq2FgLpussEIeZzM
         1xySzhpmPFRaTJ2eK1v6nIooF1DUZpwlHH/2M=
Message-ID: <1ba2fa240808271226i95a7789k481a68b09dc60164@mail.gmail.com>
Date: Wed, 27 Aug 2008 22:26:31 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
       "Michael Buesch" <mb@bu3sch.de>
Subject: Re: pull request: wireless-2.6 2008-08-26
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080827013009.GA15781@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080827013009.GA15781@tuxdriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> John W. Linville (1):
>      mac80211: quiet chatty IBSS merge message

This patch is correct yet it suppresses an important warning, meaning
that you have constant IBSS reconnection, remove all connected station
and adding them again, This greatly degraded performance. This is
caused by inability to adjust to TSF of the IBSS leader

<snipt>
static int ieee80211_sta_join_ibss(struct net_device *dev,
				   struct ieee80211_if_sta *ifsta,
				   struct ieee80211_sta_bss *bss)
.....
/* Remove possible STA entries from other IBSS networks. */
	sta_info_flush_delayed(sdata);
</snip>

> Assaf Krauss (1):
>      iwlwifi: W/A for the TSF correction in IBSS
>

This patch fixes this problem in iwlwifi

We've observed same problem with the broadcom card

Tomas
