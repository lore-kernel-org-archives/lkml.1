Return-Path: <linux-kernel-owner+w=401wt.eu-S1752646Ab0ABJHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab0ABJHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 04:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628Ab0ABJHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 04:07:16 -0500
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:53787
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752593Ab0ABJHP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 04:07:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvcAANmaPkt8qNTn/2dsb2JhbAAI0RqEMQQ
X-IronPort-AV: E=Sophos;i="4.47,488,1257091200"; 
   d="scan'208";a="539465486"
Subject: Re: [PATCH v2] mmc: lower init clock frequency to 300kHz
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <4B3F019F.6010306@yahoo.es>
Date: Sat, 2 Jan 2010 20:07:01 +1100
Cc: Pierre Ossman <pierre@ossman.eu>, Sascha Hauer <s.hauer@pengutronix.de>,
       Adrian Hunter <adrian.hunter@nokia.com>, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <49985427-DCB9-40E1-815B-43C812B41DE3@niasdigital.com>
References: <1246492196.2980.17.camel@linux-51e8.site>	<20090702135849.21370282@hskinnemoen-d830> <1246537056.2980.60.camel@linux-51e8.site> <4B3E570C.2060602@yahoo.es> <63809451-ED1D-487A-AE63-F72B23D136D8@niasdigital.com> <4B3F019F.6010306@yahoo.es>
To: Hein_Tibosch <hein_tibosch@yahoo.es>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Adding linux CCs)

On 02/01/2010, at 7:19 PM, Hein_Tibosch wrote:

> Almost good: on my Kingston Elite Pro (50x) SD-card, initialization will
> only succeed if F <= 282258 Hz.

...

> 
> I checked some datasheets of several makes:
> 
> Delkin microSD min 0 max 400
> Swissbit min 0 max 400
> Sandisk 100 - 400
> Toshiba 100 - 400
> ST electronics 0 400
> SD-specification: Issue continues clock in frequency range of 100KHz-400KHz
>  If the Average frequency of the SDCLK is less than 100KHz then the card
>  may not be able to respond within the 1-second limit
> 
> So what about 100 or 150 Khz?

Ah geez, yeah this something else I was hoping to avoid with the V1 patch - an endless stream of "oh shit, this card's even /moore/ broken!  Patch it, patch it good"

Pierre, thoughts?  All my cards were borderline spec but Hein's got a mainstream, common card which seems to completely ignore the spec.  Can we just take the few-hundred-uS hit and allow initialization down at the bottom end, say 100kHz?

<overkill> Or a KConfig option? </overkill>

	--Ben.

