Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbXG2EDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbXG2EDR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 00:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750708AbXG2EDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 00:03:07 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:38421 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbXG2EDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 00:03:05 -0400
Message-ID: <003701c7d16c$8c72b7b0$03c8a8c0@kroptech.com>
From: "Adam Kropelin" <akropel1@rochester.rr.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Pasich" <NewsLetters@NickAndBarb.net>,
       <linux-usb-devel@lists.sourceforge.net>
Cc: "Greg Kroah-Hartman" <greg@kroah.com>,
       "Al Borchers" <alborchers@steinerpoint.com>,
       <linux-kernel@vger.kernel.org>, "Peter Berger" <pberger@brimson.com>
References: <20070727203708.GA10839@NICK2> <20070727152254.202959c1.akpm@linux-foundation.org>
Subject: Re: [linux-usb-devel] Edgeport UPS Monitoring Problems
Date: Sat, 28 Jul 2007 19:10:54 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 27 Jul 2007 13:37:08 -0700
> Nick Pasich <NewsLetters@NickAndBarb.net> wrote:
>
>>
>> Greg/Peter/Al,
>
> added linux-usb-devel.
>
>> I've been using the edgeport 4 port USB to Serial Converter
>> to monitor APC Smart UPS's via apcupsd for quite awhile on
>> various Linux boxes.
>>
>> I just upgraded to Kernel Version 2.6.22.1 from 2.6.20.6 on a
>> couple of systems and both the edgeports stopped communicating.
>>
>> I tried applying various patches, "PATCH 026/149" and "PATCH 082/149"
>> and one by Alan Cox..  but they didn't fix the problem.
>>
>> I copied the 2.6.20.6 edgeport module sources to the new
>> 2.6.22.1 tree and everything works again.
>>
>>           linux/drivers/usb/serial/io_edgeport.c
>>           linux/drivers/usb/serial/io_edgeport.h
>>           linux/drivers/usb/serial/io_edgeport.mod.c
>>           linux/drivers/usb/serial/io_tables.h
>
> Straightforward regression, most serious.  Thanks for reporting it.

I don't know much of anything about usb-serial, but I'll take a whack at 
it. Could you enable debug for that driver, launch apcupsd, and report 
any intersting messages that show up in dmesg? I'd be especially 
interested in any "Not setting..." or "Not writing..." messages, because 
some critical-looking code for baud rate setting and similar became 
conditional in 2.6.22.1 whereas it was always executed before. Apcupsd 
is going to be rather unhappy if the baud rate doesn't change when it 
asks. The debug should show if the these operations are being ignored on 
your hw.

--Adam

