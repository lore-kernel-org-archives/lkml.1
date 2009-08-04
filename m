Return-Path: <linux-kernel-owner+w=401wt.eu-S932960AbZHDQEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960AbZHDQEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932890AbZHDQEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:04:14 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:34359 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824AbZHDQEL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:04:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xR8vzH2KFhRp/0Eajr9pEPsYDe351dZeyVQj529LsR7i96nPlH60mYf2hbPh2qXgei
         Fe/xHtBb1zdtT4EfGfU0ewEGb4DVYgSuDknH99dhrvCR4FFVIRqnl9ky9NcV/+cnDPHP
         Raorpor/xl8ccYfIP3L41HA4Z8mVlQDWkSzqo=
MIME-Version: 1.0
In-Reply-To: <200908032217.19947.IvDoorn@gmail.com>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera>
	 <iZB3Pj-uj3M.A.pRC.1cgdKB@chimera>
	 <200908031931.27427.chris2553@googlemail.com>
	 <200908032217.19947.IvDoorn@gmail.com>
Date: Tue, 4 Aug 2009 17:04:10 +0100
Message-ID: <c6b1100b0908040904q158bd08ex5d570b7c0624c295@mail.gmail.com>
Subject: Re: [Bug #13846] Possible regression in rt61pci driver
From: Chris Clayton <chris2553@googlemail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Ivo,

2009/8/3 Ivo van Doorn <ivdoorn@gmail.com>:
> Hi,
>
>> On Sunday 02 August 2009, Rafael J. Wysocki wrote:
>> > This message has been generated automatically as a part of a report
>> > of recent regressions.
>> >
>> > The following bug entry is on the current list of known regressions
>> > from 2.6.30.  Please verify if it still should be listed and let me know
>> > (either way).
>> >
>>
>> The folks on the wireless project have concluded that the problem I reported is down to a hardware
>> problem when power saving is switched on on for my Belkin cardbus wireless adapter, so now I simply
>> turn power-saving off when wlan0 comes up. I did, however, ask whether anyone was going to fix the
>> fact that once power-saving turns the LEDs off, they never come back on again, but I haven't had an
>> answer. Is that a regression? I guess the answer is no, because power saving in the rt61pci driver
>> is feature that is new to 2.6.31. Should it be fixed? I think the answer is yes, but being unable
>> to do it myself, I probably don't have a vote :-)
>
> Can't recall this issue was ever reported, but that might just be me having overlooked some emails
> or have completely forgotten all about it. But here is a test patch to see if this helps in the issue,
> it is not really correct for upstream, but if it works I can see if there is a better solution.
>
> Thanks,
>

I've tried the patch without success. The card doesn't seem to wake up
again when I attempt network activity after PS has activated.
(Actually, There are two assumptions I should check out here. Firstly,
the LEDS going out is a sign that PS has activated and secondly, that
the card should "wake up" if I attempt network activity after PS has
activated).

A cut and paste from the console window:

[chris:~]$ iwconfig
lo        no wireless extensions.

wmaster0  no wireless extensions.

wlan0     IEEE 802.11bg  ESSID:"SKY28767"
          Mode:Managed  Frequency:2.412 GHz  Access Point: 00:1F:33:80:09:44
          Bit Rate=1 Mb/s   Tx-Power=10 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:on
          Link Quality=50/70  Signal level=-60 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

[chris:~]$ echo "waiting for leds to go out"
waiting for leds to go out
[chris:~]$ ping router
PING router.local.lan (192.168.0.1) from 192.168.0.30 : 56(84) bytes of data.
>From laptop.local.lan (192.168.0.30): Destination Host Unreachable
>From laptop.local.lan (192.168.0.30): Destination Host Unreachable
>From laptop.local.lan (192.168.0.30): Destination Host Unreachable
>From laptop.local.lan (192.168.0.30): Destination Host Unreachable
>From laptop.local.lan (192.168.0.30): Destination Host Unreachable
>From laptop.local.lan (192.168.0.30): Destination Host Unreachable
>From laptop.local.lan (192.168.0.30): Destination Host Unreachable
>From laptop.local.lan (192.168.0.30): Destination Host Unreachable
>From laptop.local.lan (192.168.0.30): Destination Host Unreachable
^C
--- router.local.lan ping statistics ---
11 packets transmitted, 0 packets received, +9 errors, 100% packet loss
[chris:~]$

To get the card going again I had to physically remove and reinsert it.

Chris

> Ivo
> ---
> diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
> index 3845316..6fe70b1 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00config.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00config.c
> @@ -196,6 +196,12 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
>         */
>        rt2x00dev->ops->lib->config(rt2x00dev, &libconf, ieee80211_flags);
>
> +       if (ieee80211_flags & IEEE80211_CONF_CHANGE_PS) {
> +               rt2x00led_led_activity(rt2x00dev, !(conf->flags & IEEE80211_CONF_PS));
> +               rt2x00leds_led_assoc(rt2x00dev, !(conf->flags & IEEE80211_CONF_PS));
> +               rt2x00leds_led_radio(rt2x00dev, !(conf->flags & IEEE80211_CONF_PS));
> +       }
> +
>        /*
>         * Some configuration changes affect the link quality
>         * which means we need to reset the link tuner.
>



-- 
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samuel
Johnson
