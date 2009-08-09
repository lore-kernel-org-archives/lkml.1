Return-Path: <linux-kernel-owner+w=401wt.eu-S1751780AbZHIQGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbZHIQGF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 12:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbZHIQGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 12:06:04 -0400
Received: from mail-vw0-f172.google.com ([209.85.212.172]:41171 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbZHIQGD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 12:06:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sUs+dylKDP3GtT7O405++InNvMPdlk9KCUOePZRyN1+kt1OWA2K/UdozCPpP/L86Gt
         XhseRorLngI0p0Yps1BJ83l1L9uoPpBdiP7ybfbziBb60VQyn1hBrdYk/FFLAoI49VB2
         KroACJcG1WfTsFdN8qpm3pxix1xY0KZr1wmQY=
MIME-Version: 1.0
In-Reply-To: <20090807215155.GA17043@sig21.net>
References: <20090807215155.GA17043@sig21.net>
Date: Sun, 9 Aug 2009 12:06:03 -0400
X-Google-Sender-Auth: fd02bb4dfcd797ba
Message-ID: <b6c5339f0908090906p3d29fdd2x8473dcc6df178167@mail.gmail.com>
Subject: Re: 2.6.31-rc5 regression: ath5k broken after suspend-to-ram
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Stezenbach <js@sig21.net>
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 7, 2009 at 5:51 PM, Johannes Stezenbach<js@sig21.net> wrote:
> Hi,

Hi!

> If I use nl80211 the second ifup fails with
> "SIOCSIFFLAGS: Input/output error" messages and the follwing
> is in dmesg:
>
>   ath5k phy0: failed to wakeup the MAC Chip
>   ath5k phy0: can't reset hardware (-5)

Ok, does this patch help the above?

http://patchwork.kernel.org/patch/38550/

>   Aug  7 20:13:28 void wpa_supplicant[9932]: Trying to associate with 00:00:00:00:00:00 (SSID='...' freq=2412 MHz)

I assume in all cases you have elided the mac addresses and they
are the same in all of the examples?  (You can keep the first three
octets in the future, they are just vendor information.)

>   Aug  7 23:10:08 void kernel: wlan0: RX AssocResp from 00:00:00:00:00:00 (capab=0x411 status=0 aid=1)
>   Aug  7 23:10:08 void kernel: wlan0: associated
>   Aug  7 23:10:08 void wpa_supplicant[16215]: Associated with 00:00:00:00:00:00
>   Aug  7 23:10:08 void wpa_supplicant[16215]: WPA: Key negotiation completed with 00:00:00:00:00:00 [PTK=CCMP GTK=TKIP]
>   Aug  7 23:10:08 void wpa_supplicant[16215]: CTRL-EVENT-CONNECTED - Connection to 00:00:00:00:00:00 completed (auth) [id=0 id_str=]
>   Aug  7 23:10:12 void wpa_supplicant[16215]: CTRL-EVENT-SCAN-RESULTS
>   Aug  7 23:10:12 void wpa_supplicant[16215]: Trying to associate with 00:00:00:00:00:00 (SSID='...' freq=2412 MHz)

Hmm so it completed association... then 4 seconds later, got some
scan results and tried again.  Odd.

> During resume the following is logged:
>
>   ath5k 0000:02:02.0: restoring config space at offset 0x3 (was 0x5008, writing 0xa808)
>   pm_op(): pci_pm_resume+0x0/0x79 returns -16
>   PM: Device 0000:00:00.0 failed to resume: error -16
>
> Not sure if this is causing the problem?

-EBUSY... not sure.

> In case it matters:
>  CONFIG_MAC80211_DEFAULT_PS=y
>  CONFIG_MAC80211_DEFAULT_PS_VALUE=1

That's for 802.11 power saving which ath5k doesn't do yet, so it
doesn't matter here.

Ok thanks for the very detailed report, I'll take a look.  My
hardware suspends/resumes under 2.6.31, but I do have a few
differences in my setup compared to yours.

-- 
Bob Copeland %% www.bobcopeland.com
