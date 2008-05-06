Return-Path: <linux-kernel-owner+w=401wt.eu-S933438AbYEFWWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438AbYEFWWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 18:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922AbYEFWW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 18:22:28 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:1743 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbYEFWW0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 18:22:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 06 May 2008 22:22:23.0263 (UTC) FILETIME=[A809DAF0:01C8AFC7]
Content-class: urn:content-classes:message
Subject: Re: Compact Flash Question
Date: Tue, 6 May 2008 18:22:22 -0400
Message-ID: <Pine.LNX.4.61.0805061807110.18849@chaos.analogic.com>
In-Reply-To: <005b01c8afc4$77f4ec90$6401a8c0@techwriter>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Compact Flash Question
thread-index: Acivx6gRVV+L47HRTzaUaFqjplUMsw==
References: <005b01c8afc4$77f4ec90$6401a8c0@techwriter>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Yigal Sadgat" <YSadgat1@gcte.com>
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
       <jwboyer@linux.vnet.ibm.com>, <joern@logfs.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-TM-AS-Product-Ver: SMEX-8.0.0.1259-5.500.1026-15894.002
X-TM-AS-Result: No--18.631000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I was told by SanDisk when CF first came out to ignore
what the "lynix guys" (sic) were saying when I was
excoriated on this list for saying that everything
one needs to do is already incorporated into the
Compact Flash and it needs only to be treated as a
disk, nothing else!

Compact Flash is not just some flash RAM with an
IDE interface plug. It contains both static RAM
and flash RAM. It goes by pages and a stale page
is flushed to flash when a new page is being
accessed, or when other (propriatary) events are
true. The result is that most of the accesses
go to static RAM.

We have devices in the field with Linux embedded
in them for about 4 years that continuously write
to Compact Flash because the CF is mounted as
the root file-system and there is both log activity
and NTPD activity. The stuff still works and, in fact,
we have lost processors, power supplies, and Ethernet
controllers, but never CompactFlash.

There was some version of Linux that blacklisted the
CompactFlash that we were using. It thought it was
some hard disk that it didn't like. I removed the
black-listing and it worked fine. That was in a
device that had a RAM disk mounted on /tmp and
/var to minimize "wear." Eventually, we got rid of that.

On Tue, 6 May 2008, Yigal Sadgat wrote:

> We wrote the Kernel to support CF drives (in IDE mode) several years ago but
> now there are strange things coming back from the field that compel us to go
> back and re-evaluate many design decisions.
>
> For instance,
> (1) Can you really ignore bit(2) (CORR) in the Status register offset 7 that
> tells
> you that the CF has detected and corrected a soft error?, etc.
> (2) An engineer at SanDisk Engineering told me NOT to do wear leveling.
> The file allocation table is written very frequently back into the flash. So
> is it really safe to assume that I don't need wear leveling???
> (3) Re. the BUSY bit in the status register (offset 7, bit D7), anybody
> experienced
> time outs?
> (4) Re Error register (offset 1) bit D7 (BBK), again, I was told that it
> cannot (???)
> happen since the CF performs read-after-write and it automatically switches
> good blocks
> for bad ones... Is this correct?
>
> We get many "soft" errors and I cannot wait to put my hand on a system to
> test but
> thought I would draw on your collective experience before we dive into these
> issues again.
>
> Any comments would be greatly appreciated.
>
> Yigal Sadgat
> General Computer Technology (GCT)
> YSadgat1@gcte.com
>

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
