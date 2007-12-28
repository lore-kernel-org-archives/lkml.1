Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbXL1D11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbXL1D11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 22:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbXL1D1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 22:27:19 -0500
Received: from nofear-snat.bivio.net ([216.142.75.231]:31454 "EHLO
	corpexc01.corp.networkrobots.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754089AbXL1D1S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 22:27:18 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Device node - How does kernel know about it
Date: Thu, 27 Dec 2007 19:23:28 -0800
Message-ID: <D83235F0F3C86D4D889D8B9A0DA8C6D7012AFA2C@corpexc01.corp.networkrobots.com>
In-Reply-To: <477406A2.2070904@cfl.rr.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Device node - How does kernel know about it
Thread-Index: AchIw/rYSjnLqPALQB2YHJ7xkeaj0QAPIVYA
References: <D83235F0F3C86D4D889D8B9A0DA8C6D7012AF95A@corpexc01.corp.networkrobots.com> <477406A2.2070904@cfl.rr.com>
From: "Siva Prasad" <sprasad@bivio.net>
To: "Phillip Susi" <psusi@cfl.rr.com>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the response Phillip. See below for response.

I already am using "console=ttyS0" as well as set the inittab correctly.

I would like to debug this node behavior. Can you please let me know
which routine gets called first when there is, for example a read() call
from user program. Eventually it will result in a call to what ever read
routine registered, but that must be a call back function or some thing.
Right?

- Siva


-----Original Message-----
From: Phillip Susi [mailto:psusi@cfl.rr.com] 
Sent: Thursday, December 27, 2007 12:10 PM
To: Siva Prasad
Cc: linux-kernel@vger.kernel.org
Subject: Re: Device node - How does kernel know about it

Siva Prasad wrote:
> Hi,
> 
> How do the device nodes work as an interface between user and kernel
> programs, and how to go debugging it? 
> This is as part of my debugging effort on an embedded board.

The filesystem sets specific bits in the mode mask and elsewhere in the 
inode to mark the file as a dev node, and which major/minor device 
number it should be linked to.  The kernel device drivers register to 
handle a given device number.

> * It all started with the problem of "not printing" any thing that
comes
> from ramdisk (echo and printf statements), while kernel printk's work
> perfectly fine.
> * Ramdisk is also executing fine, just that prints are not coming out
of
> serial. I can see the execution of various user programs with a printk
> in sys_execve() routine. Ramdisk has all the required files like
> /dev/console, /dev/ttyS0, etc.

So you did you pass the console=ttyS0 parameter to the kernel?  Did you 
configure your inittab to spawn the getty on the serial port instead of 
/dev/ttyN?  You might want to take a look at the Linux Serial Console 
HOWTO.


