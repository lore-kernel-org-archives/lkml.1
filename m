Return-Path: <linux-kernel-owner+w=401wt.eu-S1751824AbZG0Pxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbZG0Pxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZG0Pxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:53:30 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:38094 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbZG0Px3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:53:29 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bisected] [Bug #13821] Replugging USB serial converter uses new device node
References: <Pine.LNX.4.44L0.0907271131100.5217-100000@iolanthe.rowland.org>
Date: Mon, 27 Jul 2009 17:53:18 +0200
In-Reply-To: <Pine.LNX.4.44L0.0907271131100.5217-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Mon, 27 Jul 2009 11:34:55 -0400 (EDT)")
Message-ID: <87zlaqcec1.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Mon, 27 Jul 2009, Carlos R. Mafra wrote:
>
>> On Sun 26.Jul'09 at 22:28:27 +0200, Rafael J. Wysocki wrote:
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13821
>>> Subject		: Replugging USB serial converter uses new device node
>>> Submitter	: Ferenc Wagner <wferi@niif.hu>
>>> Date		: 2009-07-18 20:04 (9 days old)
>>> References	: http://marc.info/?l=linux-kernel&m=124794754015776&w=4
>> 
>> I was scanning the regressions list and noticed that I could reproduce
>> this bug.
>> 
>> So I bisected it to commit 335f8514f200e63d689113d29cb7253a5c282967
>> ("tty: Bring the usb tty port structure into more use"), from Alan
>> Cox.
>> 
>> I did not double check if reverting it from -rc4 fixes the issue,
>> but I noticed that this patch touches drivers/usb/serial/option.c, which
>> is the driver I used to test this problem.
>> 
>> If there is anything else I can do (give more info, test patches etc),
>> please let me know.
>
> Are you certain this really is a regression?  Under 2.6.30 and 2.6.27
> the same thing happened if I unplugged a USB serial device while it was
> in use.

My original report is about unplugging the USB servial device *after*
using it.

> Can you check whether the device is still being used when you unplug 
> it?  For instance, is there still a pppd process trying to communicate 
> with the device?

I checked and rechecked that the pppd process is already dead by the
time I unplug the device.  However, the minor number did not increase
if I unplugged the device without using it beforehand, as expected.

> In short, it seems likely that this is not new behavior but rather the 
> way usb-serial has worked all along.

I didn't experience this problem with 2.6.30: my ppp script was
hardwired to use ttyUSB0 and it always worked.  Now with 2.6.31-rc3 it
does not, as the device node keeps changing.

I'll test this with opening ttyUSB directly from the shell, instead of
via pppd, and report back whether it makes a difference.
-- 
Regards,
Feri.
