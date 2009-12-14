Return-Path: <linux-kernel-owner+w=401wt.eu-S1756973AbZLNLlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbZLNLlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 06:41:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756921AbZLNLlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 06:41:08 -0500
Received: from smtp.nokia.com ([192.100.105.134]:54216 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790AbZLNLlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 06:41:05 -0500
Date: Mon, 14 Dec 2009 13:40:09 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: "ext Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       David Brownell <david-b@pacbell.net>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       "Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@openedhand.com>
Subject: Re: [RFC/PATCH 2/4] input: misc: twl4030: move to
 request_threaded_irq
Message-ID: <20091214114009.GI12526@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <20091212183410.GF3092@sirena.org.uk>
 <1260786654-13294-3-git-send-email-felipe.balbi@nokia.com>
 <EAF47CD23C76F840A9E7FCE10091EFAB02BC1421BD@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB02BC1421BD@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 14 Dec 2009 11:40:39.0091 (UTC) FILETIME=[423EB830:01CA7CB2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 14, 2009 at 12:31:11PM +0100, ext Shilimkar, Santosh wrote:
>In whole of the series the ISR you have converted to threads using threaded_irq are very
>small in size. They are like quick_change_handlers. So only advantage is the particular
>interrupt is masked for bit longer than with you change.
>
>I might be wrong here but it might introduce the spurious IRQ's because 
>of bit of delay in the processing.What is the motive for this change ? 
>Are we using this API as it suppose to be ?

the irq chip is connected through i2c and that mandate us to handle irqs 
in thread context. Now that we have kernel-wise api for that, we're just 
moving towards it instead of definint our own stuff and the lockdep 
shortcuts we had to put before.

I boot tested these patches on a 3430-based board and it seems to be 
working fine. Did a few tests with usb only. I can see I get the usb 
presence irq correctly.

-- 
balbi
