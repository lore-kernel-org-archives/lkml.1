Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbZLCLEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbZLCLEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 06:04:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbZLCLEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 06:04:10 -0500
Received: from smtp.nokia.com ([192.100.122.233]:23860 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbZLCLEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 06:04:09 -0500
Date: Thu, 3 Dec 2009 13:03:32 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Grazvydas Ignotas <notasas@gmail.com>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       ext Anton Vorontsov <avorontsov@ru.mvista.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI
 charger
Message-ID: <20091203110332.GO1361@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1259333060-24277-1-git-send-email-notasas@gmail.com>
 <20091202173321.GA23738@nokia.com>
 <6ed0b2680912021234x6b5e6058p6d50d5cd20ecf019@mail.gmail.com>
 <20091202204946.GB25682@nokia.com>
 <6ed0b2680912021329g372bd0a4vb5b4a80244960f95@mail.gmail.com>
 <20091202215442.GA30658@oksana.dev.rtsoft.ru>
 <20091202223156.GA14921@nokia.com>
 <20091202225922.GA15568@oksana.dev.rtsoft.ru>
 <20091203083958.GB31110@nokia.com>
 <6ed0b2680912030255o57d7c46qb5ae1cfcb82e9976@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <6ed0b2680912030255o57d7c46qb5ae1cfcb82e9976@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 03 Dec 2009 11:03:50.0409 (UTC) FILETIME=[4B395790:01CA7408]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 03, 2009 at 11:55:12AM +0100, ext Grazvydas Ignotas wrote:
>TPS65950 is catalog part of TWL4030 and has documentation here:
>http://focus.ti.com/docs/prod/folders/print/tps65950.html#technicaldocuments
>
>It says that it is software's responsibility to detect the device and
>set the right charge mode/current..

yes, the BCI (or bq24xxx) will never be able to know which configuration 
we were enumerated with...

>> yes, that'll work. But how about start charging always with 100mA and if
>> userland sees that we were enumerated it reconfigures charging as necessary.
>> But this would mean that we have the EM daemon started up just after the
>> driver itself is loaded to avoid the problem with 100ms no enumeration. How
>> does that sound ? Do we start making some writeable power_supply sysfs ???
>
>There are also USB chargers that don't enumerate and have D+ and D-
>shorted with a resistor (see "dedicated charger port" in the charging
>spec), how do we support those?

dedicated chargers are simple. You kick the charger detection according 
to USB BC 1.x and if it returns true, you configure high current 
charging. Host/Hub chargers are also simple, after kicking charger 
detection, you enable Data pullups (e.g. SOFTCONN bit in musb's power 
register) and see if the host sends a setup packet...

the complicated part is passing the information of which configuration 
you were enumerated with to the charger chip.

-- 
balbi
