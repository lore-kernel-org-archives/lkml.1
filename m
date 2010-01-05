Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117Ab0AEMYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab0AEMYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 07:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177Ab0AEMYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 07:24:37 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36968 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab0AEMYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 07:24:36 -0500
Date: Tue, 5 Jan 2010 13:24:22 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Hein_Tibosch <hein_tibosch@yahoo.es>
Cc: Pierre Ossman <pierre@ossman.eu>, Ben Nizette <bn@niasdigital.com>,
       Adrian Hunter <adrian.hunter@nokia.com>, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH v3] mmc: Make ID freq configurable
Message-ID: <20100105122422.GI6923@pengutronix.de>
References: <20090702135849.21370282@hskinnemoen-d830> <1246537056.2980.60.camel@linux-51e8.site> <4B3E570C.2060602@yahoo.es> <63809451-ED1D-487A-AE63-F72B23D136D8@niasdigital.com> <4B3F019F.6010306@yahoo.es> <49985427-DCB9-40E1-815B-43C812B41DE3@niasdigital.com> <20100102130809.121b7e10@mjolnir.ossman.eu> <AD8E15FA-A476-4275-A750-5EB587A93CEC@niasdigital.com> <20100103003804.66021fe9@mjolnir.ossman.eu> <4B425889.8010703@yahoo.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B425889.8010703@yahoo.es>
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
X-Uptime: 13:19:06 up 85 days,  1:08, 50 users,  load average: 0.12, 0.09,
	0.05
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 05:07:21AM +0800, Hein_Tibosch wrote:
> On 3-1-2010 07:38, Pierre Ossman wrote:
>>
>> <cut>
>> We all use the same pool of cards so we
>> should all be using the same init sequence. If there isn't a single
>> frequency where all cards will work, then we'll have to make something
>> more advanced where the kernel will try the init several times with
>> different clocking.
>
> On 4-1-2010 20:15, Sascha Hauer wrote:
>> The problem was that in some setups the mxcmmc driver allows frequencies
>> as low as a few Hz and the card initialization took ages. Increasing the
>> frequency to 400kHz seemed sensible since it's the value the spec
>> describes. 50kHz should be fine as well.
>>
>
> I tried out several main-stream sd-cards and with the Atmel (AP7) controller
> they all initialize with F between 138 (=f_min) and 280 Khz.
>
> Below a patch which tries mmc-initialization using several frequencies
> from an array 400, 300, 200 and 100. When it comes to 200 Khz, it works.
> The two failed attempts lasted about 10 ms together.
>
> It looks like a hell-of-a-patch but that's because the indentation changes.
>
> Note that the new mmc_host member f_init will be used later in power_restore
> and resume. As power_up always comes first, it should have a descend value
> by then.
>
> But I still wonder, why not just keep using Sascha's patch, changing 400000
> to 50000? Has anyone ever had problems with mmc-init on 50 Khz?

I already wrote it to Hein in private, once again for the rest:

The original reason to increase the minimum frequency was that the
Freescale i.MX MMC core allows minimum frequencies of just a few Hz.
With this the card initialisation took ages, so we increased the minimum
frequency. 400kHz seemed like a good value since all cards should
support this, but I'm also fine with any other value between 50kHz and
400kHz.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
