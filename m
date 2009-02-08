Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbZBHNMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbZBHNMb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 08:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbZBHNMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 08:12:22 -0500
Received: from uhweb15152.united-hoster.com ([85.88.15.152]:47941 "EHLO
	uhweb15152.united-hoster.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751872AbZBHNMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 08:12:22 -0500
Message-ID: <498EDA18.1090300@f-seidel.de>
Date: Sun, 08 Feb 2009 14:11:52 +0100
From: Frank Seidel <frank@f-seidel.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       ben-linux@fluff.org, linux-i2c@vger.kernel.org, w.sang@pengutronix.de,
       "David S. Miller" <davem@davemloft.net>,
       ukleinek@informatik.uni-freiburg.de, Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] i2c: add missing KERN_* constants to printks
References: <498C3EEA.5060508@suse.de> <20090208000553.059a0732@hyperion.delvare>
In-Reply-To: <20090208000553.059a0732@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jean Delvare wrote:
>> +	printk(KERN_ERR "i2c: ICR: %08x ISR: %08x\n"
>>  	       "i2c: log: ", readl(_ICR(i2c)), readl(_ISR(i2c)));
>>  	for (i = 0; i < i2c->irqlogidx; i++)
>>  		printk("[%08x:%08x] ", i2c->isrlog[i], i2c->icrlog[i]);
> 
> This last printk also lacks a log level. You can't add it in the loop,
> but you could add one printk before the loop, printing just the log level.

Isn't the last printk just a followup of the previous KERN_ERR which
doesn't have a newline? And i'm told only on new line beginnings the
loglevel should be set.

> I second Uwe's comments: it would be much better to add the log level
> in the DEBx macros. Additionally, some discussion is needed as to what
> log level would be appropriate. You put KERN_WARNING for all but some
> of these messages are clearly debugging messages. As a matter of fact,
> DEBx macros are all about debugging.
> 
> So I think that a good patch would 1* add KERN_DEBUG to the DEBx macros
> and 2* check for all usage of these DEBx macros and turn all messages
> which aren't actual debug messages to raw printks. As this will require
> some more work, you may want to split these changes off your initial
> patch.

Ok, i fully agree with you. So, i'll redo the patch asap.

Thanks for your feedback,
Frank
