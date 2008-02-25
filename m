Return-Path: <linux-kernel-owner+w=401wt.eu-S1760863AbYBYWue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760863AbYBYWue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758184AbYBYWuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:50:23 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:3149 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758169AbYBYWuV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:50:21 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 25 Feb 2008 22:27:42.0017 (UTC) FILETIME=[A2B39B10:01C877FD]
Content-class: urn:content-classes:message
Subject: Re: Print long messages to console from kernel module
Date: Mon, 25 Feb 2008 17:27:37 -0500
Message-ID: <Pine.LNX.4.61.0802251722400.2031@chaos.analogic.com>
In-Reply-To: <47C2FB39.3080508@enea.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Print long messages to console from kernel module
Thread-Index: Ach3/aK/Zj3FZTOISDudMXKzH5dPKw==
References: <47C2FB39.3080508@enea.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Arvid Brodin" <arvid.brodin@enea.com>
Cc: <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 25 Feb 2008, Arvid Brodin wrote:

> I need to write messages > 1023 characters long to the console from a module*. printk() is limited to 1023 characters, and splitting the message over several printk()'s results in a line break and "Month hh:mm:ss host kernel:" being inserted in my text.
>
> I tried including <linux/console.h> and using the console_drivers declared there, but get
> "WARNING: "console_drivers" [<path>/log.ko] undefined!" when compiling and
> "insmod: error inserting 'log.ko': -1 Unknown symbol in module" when insmodding.
>
> I guess this is because non EXPORT_SYMBOL'd symbols are only accessible to statically linked code, and not to modules? I see in printk.c that console_drivers is set up there, and I haven't been able to find any other interface to console_drivers.
>
> In short: is there any way to print messages to the console from a kernel module, except printk()? Is opening /dev/tty and writing to it the way to go?
>
>
> * I'm writing an in-memory logger to be included in a module. The log can be several megabytes. The idea is to use SysRq to print the contents of the log to console after a kernel panic or otherwise when writing to disk might not work.
>
> -- 
> Arvid Brodin
> Enea LCC

Write the data to a kernel buffer. Impliment read() or ioctl() and
poll(). Have a user-mode task sleep in poll, waiting for data to
become available. That user-mode task can do anything it wants,
unrestricted, with the data including writing it to files or any
tty it wants to open.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.28 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
