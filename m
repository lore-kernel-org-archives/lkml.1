Return-Path: <linux-kernel-owner+w=401wt.eu-S1751765AbZLJOUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbZLJOUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 09:20:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbZLJOUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 09:20:05 -0500
Received: from smtp.nokia.com ([192.100.122.233]:32634 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbZLJOUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 09:20:04 -0500
Date: Thu, 10 Dec 2009 16:19:38 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Grazvydas Ignotas <notasas@gmail.com>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI
 charger
Message-ID: <20091210141938.GA12526@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <6ed0b2680912021234x6b5e6058p6d50d5cd20ecf019@mail.gmail.com>
 <20091202204946.GB25682@nokia.com>
 <6ed0b2680912021329g372bd0a4vb5b4a80244960f95@mail.gmail.com>
 <20091202215442.GA30658@oksana.dev.rtsoft.ru>
 <20091202223156.GA14921@nokia.com>
 <20091202225922.GA15568@oksana.dev.rtsoft.ru>
 <20091203083958.GB31110@nokia.com>
 <6ed0b2680912030255o57d7c46qb5ae1cfcb82e9976@mail.gmail.com>
 <20091203110332.GO1361@nokia.com>
 <6ed0b2680912100609g11706296qdbcea887dc3a5733@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <6ed0b2680912100609g11706296qdbcea887dc3a5733@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 Dec 2009 14:19:45.0845 (UTC) FILETIME=[D2E6C650:01CA79A3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 10, 2009 at 03:09:08PM +0100, ext Grazvydas Ignotas wrote:
>Ok since it doesn't look like this will resolve soon, what about
>adding some DEVICE_ATTR for the time being and requiring userspace to
>write charge current here to start actual charging?

We can get the charging current from configuration.

When gadget driver call usb_gadget_vbus_draw() we can use that to pass 
the information somewhere else.

But what I'm doing now is implementing an atomic_notifier which will 
call whatever function another driver want whenever we have twl4030-usb 
irqs.

We can use that to kick the charger detection itself (on twl4030-usb) 
and you can register your notifier_block callback to enable charging as 
you wish.

Then we will have the charger detection done on the right place 
(twl4030-usb) and the charging start done on the right place 
(twl4030-bci or bq24xxx).

Thanks to Anton Vorontsov <avorontsov@ru.mvista.com> for suggesting 
that.

-- 
balbi
