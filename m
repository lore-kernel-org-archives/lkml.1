Return-Path: <linux-kernel-owner+w=401wt.eu-S1161180AbXBRIxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161180AbXBRIxG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 03:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161181AbXBRIxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 03:53:05 -0500
Received: from soapbox.mail.yandex.net ([213.180.223.94]:50905 "EHLO
	soapbox.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161180AbXBRIxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 03:53:03 -0500
Date: Sun, 18 Feb 2007 11:52:58 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45D813EA.000008.23689@soapbox.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: tytso@mit.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: serial and tty driver
X-MsgDayCount: 4
X-BornDate: 1134853200
In-Reply-To: <20070217232054.GA11117@thunk.org>
Reply-To: Mockern@yandex.ru
References: <45D73BF6.000001.30155@pantene.yandex.ru> <45D74856.6090900@microgate.com> <20070217232054.GA11117@thunk.org>
X-Source-Ip: 84.185.221.32
Content-Type: text/plain;
  charset="KOI8-R"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for you respond.

I asked this question since I have one problem with my tty driver.
It based on serial_core.c. It works well except Linux cat operation:(.
(e.g. cat < ttyS10). I thought in tty driver there is no function
for this operation and I wanted to know that maybe serial driver has it.

Could it be the reason that cat operation in tty driver does not work
(but I can write and read from user space application!)?
Or maybe I need to implement a special function in my tty driver to support Linux
cat operation?

Thank you again 

  

>On Sat, Feb 17, 2007 at 12:24:22PM -0600, Paul Fulghum wrote:
>> Mockern wrote:
>> >I have a question, what is really difference between serial and tty
>> >drivers?
>> >
>> >As I understand tty is high level and communicates with user space. 
>> 
>> The serial core implements many of the details of a tty
>> driver in a common place so that individual hardware drivers
>> (serial drivers) only need implement the hardware specific code.
>> 
>> This prevents duplicating tty logic in many drivers,
>> with the possibility of mistakes/inconsistency in the
>> different tty drivers.
>> 
>> The stand alone tty drivers are mostly legacy code from
>> the time before serial core that have not been ported
>> to be a serial drivers.
>
>Not necessarily; there are a number of tty drivers, such as the
>console drivers and pseudo-tty drivers that have absolutely nothing to
>do with an RS-232 port.
>
>On the other side of the argument, another factorization of the layers
>that might have made sense was to move the functionality to the
>high-level tty layer (or in the case of hangup code, all the way up to
>the VFS layer as a generic sys_revoke functionality), but the reason
>why it didn't is largely historical.
>
>						- Ted
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/


-- 
Яндекс.Почта: объем почтового ящика не ограничен! http://mail.yandex.ru/monitoring/
