Return-Path: <linux-kernel-owner+w=401wt.eu-S932207AbXBSMss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbXBSMss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 07:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932210AbXBSMsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 07:48:47 -0500
Received: from mail.atmel.fr ([81.80.104.162]:61145 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207AbXBSMsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 07:48:47 -0500
Message-ID: <45D99C81.7080401@rfo.atmel.com>
Date: Mon, 19 Feb 2007 13:48:01 +0100
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Organization: atmel
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
CC: Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       Andrew Victor <andrew@sanpeople.com>
Subject: Re: [PATCH] input/spi: add ads7843 support to ads7846 touchscreen driver
References: <20061222192536.A206A1F0CDB@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <200612291226.46984.david-b@pacbell.net>	
	 <45D5EBC3.8090208@rfo.atmel.com> <200702161108.51014.david-b@pacbell.net>
In-Reply-To: <200702161108.51014.david-b@pacbell.net>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-ESAFE-STATUS: Mail clean
X-ESAFE-DETAILS: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell :
> Did you find out what was causing the jerky behavior (draw a circle,
> it looks like a square) before?

No, my previous rework based on your patches (2.6.19) had this
jerky behavior. I was obliged to go back to old style timers.
On this build, with the htimer framework, it seems ok.
  
>> -	/* maybe off internal vREF */
>> -	if (use_internal) {
> 
> This part doesn't make sense.  Could you say what you're trying
> to do?  The ads7846 requres an external vREF.  Is the issue that
> maybe the REF_OFF command isn't just turning off the (non-existent)
> internal voltage reference?  If so the comments need updating, and
> maybe the name REF_OFF needs to change too...

Well, on the ads7843, this command allow to put converter in low power
mode and, more important, enable the PENIRQ (otherwise disabled).

The REF_OFF command can be replaced by the PWRDOWN one (exactly the
same command). This last name matches better the ads7843
datasheet description (and seems ok considering the ads7846 one).

>> -		req->ref_off = REF_OFF;
>> -		req->xfer[4].tx_buf = &req->ref_off;
>> -		req->xfer[4].len = 1;
>> -		spi_message_add_tail(&req->xfer[4], &req->msg);
>> -
>> -		req->xfer[5].rx_buf = &req->scratch;
>> -		req->xfer[5].len = 2;
>> -		CS_CHANGE(req->xfer[5]);
>> -		spi_message_add_tail(&req->xfer[5], &req->msg);
>> -	}
>> +	req->ref_off = REF_OFF;
>> +	req->xfer[4].tx_buf = &req->ref_off;
>> +	req->xfer[4].len = 1;
>> +	spi_message_add_tail(&req->xfer[4], &req->msg);
>> +
>> +	req->xfer[5].rx_buf = &req->scratch;
>> +	req->xfer[5].len = 2;
>> +	CS_CHANGE(req->xfer[5]);
>> +	spi_message_add_tail(&req->xfer[5], &req->msg);
>>  
>>  	ts->irq_disabled = 1;
>>  	disable_irq(spi->irq);

Regards,
-- 
Nicolas Ferre


