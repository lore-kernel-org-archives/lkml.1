Return-Path: <linux-kernel-owner+w=401wt.eu-S1752840AbYHQHEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbYHQHEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 03:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbYHQHEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 03:04:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:39621 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbYHQHEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 03:04:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rHVsacMc7nYar5fheQAnHe2N9xBNvCncAiEMSXRO4vwDbbD8hg5Md8iWd1xitKlVxx
         M2t6TqMLkqKNJuOGPD7lvhp/E3sUC/96H/rQKSzPNgC2d5FxvXPbYh8xm7NPlde5aH+5
         OXwS7caVP589uYwvql8JP0E5yBTL1f6f8h4vs=
Message-ID: <1ba2fa240808170004p63b76db1l1fdfb1cf1cb41636@mail.gmail.com>
Date: Sun, 17 Aug 2008 10:04:12 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Mirco Tischler" <mt-ml@gmx.de>
Subject: Re: CPU load after killing iwlagn with RF kill switch
Cc: "Leonid Podolny" <leonidp.lists@gmail.com>, linux-kernel@vger.kernel.org,
       yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org, IvDoorn@gmail.com
In-Reply-To: <20080817035921.4d35ae0e@mtlp.12thdimension>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48A5EC02.4070303@gmail.com>
	 <20080817035921.4d35ae0e@mtlp.12thdimension>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2008 at 4:59 AM, Mirco Tischler <mt-ml@gmx.de> wrote:
> On Fri, 15 Aug 2008 23:50:10 +0300, Leonid Podolny wrote:
>> Hi,
>> With a new iwlagn driver and 2.6.27-rc3, if I turn off the wireless
>> (intel 4965ag) by RF kill switch, the CPU utilization of ksoftirqd
>> process raises to 100% and stays there until I rmmod the module.
>> Please let me know what further information I can provide.
>
> Hi
>
> Same on my machine with same chip and same kernel.
> If I use the switch on the side of my laptop to turn off wlan, ksoftirqd eats
> up one core of my cpu til I switch it on again or rmmod the iwlagn module. But
> when I switch it on before the device loses connection and then off a second
> time, I now get a (the) second ksoftirqd process eating up the other core too.
> This only happens if a connection is established, though.
> I'm not sure if this problem existed in 2.6.26 but I doubt it. (Will check if I
> find the time).
>
> My dmesg shows me this:
>
> [48067.257539] iwlagn: Radio Frequency Kill Switch is On:
> [48067.257539] Kill switch must be turned off for wireless networking to work.
> [48071.295154] wlan0: No ProbeResp from current AP 00:c0:a8:e5:e5:a5 - assume
> out of range
> [48072.099173] iwlagn: Error sending REPLY_ADD_STA: enqueue_hcmd failed: -5
> [48072.099260] mac80211-phy1: failed to remove key (0, 00:c0:a8:e5:e5:a5) from
> hardware (-5)
> [48072.206028] iwlagn: Error sending REPLY_ADD_STA: enqueue_hcmd failed: -5
> [48072.206028] mac80211-phy1: failed to remove key (1, ff:ff:ff:ff:ff:ff) from
> hardware (-5)
>
> The probably interesting parts of my config look like that:
>
> CONFIG_IWLWIFI=m
> CONFIG_IWLCORE=m
> CONFIG_IWLWIFI_LEDS=y
> CONFIG_IWLWIFI_RFKILL=y
> # CONFIG_IWLWIFI_DEBUG is not set
> CONFIG_IWLAGN=m
> CONFIG_IWLAGN_SPECTRUM_MEASUREMENT=y
> CONFIG_IWLAGN_LEDS=y
> CONFIG_IWL4965=y
> # CONFIG_IWL5000 is not set
> # CONFIG_IWL3945 is not set
>
> CONFIG_RFKILL=m
> # CONFIG_RFKILL_INPUT is not set
> CONFIG_RFKILL_LEDS=y
> CONFIG_IWLWIFI_RFKILL=y
>
> I can recompile with debug options set if this helps. Just haven't found the
> time.

There is gap in current rfkill implementation that we didn't close
yet.  There were also few patches that were not signed by Intel and
are apparently wrong.
Tomas.


> Thanks
> Mirco
>
> P.S.: added some cc's for iwlwifi and rfkill.
>
