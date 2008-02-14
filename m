Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbYBNPGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbYBNPGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbYBNPGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:06:42 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:3405 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbYBNPGl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:06:41 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 14 Feb 2008 15:06:33.0668 (UTC) FILETIME=[2FCAD040:01C86F1B]
Content-class: urn:content-classes:message
Subject: Re: Is there a "blackhole" /dev/null directory?
Date: Thu, 14 Feb 2008 10:06:33 -0500
Message-ID: <Pine.LNX.4.61.0802140952550.1324@chaos.analogic.com>
In-Reply-To: <47B43138.40206@trashmail.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Is there a "blackhole" /dev/null directory?
Thread-Index: AchvGy/UBlSGCRSDRhmOThK5fwtZLg==
References: <20080214093051.7240852AB0E31@trashmail.net> <1202981957.10928.17.camel@phobos.jasper.bg> <47B43138.40206@trashmail.net>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Mika Lawando" <rzryyvzy@trashmail.net>
Cc: <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 14 Feb 2008, Mika Lawando wrote:

> Jasper Bryant-Greene schrieb:
>> On Thu, 2008-02-14 at 10:30 +0100, rzryyvzy wrote:
>>
>>> /dev/null is often very useful, specially if programs force to save data in some file. But some programs like to creates different temporary file names, so /dev/null could no more work.
>>>
>>> What is with a "/dev/null"-directory?
>>> I mean a "blackhole pseudo directory" which eats every write to null.
>>>
>>> Here is how it could work:
>>> mount -t nulldir nulldir /dev/nulldir
>>>
>>> Now if a program does a create(2),
>>> it creates in the memory the file with its fd.
>>> Then if a program does a write(2) to the fd, it eats the writes and give out fakely it has written the number of bytes.
>>> When the program calls does a close(2) of the fd, then the complete inode is deleted in the memory.
>>>
>>> The directory should  be permanently empty except for the inodes with open file descriptors. So only inode information would be temporary saved in this "nulldir tmpfs" directory.
>>>
>>> Is there already existing a possibility to create a null directory?
>>>
>>
>> This could be done fairly trivially with FUSE, and IMHO is a good use
>> for FUSE because since you're just throwing most data away, performance
>> is not a concern.
>>
> Unfortunately performance is a concern because if not I would write on
> the hard disk the files, and then remove them with a cronjob.
> But from the point of view of the time of developpment, FUSE is a good
> idea, because its possible to write a filesystem quickly in Perl.
>
> -- 
> Best regards,
> Mika
> --

Creating a null directory wouldn't work because a directory
is just a link to find a file. The actual file gets written
using the file-descriptor, without any reference whosoever
to the path. If you have root privileges, you can use
`mknod tempfile c 1 3` to create a null file with any
name you want. Unfortunately, somebody decided that
you need root privileges to execute mknod so ordinary
users can not do this.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.28 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
