Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbZLOKlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbZLOKlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 05:41:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757951AbZLOKlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 05:41:06 -0500
Received: from emita2.mittwald.de ([85.199.129.253]:50046 "EHLO
	emita2.mittwald.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930AbZLOKlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 05:41:05 -0500
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Dec 2009 05:41:05 EST
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: wext: allocate space for NULL-termination for 32byte SSIDs
Date: Tue, 15 Dec 2009 11:30:58 +0100
User-Agent: KMail/1.9.7
Cc: Johannes Berg <johannes@sipsolutions.net>,
       David Miller <davem@davemloft.net>, daniel@caiaq.de,
       linux-kernel@vger.kernel.org, dcbw@redhat.com, m.hirsch@raumfeld.com,
       netdev@vger.kernel.org, libertas-dev@lists.infradead.org,
       stable@kernel.org
References: <1260650850-16163-1-git-send-email-daniel@caiaq.de> <1260871411.3692.4.camel@johannes.local> <1260871634.3692.6.camel@johannes.local>
In-Reply-To: <1260871634.3692.6.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912151130.59103.holgerschurig@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> drivers/net/wireless/libertas$ grep lbs_deb_ * | grep ssid
> |grep '%s' 
> assoc.c:	lbs_deb_join("current SSID '%s', ssid length %u\n",
> assoc.c:	lbs_deb_join("requested ssid '%s', ssid length %u\n",
> assoc.c:	lbs_deb_join("ADHOC_START: SSID '%s', ssid
>               length %u\n", 
> scan.c:		lbs_deb_wext("set_scan, essid '%s'\n",

All those lines are gone once my cfg80211 lands.

Do you know any way to make sparse moan about them?


BTW: the libertas firmware sometimes treat an SSID as a 
zero-terminated string. There are some firmware commands that 
accept just an u8[32] bytes for the SSID, but not an ssid_len, 
e.g. in the CMD_802_11_AD_HOC_START command.

You therefore can't connect to the otherwise legitimate SSID of 
TEST\0\0\0.

-- 
http://www.holgerschurig.de
