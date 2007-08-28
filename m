Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbXH1FdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbXH1FdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 01:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750727AbXH1FdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 01:33:08 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:47583 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbXH1FdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 01:33:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=rmhMBge9jMBw7csu5aANox8+Y8xLt+vgmML1g9guzRtJTAfL1M80dmv5evHePA/irF3q2HakDk05ZT9ck3vCF5eeMOKlKlmVWL9E7eoo0DSFH0p38gSO/DsXI5l4DI6/T/hQRDHtTcz4khCEZ0FdQ+TiryVQlYK3pGr2K+PSf8c=
Message-ID: <46D3B394.9090609@gmail.com>
Date: Tue, 28 Aug 2007 07:33:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
References: <300725321593711206@pripojeni.net> <20070827154049.8c5e61fe.akpm@linux-foundation.org>
In-Reply-To: <20070827154049.8c5e61fe.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> On Sun, 26 Aug 2007 07:09:02 -0700
> Jiri Slaby <jirislaby@gmail.com> wrote:
> +		retok = stk11xx_check_device(dev, 500);
> +		if (retok != 1) {
> +			dev_err(&dev->udev->dev, "load microcode fail\n");
> +			return -EIO;
> +		}
> 
> Normally we'd use a return value of zero to indicate success.  So that the
> negative return value can tell people _why_ it failed.

it returns
-EIO = fail
0 = we succeeded, but the device is not ready
1 = the device is OK

Seems proper to change the 0 -> EBUSY or something and 1 -> 0 anyway, if we
check only for 1.

>> +
>> +	for (i = 0; i < 16; i++) {
>> +		stk11xx_write_reg(dev, 0x0000, 0x25);
>> +		stk11xx_write_reg(dev, 0x0000, 0x24);
>> +		stk11xx_read_reg(dev, 0x0000, &value);
>> +
>> +		dev_dbg(&dev->udev->dev, "Loop 1: Read 0x0000 = %02x\n", value);
>> +	}
>> +
>> +	ret = stk11xx_process_table(dev, table_2);
>> +	if (ret)
>> +		goto end;
>> +
>> +	for (i = 0; i < 16; i++) {
>> +		stk11xx_write_reg(dev, 0x0000, 0x25);
>> +		stk11xx_write_reg(dev, 0x0000, 0x24);
>> +		stk11xx_read_reg(dev, 0x0000, &value);
>> +
>> +		dev_dbg(&dev->udev->dev, "Loop 2: Read 0x0000 = %02x\n", value);
>> +	}
>> +
>> +	ret = stk11xx_process_table(dev, table_3);
>> +	if (ret)
>> +		goto end;
>> +
>> +	for (i = 0; i < 16; i++) {
>> +		stk11xx_write_reg(dev, 0x0000, 0x25);
>> +		stk11xx_write_reg(dev, 0x0000, 0x24);
>> +		stk11xx_read_reg(dev, 0x0000, &value);
>> +
>> +		dev_dbg(&dev->udev->dev, "Loop 3: Read 0x0000 = %02x\n", value);
>> +	}
> 
> Again, ARRAY_SIZE() would be clearer here.

No, this is only do this 16 times, no corresponding table :).

thanks for review,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
