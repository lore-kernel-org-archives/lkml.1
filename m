Return-Path: <linux-kernel-owner+w=401wt.eu-S1760913AbYJNAYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760913AbYJNAYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 20:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758252AbYJNAYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 20:24:00 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:47419 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244AbYJNAX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 20:23:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WdcoywShQE8kodveY9ZDWcv0eTCdkN3Pfru315ratHlL2N6X/dIqTAfXALgSAQ/AL6
         0qdxv58wI+8J9NVDpm+ZDdqjoYbnxppUjLGekANcD5cgv801NlARrSsu2WQzHD4ZawB/
         kATaxM4AxKUDk902/g/iNpTWJSX5ZcmjBFEfM=
Message-ID: <43e72e890810131723k227ff97bya17aee0d9a5da2b@mail.gmail.com>
Date: Mon, 13 Oct 2008 17:23:57 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Linux 2.6.27-git3: rtl8169 oops and wireless missing symbols
Cc: "=?UTF-8?Q?J.A._Magall=C3=B3n?=" <jamagallon@ono.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "Dan Williams" <dcbw@redhat.com>,
       "Tim Gardner" <tim.gardner@canonical.com>
In-Reply-To: <20081013232432.GB32550@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20081014010202.71d13eaf@werewolf.home>
	 <20081013232432.GB32550@tuxdriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m9E0OSdq016808

On Mon, Oct 13, 2008 at 4:24 PM, John W. Linville<linville@tuxdriver.com> wrote:> On Tue, Oct 14, 2008 at 01:02:02AM +0200, J.A. MagallÃ³n wrote:>>> werewolf:~# modprobe ath5k>> WARNING: Error inserting cfg80211 (/lib/modules/2.6.27-jam03/kernel/net/wireless/cfg80211.ko): Unknown symbol in module, or unknown parameter (see dmesg)>> WARNING: Error inserting mac80211 (/lib/modules/2.6.27-jam03/kernel/net/mac80211/mac80211.ko): Unknown symbol in module, or unknown parameter (see dmesg)>> FATAL: Error inserting ath5k (/lib/modules/2.6.27-jam03/kernel/drivers/net/wireless/ath5k/ath5k.ko): Unknown symbol in module, or unknown parameter (see dmesg)>> werewolf:~# modprobe mac80211>> WARNING: Error inserting cfg80211 (/lib/modules/2.6.27-jam03/kernel/net/wireless/cfg80211.ko): Unknown symbol in module, or unknown parameter (see dmesg)>> FATAL: Error inserting mac80211 (/lib/modules/2.6.27-jam03/kernel/net/mac80211/mac80211.ko): Unknown symbol in module, or unknown parameter (see dmesg)>>>> Dmesg is below.>> cfg80211 isn't loading, so mac80211 can't find it's symbols, and> ath5k can't find mac80211's symbols.
What symbols?
sudo rmmod ath5ksudo dmesg -c > /dev/nullsudo modprobe ath5ksudo dmesg -c
>> cfg80211: Unknown parameter `ieee80211_regdom'
Ahh this one.. this is the 2 character module parameter you can passto cfg80211 upon load and this is available only whenCONFIG_WIRELESS_OLD_REGULATORY is enabled.
I still don't see why you are seeing this, as your modprobe commanddid not pass any module parameter options.. do you have some optionsfor cfg8021 in your distribution place for them on /etc/ somewhere?
> config WIRELESS_OLD_REGULATORY>        bool "Old wireless static regulatory definitions">        default n>        ---help--->          This option enables the old static regulatory information>          and uses it within the new framework. This is available>          temporarily as an option to help prevent immediate issues>          due to the switch to the new regulatory framework which>          does require a new userspace application which has the>          database of regulatory information (CRDA) and another for>          setting regulatory domains (iw).>>          For more information see:>>          http://wireless.kernel.org/en/developers/Regulatory/CRDA>          http://wireless.kernel.org/en/users/Documentation/iw>>          It is important to note though that if you *do* have CRDA present>          and if this option is enabled CRDA *will* be called to update the>          regulatory domain (for US and JP only). Support for letting the user>          set the regulatory domain through iw is also supported. This option>          mainly exists to leave around for a kernel release some old static>          regulatory domains that were defined and to keep around the old>          ieee80211_regdom module parameter. This is being phased out and you>          should stop using them ASAP.>>          Say N unless you cannot install a new userspace application>          or have one currently depending on the ieee80211_regdom module>          parameter and cannot port it to use the new userspace interfaces.>>          This is scheduled for removal for 2.6.29.>> Is this not clear enough?
I am in hopes distributions can start packaging iw and crda soonerrather than later, if not we will have to consider pushing the removalof this option for until 2.6.30 and also set it to default in 2.6.28(?). I'd hate to see this but I guess this is reasonable since noteven NM is yet asking yet cfg80211 to set the regulatory domain to aspecific country.
  Luisÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
