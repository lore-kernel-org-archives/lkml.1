Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbYGWRoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbYGWRoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 13:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYGWRoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 13:44:13 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:33605 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbYGWRoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 13:44:12 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <48876DF5.5060302@gmail.com>
Date: Wed, 23 Jul 2008 18:44:21 +0100
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [Patch 3/4] ST LIS3L02DQ accelerometer
References: <488763AD.4050400@gmail.com>	<488766F4.20603@gmail.com> <20080723180726.6fc0ef6e@lxorguk.ukuu.org.uk>
In-Reply-To: <20080723180726.6fc0ef6e@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alan,
>> +
>> + xfer.rx_buf = kmalloc(4, GFP_KERNEL);
>> + if (xfer.rx_buf == NULL) {
>> + ret = -ENOMEM;
>> + goto error_free_tx;
>> + }
>
> Do these really need to be two kmallocs
Sorry about that, legacy of a much older version. I definitely didn't clean
this driver up properly (iio core is still a fair way off going anywhere so
I'll admit I didn't didn't check the drivers using it as thoroughly as I
should
have)
>
>> + if (ret) {
>> + dev_err(&st->us->dev, "problem with get x offset");
>> + goto error_free_rx;
>> + }
>> + *val = ((unsigned char *)(xfer.rx_buf))[0];
>> + kfree(xfer.rx_buf);
>> + kfree(xfer.tx_buf);
>> + return ret;
>> +error_free_rx:
>> + kfree(xfer.rx_buf);
>> +error_free_tx:
>> + kfree(xfer.tx_buf);
>> +error_ret:
>> + return ret;
>
> That lot makes no sense. You could just drop through..
Oops.
>> +{
>> + uint8_t val;
>> + int8_t ret;
>
> Kernel types (u8, s8 etc)
To used to userspace programming! I'll fix them.
>
>> + local_rx_buf = kmalloc(4, GFP_KERNEL);
>> + local_tx_buf = kmalloc(4, GFP_KERNEL);
>> +
>> + local_tx_buf[1] = LIS3L02DQ_READ_REG(reg_address);
>
> OOPS on out of memory case
Good point.
>

>
> You seem to have a lot of almost identical routines here. It looks like
> with a few helpers this driver could be vastly shorter.
Again a good point. I'll clean it up and repost.

Thanks for the hints,

--
Jonathan Cameron


