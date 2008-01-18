Return-Path: <linux-kernel-owner+w=401wt.eu-S1761928AbYARPfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761928AbYARPfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 10:35:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759178AbYARPfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 10:35:01 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:1043 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759097AbYARPfA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 10:35:00 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 18 Jan 2008 15:16:33.0065 (UTC) FILETIME=[1BE84990:01C859E5]
Content-class: urn:content-classes:message
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incrementalfsck)
Date: Fri, 18 Jan 2008 10:16:30 -0500
Message-ID: <Pine.LNX.4.61.0801181006330.7389@chaos.analogic.com>
in-reply-to: <20080118142308.GD12796@mit.edu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Patch] document ext3 requirements (was Re: [RFD] Incrementalfsck)
thread-index: AchZ5Rv0NIILbehVQD+KFXkPxNrI2w==
References: <478FE22D.9030907@emc.com> <OF3F61F02C.985CCACC-ON882573D4.0001DCF2-882573D4.0002E9F5@us.ibm.com> <20080118142308.GD12796@mit.edu>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Theodore Tso" <tytso@MIT.EDU>
Cc: "Bryan Henderson" <hbryan@us.ibm.com>, "Ric Wheeler" <ric@emc.com>,
       "Al Boldi" <a1426z@gawab.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "David Chinner" <dgc@sgi.com>, <linux-kernel@vger.kernel.org>,
       "Pavel Machek" <pavel@ucw.cz>, "Daniel Phillips" <phillips@google.com>,
       "Rik van Riel" <riel@redhat.com>,
       "Valerie Henson" <val.henson@gmail.com>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 18 Jan 2008, Theodore Tso wrote:

> On Thu, Jan 17, 2008 at 04:31:48PM -0800, Bryan Henderson wrote:
>> But I heard some years ago from a disk drive engineer that that is a myth
>> just like the rotational energy thing.  I added that to the discussion,
>> but admitted that I haven't actually seen a disk drive write a partial
>> sector.
>
> Well, it would be impossible or at least very hard to see that in
> practice, right?  My understanding is that drives do sector-level
> checksums, so if there was a partially written sector, the checksum
> would be bogus and the drive would return an error when you tried to
> read from it.
>
>> Ted brought up the separate issue of the host sending garbage to the disk
>> device because its own power is failing at the same time, which makes the
>> integrity at the disk level moot (or even undesirable, as you'd rather
>> write a bad sector than a good one with the wrong data).
>
> Yep, exactly.  It would be interesting to see if this happens on
> modern hardware; all of the evidence I've had for this is years old at
> this point.
>
> 							- Ted

I have a Seagate Barracuda 7200.9 80 Gbyte SATA drive that I
use for experiments. I can permanently destroy a EXT3 file-system
at least 50% of the time by disconnecting the data cable while
a `dd` write to a file is in progress. Something bad happens
making partition information invalid. I have to re-partition
to reuse the drive.

If I try the same experiment by disconnecting power to the drive
the file is no good (naturally), but the rest of the file-system
is fine.

My theory is that the destination offset is present in every
SATA access and some optimization code within the drive sets
the heads to track zero and writes before any CRC or checksum
is done to find out if it was the correct offset with the
correct data!

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
