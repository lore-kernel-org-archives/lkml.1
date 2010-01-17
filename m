Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548Ab0AQUTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab0AQUTW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 15:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410Ab0AQUTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 15:19:20 -0500
Received: from khc.piap.pl ([195.187.100.11]:49447 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270Ab0AQUTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 15:19:20 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Tejun Heo <tj@kernel.org>
Cc: Robert Hancock <hancockrwd@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
       Seth Heasley <seth.heasley@intel.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: JMB363 false hotplug detections
References: <51f3faa71001161010m47d885cfx5d17486016476ed5@mail.gmail.com>
	<4B5270D6.6030005@kernel.org>
Date: Sun, 17 Jan 2010 21:19:16 +0100
In-Reply-To: <4B5270D6.6030005@kernel.org> (Tejun Heo's message of "Sun, 17
	Jan 2010 11:07:18 +0900")
Message-ID: <m3eilocwmz.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Can someone point me to the original thread?

Sure:

http://lkml.org/lkml/2010/1/13/342
http://lkml.org/lkml/2010/1/15/245

BTW setting the JMB363 mode in BIOS setup from IDE to AHCI or RAID
(thus enabling JMB363 BIOS) changes nothing.

The only weird thing is that some time ago the problems weren't there.
It could be genuine hardware problem. I have full kernel logs. Sometimes
the same kernel (build) is "good" at one time and "bad" at another.

I had booted the board (with JMB363 and the driver enabled) 57 times.
Out of these, there was no problems 16 times (date-hrs-result):

08-18-start-good
08-18-23:21-good
08-20-12:21-good
08-20-12:41-good
08-20-13:40-good
08-20-13:52-good
08-20-13:54-good
08-20-14:06-good
08-20-16:16-good
08-20-20:53-good
08-21-11:15-bad
08-22-12:10-good (uncertain, the kernel had other problems)
08-22-12:12-bad
08-22-22:36-bad
08-22-22:39-bad
08-22-22:40-bad
08-23-12:53-good
08-23-13:31-good
08-23-19:22-good
08-24-14:44-bad
08-25-12:29-bad
08-26-12:34-bad
08-27-12:43-bad
08-27-12:51-bad
08-27-18:26-bad
08-28-12:10-bad
08-29-11:38-bad
08-30-22:13-bad
08-31-12:50-bad
09-01-12:53-bad
09-01-17:47-good
09-02-12:42-bad
09-02-18:27-bad
09-03-11:56-bad
09-04-13:40-bad
09-04-22:23-bad
09-05-21:42-good
09-06-16:42-bad
09-07-14:13-bad
09-08-14:21-bad
09-09-13:47-bad
09-10-12:24-bad
09-10-23:33-bad
09-11-14:07-bad
09-12-01:43-bad
09-12-12:29-bad
09-12-23:11-bad
09-12-23:42-bad
09-13-01:11-bad
09-13-13:45-bad
09-13-17:53-bad
09-13-18:01-bad
09-13-19:13-bad
10-18-00:59-bad
10-18-17:07-bad
10-18-17:14-bad
10-18-17:19-bad

There are no significant kernel log differences between *good and *bad
(excluding the AHCI messages). Sometimes the exceptions were sporadic,
like in 09-01-12:53-bad case:

Sep  1 12:53:38 Machine booted
Sep  1 13:02:33 ata8: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe frozen
Sep  1 13:02:33 ata8: irq_stat 0x00000040, connection status changed
Sep  1 13:02:33 ata8: SError: { CommWake DevExch }
Sep  1 13:02:33 ata8: hard resetting link
Sep  1 13:02:34 ata8: SATA link down (SStatus 0 SControl 300)
Sep  1 13:02:34 ata8: EH complete
Sep  1 15:47:12 Machine rebooted

Perhaps I should really check these resistors around the JMB363 chip,
and maybe using a vacuum cleaner is a good idea? I think I will do.

It's certaing there was nothing connected do JMB363 SATA. I don't know
BIOS versions and CMOS (BIOS) configs.
-- 
Krzysztof Halasa
