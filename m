Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbZF2JtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbZF2JtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756469AbZF2Jsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:48:55 -0400
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:51148 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969AbZF2Jsy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:48:54 -0400
From: Frans Pop <elendil@planet.nl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [2.6.31-rc1] iwlagn (4965): regression when hardware rf switch is used
Date: Mon, 29 Jun 2009 11:48:54 +0200
User-Agent: KMail/1.9.9
Cc: linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
       linux-kernel@vger.kernel.org
References: <200906291128.05639.elendil@planet.nl> <1246268022.7775.24.camel@johannes.local>
In-Reply-To: <1246268022.7775.24.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906291148.55386.elendil@planet.nl>
X-OriginalArrivalTime: 29 Jun 2009 09:48:56.0019 (UTC) FILETIME=[D1811A30:01C9F89E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 June 2009, Johannes Berg wrote:
> > [enable]
> > usb 3-1: new full speed USB device using uhci_hcd and address 3
> > usb 3-1: configuration #1 chosen from 1 choice
>
> That is completely unrelated. You plugged in a USB device too :)

No, it's my "bluetooth + wlan" device. Note that disabling wireless with 
the hardware switch also gives 'usb 3-1: USB disconnect, address 2'.

>From lsusb:
Bus 003 Device 002: ID 03f0:171d Hewlett-Packard Wireless (Bluetooth + 
WLAN) Interface [Integrated Module]

> > A lot uglier with those errors. And after that I have to run
> > ifdown/ifup before networking is up again (ifup only does not work as
> > it will complain "interface already configured"):
>
> And that's actually expected, and/or a bug in the debian networking
> scripts.
> (You can trigger the same problem by doing
> ifup wlan0
> ip link set wlan0 down
> ifup wlan0 -> error)

OK, I can accept that. Wonder why it does work with 2.6.30 then. But it 
can certainly wait until the driver problem you mentioned is resolved.

> To get your network connection back automatically we will require
> changes to userland tools to listen to rfkill events.
>
> > BTW, would it make sense to bring back the first two lines shown with
> > .30 (or at least the first one):
> >    iwlagn 0000:10:00.0: Radio Frequency Kill Switch is On:
> >    Kill switch must be turned off for wireless networking to work.
> > IMHO it's good to register the reason for the disconnect.
>
> I guess something like that could be added to cfg80211:
> phy0: taking interfaces down due to rfkill

Yes, that would be nice.

Thanks,
FJP
