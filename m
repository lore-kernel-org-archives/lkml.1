Return-Path: <linux-kernel-owner+w=401wt.eu-S967508AbXEHMGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967508AbXEHMGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 08:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967490AbXEHMGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 08:06:19 -0400
Received: from mx10.go2.pl ([193.17.41.74]:47046 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967486AbXEHMGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 08:06:15 -0400
Date: Tue, 8 May 2007 14:12:33 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, "Rafael J\. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-mm1 hwsusp: BUG at workqueue.c:106
Message-ID: <20070508121232.GE1772@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508105528.GA86@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08-05-2007 12:55, Oleg Nesterov wrote:
> On 05/08, Andrew Morton wrote:
>> On Tue, 08 May 2007 10:57:35 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:
>>
>>> this occured in dmesg during resuming from hwsusp in 2.6.21-mm1 (captured
>>> through netconsole). Perfectly reproducible, it simply happens each time I
>>> try it.
>> Let's cc Oleg.
>>
>>> usb_endpoint usbdev5.1_ep00: PM: resume from 0, parent usb5 still 2
>>> ------------[ cut here ]------------
>>> kernel BUG at /home/l/latest/xxx/kernel/workqueue.c:106!
>>> invalid opcode: 0000 [#1]
>>> SMP
>>> Modules linked in: ipv6 floppy ohci1394 ieee1394 parport_pc parport usbhid
>>> ehci_hcd pata_acpi ff_memless sr_mod cdrom
...
> queue_delayed_work().
> 
> Probably, cancel_delayed_work(&delayed_work->work) was called with the ->timer
> pending. This is wrong, cancel_delayed_work() clears _PENDING unconditionally,

Maybe I miss your point, but clearing is conditional: on timer delete...

I think more suspicious is calling cancel_work_sync() for a delayed work
(with timer pending). Or maybe some race profits from _PENDING cleared
without locking?

BTW, it seems some debugging is needed to show, whose work is doing the
mess.

Regards,
Jarek P.
