Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbYFYLaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbYFYLaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 07:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbYFYLal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 07:30:41 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:48035 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256AbYFYLak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 07:30:40 -0400
Message-ID: <48622C5E.5020204@aitel.hist.no>
Date: Wed, 25 Jun 2008 13:30:38 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
Organization: HiST
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: 2.6.26-rc2 WARNING from usb-serial, and then my gps is dead
References: <485E984B.1030306@aitel.hist.no> <20080622184253.GB18502@kroah.com>
In-Reply-To: <20080622184253.GB18502@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sun, Jun 22, 2008 at 08:22:03PM +0200, Helge Hafting wrote:
>> This is what I got:
>> ------------[ cut here ]------------
>> WARNING: at drivers/usb/serial/usb-serial.c:306 serial_write+0x62/0x89 
>> [usbserial]()
>> Modules linked in: pl2303 usbserial sbs sbshc coretemp piix pcmcia ata_piix 
>> iTCO_wdt ata_generic bay hci_usb intel_agp
>> Pid: 10, comm: events/1 Tainted: G        W 2.6.26-rc2-hh1 #1
>>
>> Call Trace:
>>  [<ffffffff80236b54>] warn_on_slowpath+0x51/0x7a
>>  [<ffffffff8022c207>] __wake_up+0x38/0x4f
>>  [<ffffffff8024565c>] __queue_work+0x23/0x33
>>  [<ffffffff802456c8>] queue_work+0x37/0x40
>>  [<ffffffffa0045fa3>] :pl2303:pl2303_write+0xf2/0x101
>>  [<ffffffffa003c368>] :usbserial:serial_write+0x62/0x89
>>  [<ffffffff803a8e81>] tty_put_char+0x2b/0x2d
>>  [<ffffffff803ad3ca>] echo_char+0x47/0x60
>>  [<ffffffff803ade97>] n_tty_receive_buf+0x2b4/0xd76
>>  [<ffffffff8020a87e>] __switch_to+0xa2/0x396
>>  [<ffffffff8023028d>] hrtick_set+0x88/0xf6
>>  [<ffffffff80590b44>] thread_return+0x70/0xb4
>>  [<ffffffff8023f013>] lock_timer_base+0x26/0x4c
>>  [<ffffffff803a9abd>] flush_to_ldisc+0xf8/0x185
>>  [<ffffffff803a99c5>] flush_to_ldisc+0x0/0x185
>>  [<ffffffff8024520b>] run_workqueue+0x80/0x112
>>  [<ffffffff80245afe>] worker_thread+0xd9/0xe8
>>  [<ffffffff80248380>] autoremove_wake_function+0x0/0x2e
>>  [<ffffffff80245a25>] worker_thread+0x0/0xe8
>>  [<ffffffff80248264>] kthread+0x47/0x73
>>  [<ffffffff802318c1>] schedule_tail+0x28/0x5d
>>  [<ffffffff8020cf88>] child_rip+0xa/0x12
>>  [<ffffffff8024821d>] kthread+0x0/0x73
>>  [<ffffffff8020cf7e>] child_rip+0x0/0x12
>>
>> ---[ end trace 656e180042992f9e ]---
>> I looked at the dmesg log because I have had lots of trouble with my gps 
>> lately. I first suspected the cable, but then I saw this.
>>
>> After this, I have to restart gpsd, and perhaps replug the cable to get
>> things going again. Until it happens again. This is a 64-bit dualcore 
>> laptop.
> 
> Ick, that's not nice.
> 
> Can you enable debugging for the usb-serial core:
> 	echo 1 > /sys/module/usbserial/parameters/debug
> 
> and then run whatever program you were running that causes this warning
> and then send us the kernel log?
> 

USB logging sure creates lots of data.
8.4M of log bzipped into 237kB here:
http://www.aitel.hist.no/~helgehaf/usbtrouble1.log.bz2

This contains:
* Kernel log all the way from bootup (2.6.26-rc8)
* An USB incident before I turned USB logging on
* An USB incident after I turned USB logging on

Almost all of it is these two lines repeating forewer:
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0

The port numbers change a couple of times throughout the log.

Helge Hafting
