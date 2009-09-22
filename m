Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbZIVHxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbZIVHxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 03:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbZIVHxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 03:53:20 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:43280 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbZIVHxT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 03:53:19 -0400
X-IronPort-AV: E=Sophos;i="4.44,430,1249272000"; 
   d="scan'208";a="4747252"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] input/keyboard: new driver for ADP5520 MFD PMICs
Date: Tue, 22 Sep 2009 08:53:19 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D0DFAD237@limkexm3.ad.analog.com>
In-Reply-To: <alpine.LRH.2.00.0909220933090.27145@twin.jikos.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] input/keyboard: new driver for ADP5520 MFD PMICs
Thread-Index: Aco7VwU5efx2Xt8PQ+22Zp7UaQBoYQAAhIkg
References: <1253211850-29309-1-git-send-email-vapier@gentoo.org> <20090922055954.GB9658@core.coreip.homeip.net> <alpine.LRH.2.00.0909220933090.27145@twin.jikos.cz>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Jiri Kosina" <jkosina@suse.cz>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
CC: "Mike Frysinger" <vapier@gentoo.org>, <linux-input@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>,
       <uclinux-dist-devel@blackfin.uclinux.org>,
       "Bryan Wu" <cooloney@kernel.org>
X-OriginalArrivalTime: 22 Sep 2009 07:53:21.0839 (UTC) FILETIME=[C185F3F0:01CA3B59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From: Jiri Kosina
>Sent: Tuesday, September 22, 2009 9:33 AM
>
>On Mon, 21 Sep 2009, Dmitry Torokhov wrote:
>
>> > +	if (event & KP_INT) {
>> > +		adp5520_read(dev->master, KP_INT_STAT_1, &reg_val_low);
>> > +		adp5520_read(dev->master, KP_INT_STAT_2, &reg_val_high);
>> > +
>> > +		keymask = (reg_val_high << 8) | reg_val_low;
>> > +		/* Read twice to clear */
>> > +		adp5520_read(dev->master, KP_INT_STAT_1, &reg_val_low);
>> > +		adp5520_read(dev->master, KP_INT_STAT_2, &reg_val_high);
>> > +		keymask |= (reg_val_high << 8) | reg_val_low;
>> > +		adp5520_keys_report_event(dev, keymask, 1);
>> > +	}
>> > +
>> > +	if (event & KR_INT) {
>>
>> Why do you check the same condition twice?
>
>It actually doesn't seem to be the same condition (KP_INT vs. KR_INT), but
>it's difficult to say, as these constants are apparently added in some
>other patch I have no idea about.

KP Key-Press versus Key-Release 

>And the same for other constants used in the code ... the patch seems to
>be quite incomplete.

The missing constants are in include/linux/mfd/adp5520.h

This file was sent in a different patch, adding support for the Multi Function Device Core 
(drivers/mfd/adp5520.c)

-Michael

------------------------------------------------------------------
********* Analog Devices GmbH
**  ***** Systems Engineering
**     ** Wilhelm-Wagenfeld-Strasse 6 
**  ***** D-80807 Munich
********* Germany 
Registergericht München HRB 40368,  Geschäftsführer: Thomas Wessel, William A. Martin, Margaret K. Seif

>
>--
>Jiri Kosina
>SUSE Labs, Novell Inc.

