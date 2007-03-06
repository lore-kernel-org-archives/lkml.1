Return-Path: <linux-kernel-owner+w=401wt.eu-S1751627AbXCFQEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbXCFQEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:04:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965163AbXCFQEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:04:04 -0500
Received: from spirit.analogic.com ([204.178.40.4]:1125 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbXCFQEC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:04:02 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 06 Mar 2007 16:03:48.0803 (UTC) FILETIME=[06C71130:01C76009]
Content-class: urn:content-classes:message
Subject: Kernel threads
Date: Tue, 6 Mar 2007 11:03:48 -0500
Message-ID: <Pine.LNX.4.61.0703061101390.4403@chaos.analogic.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Kernel threads
Thread-Index: AcdgCQbyfyN1esoMTt6sLXlesonYaQ==
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Linux kernel" <linux-kernel@vger.kernel.org>
Cc: "Larson, Greg" <GLarson@analogic.com>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

In linux-2.6.16.24, there is a problem with kernel threads
and the aic79xx.c driver.

When nash is executing /initrd/linuxrc in the initial RAM disk
during boot, it will be installing drivers. One driver, aic79xx.c
creates some kernel threads that will exit after the initialization
procedure. Actually the number of tasks depends upon the number
of disks found as the driver spawns these tasks so initialization
can occur in the background. The kernel tasks have been 'parented'
to init. This may be fine for the real init, but nash and other
shells receive the SIGCHLD signal and think that the fork()/exec()
they have executed is complete. This makes nash insert drivers
when the needed previous ones have not yet initialized. Also, when
booting a shell, the signals from the exiting kernel tasks confuse
it.

I think the top-level thread, kthread, should be reaping children
instead of init, which in some cases isn't even running yet.

Any comments?

The current work-around of putting `sleep 10` in linuxrc after
installing each driver is a hack of the worse kind. Especially,
considering an Adaptec controller with many drives attached may
require 'sleep 60'!


Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.68 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
