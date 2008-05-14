Return-Path: <linux-kernel-owner+w=401wt.eu-S1756013AbYENVXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbYENVXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbYENVXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:23:13 -0400
Received: from spirit.analogic.com ([204.178.40.4]:1875 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbYENVXM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:23:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 14 May 2008 21:23:10.0843 (UTC) FILETIME=[B5EF94B0:01C8B608]
Content-class: urn:content-classes:message
Subject: Re: How to avoid data copies in a driver ?
Date: Wed, 14 May 2008 17:23:10 -0400
Message-ID: <Pine.LNX.4.61.0805141716120.11052@chaos.analogic.com>
In-Reply-To: <38b2ab8a0805141254i2437a0ccq130b914748f53db0@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: How to avoid data copies in a driver ?
thread-index: Aci2CLYJKWYxSxBBTaiXtpXzy+ts3Q==
References: <38b2ab8a0805141254i2437a0ccq130b914748f53db0@mail.gmail.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Francis Moreau" <francis.moro@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-TM-AS-Product-Ver: SMEX-8.0.0.1259-5.500.1026-15910.002
X-TM-AS-Result: No--13.888000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 14 May 2008, Francis Moreau wrote:

> Hello,
>
> I'd like to optimize my driver, which receives data through a fifo and gives
> them to a user space application. In turns this application moves this data
> into a file.
>
> To avoid several useless copies, I'd like the application to pass to
> the driver
> a file descriptor (?) to  the driver and then the driver can directly
> move the
> received data to that file.
>
> Could anybody give me some example of such scheme ?
>
> Thanks,
> -- 
> Francis
> --

You memory-map the data. Impliment mmap() in your driver.
You can also impliment poll()  { select() } so your
application knows when new data are available.

You cannot use a user-mode file-descriptor in the kernel.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
