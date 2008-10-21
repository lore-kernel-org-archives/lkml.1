Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbYJUSIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbYJUSIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 14:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbYJUSIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 14:08:44 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:54502 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYJUSIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 14:08:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KerYUq9g4Dr0S1rWrIjSicmWWhPbfuqh/DAp1bVho0ji9VKD7+tfMR1ZGE4C3bqRWY
         IAgNj6QuBREPWlSnmn3SE8uDSWoVYrW7kz6KxnJ6FUome3URg1udYNS8bBxTiFmr4sBN
         dp6RfahZm95uQ4kZotgmGQ60N2XnchCpkEsCI=
Message-ID: <40f31dec0810211108l6700d806o4804b43d9fe47bf7@mail.gmail.com>
Date: Tue, 21 Oct 2008 21:08:41 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>,
       "Gregory Nietsky" <gregory@dnstelecom.co.za>
Subject: Re: [PATCH 1/1] Ath5k: add AP mode
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1223844850-26551-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223844850-26551-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/12 Jiri Slaby <jirislaby@gmail.com>:
> Add support for AP mode. This involves:
> - enablement in ath5k_beacon_config -- initialize beacon timer
> - add AP to the supported modes in ath5k_add_interface
> - handle beacon change even for AP in ath5k_config_interface
> - remove useless test for IBSS in ath5k_beacon_update
>
> Note that it doesn't enable the AP mode for the driver. It must
> be enabled by NL80211_IFTYPE_AP bit added to interface_modes.
>
> v2:
> Fixed opmode constant (IEEE80211_ to NL80211_)
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Nick Kossifidis <mickflemm@gmail.com>
> Cc: Luis R. Rodriguez <mcgrof@gmail.com>

a) It won't work without the following as Gregory pointed out
diff --git a/drivers/net/wireless/ath5k/base.c
b/drivers/net/wireless/ath5k/base.c
index e09ed2c..69aad6e 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -488,6 +488,7 @@ ath5k_pci_probe(struct pci_dev *pdev,

       hw->wiphy->interface_modes =
               BIT(NL80211_IFTYPE_STATION) |
+               BIT(NL80211_IFTYPE_AP) |
               BIT(NL80211_IFTYPE_ADHOC) |
               BIT(NL80211_IFTYPE_MESH_POINT);

b) For some reason it only works with 5212/5213 cards, i tested it on
a 5413 and an 2425 and it didn't work (hostapd seems to hang).




-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
