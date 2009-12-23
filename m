Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbZLWVzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbZLWVzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZLWVzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:55:16 -0500
Received: from mail.windriver.com ([147.11.1.11]:49481 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566AbZLWVzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:55:15 -0500
Message-ID: <4B3291AD.6070104@windriver.com>
Date: Wed, 23 Dec 2009 15:54:53 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       kdb@oss.sgi.com, mingo@elte.hu
Subject: Re: [PATCH 15/37] sparc,sunzilog: Add console polling support for
 sunzilog serial driver
References: <1261603190-5036-14-git-send-email-jason.wessel@windriver.com><1261603190-5036-15-git-send-email-jason.wessel@windriver.com><1261603190-5036-16-git-send-email-jason.wessel@windriver.com> <20091223.135028.112586698.davem@davemloft.net>
In-Reply-To: <20091223.135028.112586698.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Dec 2009 21:54:53.0377 (UTC) FILETIME=[8ED43B10:01CA841A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jason Wessel <jason.wessel@windriver.com>
> Date: Wed, 23 Dec 2009 15:19:28 -0600
>
>   
>> +static void sunzilog_put_poll_char(struct uart_port *port,
>> +			unsigned char ch)
>> +{
>> +	struct uart_sunzilog_port *up = (struct uart_sunzilog_port *)port;
>> +
>> +	sunzilog_putchar(&up->port, ch);
>> +	udelay(2);
>> +
>> +}
>> +#endif /* CONFIG_CONSOLE_POLL */
>>     
>
> Just curious, what is the udelay() for?
>   

This was copied from zm.c driver.  I don't think the HW needs it, I'll
retest and purge it.

>   
>>  static struct uart_ops sunzilog_pops = {
>>  	.tx_empty	=	sunzilog_tx_empty,
>>  	.set_mctrl	=	sunzilog_set_mctrl,
>> @@ -1013,6 +1061,10 @@ static struct uart_ops sunzilog_pops = {
>>  	.request_port	=	sunzilog_request_port,
>>  	.config_port	=	sunzilog_config_port,
>>  	.verify_port	=	sunzilog_verify_port,
>> +#ifdef CONFIG_CONSOLE_POLL
>> +	.poll_get_char	= sunzilog_get_poll_char,
>> +	.poll_put_char	= sunzilog_put_poll_char,
>> +#endif
>>  };
>>     
>
> Please make the indentation consistent with the rest of those in
> this structure.
>   

Consider it done.

Thanks,
Jason.
