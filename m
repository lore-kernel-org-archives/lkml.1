Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbXLSWhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbXLSWhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 17:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbXLSWhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 17:37:03 -0500
Received: from nofear-snat.bivio.net ([216.142.75.231]:31729 "EHLO
	corpexc01.corp.networkrobots.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752944AbXLSWhA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 17:37:00 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: printf internals
Date: Wed, 19 Dec 2007 14:33:15 -0800
Message-ID: <D83235F0F3C86D4D889D8B9A0DA8C6D7012AF540@corpexc01.corp.networkrobots.com>
In-Reply-To: <4762AC35.3010706@anagramm.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: printf internals
Thread-Index: Acg+bB2ZyI+LjZ4IQKaXKiKorA2z3gEIdW2Q
References: <D83235F0F3C86D4D889D8B9A0DA8C6D7011A8217@corpexc01.corp.networkrobots.com> <4761E289.9070007@davidnewall.com> <4762AC35.3010706@anagramm.de>
From: "Siva Prasad" <sprasad@bivio.net>
To: "Clemens Koller" <clemens.koller@anagramm.de>,
       "David Newall" <david@davidnewall.com>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you very much for your response Clemens.

I tried strace on a regular system. It does not show which tty, etc., as it uses the stdout (fd = 1) and write(1, ...) to it.

This is not a student project. I am trying to build my own kernel and ramdisk. Kernel boots fine to a point where it starts accessing ramdisk and executes init scripts. From there on nothing gets printed. I did some debugging and found that prints of user land programs are not coming to the serial console, while kernel prints are working fine. I found all the programs getting executed, by placing a printk in execve routine and printing the arguments.

So, I wanted to trace down the path from user program to the kernel and see why it is not printing messages from user program. I placed a printk in drivers/char/tty_io.c:tty_write() and it is not getting called from my file system. I tried the same thing on my good system (say regular PC) and it works as expected.

Any clues that can help debug this issue is highly appreciated.
How can I get access to the same printf string inside kernel.

Thanks
Siva



-----Original Message-----
From: Clemens Koller [mailto:clemens.koller@anagramm.de] 
Sent: Friday, December 14, 2007 8:16 AM
To: David Newall
Cc: Siva Prasad; linux-kernel@vger.kernel.org
Subject: Re: printf internals

David Newall schrieb:
 > Siva Prasad wrote:
 >> I am looking at how exactly does the printf in user programs succeeds in
 >> displaying characters to the serial console.
 >
 > Is it a student assignment?  This is so not the right mailing list.

Come on, are we playing hide and seek here?

You can use strace to follow a typical hello world example and
see what device it opens to feed the hello out.
I.e. it can be to the current /dev/ttyX and not to /dev/console
or if you are logged in via SSH to a machine, the device
is again different... or if you use screen, ...

Work your way from there and then use a Linux Source code
Cross Reference (lxr, ask Google for one) and follow the code.

Regards,
-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com

