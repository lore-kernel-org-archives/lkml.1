Return-Path: <linux-kernel-owner+w=401wt.eu-S932118AbZKMSWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118AbZKMSWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 13:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756776AbZKMSWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 13:22:46 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:44845 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634AbZKMSWp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 13:22:45 -0500
MIME-Version: 1.0
In-Reply-To: <20091113111019.GA3563@pengutronix.de>
References: <1257844329-20687-1-git-send-email-l.fu@pengutronix.de> 
	<1258108877-25435-1-git-send-email-l.fu@pengutronix.de> <1258108877-25435-2-git-send-email-l.fu@pengutronix.de> 
	<1258108877-25435-3-git-send-email-l.fu@pengutronix.de> <1258108877-25435-4-git-send-email-l.fu@pengutronix.de> 
	<20091113111019.GA3563@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 13 Nov 2009 11:22:31 -0700
X-Google-Sender-Auth: 63b3da2958d3d8ab
Message-ID: <fa686aa40911131022yc84ab95wd9c67ab5d03c5ecb@mail.gmail.com>
Subject: Re: [PATCH 3/3] [V2] mpc52xx_spi: add gpio chipselect
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Luotao Fu <l.fu@pengutronix.de>, spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 4:10 AM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> On Fri, Nov 13, 2009 at 11:41:17AM +0100, Luotao Fu wrote:
>> This one enables the mpc52xx_spi driver for usage of user defined gpio lines
>> as chipselect. This way we can control some more spi devices than only one
>>
>> V2 Changes:
>> * preinitialize the gpio as output in probe function and call gpio_set_value in
>>   the chip select function instead of calling direction_output every time.
>> * initialize the gpio line with output high, since we don't support CS_HIGH
>>   in the driver currently any way. change gpio value setting to default active
>>   low in chip select call.
>> * free the gpio array while error or removing.
>>
>> Signed-off-by: Luotao Fu <l.fu@pengutronix.de>

>> @@ -477,6 +520,12 @@ static int __devinit mpc52xx_spi_probe(struct of_device *op,
>>   err_register:
>>       dev_err(&ms->master->dev, "initialization failed\n");
>>       spi_master_put(master);
>> + err_gpio:
>> +     while (i-- > 0)
>> +             gpio_free(ms->gpio_cs[i]);
>> +
>> +     if (ms->gpio_cs != NULL)
>> +             kfree(ms->gpio_cs);
>
> kfree() is NULL aware, so no if needed.

Not dangerous though.  No need to respin just for this.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
