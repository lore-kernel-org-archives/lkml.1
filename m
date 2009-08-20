Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbZHTI6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbZHTI6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 04:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbZHTI6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 04:58:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53389 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbZHTI6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 04:58:18 -0400
Date: Thu, 20 Aug 2009 10:57:24 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dirk Behme <dirk.behme@googlemail.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tim Bird <tim.bird@am.sony.com>, kernel@pengutronix.de
Subject: Re: New fast(?)-boot results on ARM
Message-ID: <20090820085724.GG23444@pengutronix.de>
References: <20090814170228.GM13320@pengutronix.de> <20090818140605.GB9943@pengutronix.de> <4A8AC95E.2040907@googlemail.com> <20090819072100.GA23444@pengutronix.de> <4A8C263D.9000009@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8C263D.9000009@googlemail.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 09:08:57 up 14 days, 18:28, 17 users,  load average: 8.73, 7.43,
	3.40
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 06:20:13PM +0200, Dirk Behme wrote:
>>
>> Yes, correct. The copying itself is between 'copy' and 'done' so it
>> takes about 0.4s.
>>
>>> What's the size of the uncompressed kernel copied here?
>>
>> The image is about 2.8MB, but I copied the whole partition of 3MB
>> because with raw images you can't detect the image size.
>
> With 3MB copied in ~0.4s you get ~8MB/s. This really depends on your HW, 
> but I would think with standard NOR flashes you should be able to do at 
> least two (three?) times better. Have you already checked the memory (NOR 
> flash) timings configured in your SoC?

It's NAND flash, so there's not much timing to optimize. What's
interesting about this is that the kernel NAND driver is much slower
than the one in U-Boot. Looking at it it turned out that the kernel
driver uses interrupts to wait for the controller to get ready.
Switching this to polling nearly doubles the NAND performance. UBI
mounts much faster now and this cuts off another few seconds from the
boot process :)

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
