Return-Path: <linux-kernel-owner+w=401wt.eu-S933607AbYDVWoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607AbYDVWoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760558AbYDVWoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:44:06 -0400
Received: from rtr.ca ([76.10.145.34]:2160 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760337AbYDVWoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:44:04 -0400
Message-ID: <480E6A35.4040108@rtr.ca>
Date: Tue, 22 Apr 2008 18:44:05 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
Cc: Seewer Philippe <philippe.seewer@bfh.ch>, linux-kernel@vger.kernel.org
Subject: Re: Disk geometry from /sys
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>	 <480354C9.1050600@bfh.ch>	 <38b2ab8a0804150040i14840a9fudc3b95ba80d52ac1@mail.gmail.com>	 <4805AF93.90209@bfh.ch>	 <38b2ab8a0804170709m58830adagcba46f059ed10809@mail.gmail.com>	 <4807635E.9060101@bfh.ch> <4808A09B.6090106@rtr.ca> <38b2ab8a0804221316o7cab5641q16814849a1099b9a@mail.gmail.com>
In-Reply-To: <38b2ab8a0804221316o7cab5641q16814849a1099b9a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francis Moreau wrote:
> Hello Mark
> 
> On Fri, Apr 18, 2008 at 3:22 PM, Mark Lord <lkml@rtr.ca> wrote:
>>  That can sound a bit misleading.  The complete story, for ATA/SATA drives,
>>  is that the disk has two geometries:  an internal physical one, with a
>> fixed number of heads and cylinders, but variable sectors/track
>>  (which normally varies by cylinder zone).
>>
>>  Software *never* sees or knows about that geometry, so ignore it.
>>
>>  The second geometry, is the one that the drive reports to software
>>  as its "native" geometry.  This is what you see from "hdparm -I"
>>  and friends, and this geometry is what has to be used by software
>>  when using cylinder/head/sector (CHS) addressing for I/O operations.
>>  The hardware interface has a limit of 4-bits for the head value,
>>  so the maximum number of heads can never be more than 16.
>>
>>  Nobody uses CHS addressing for I/O operations, at least not on
>>  any hardware newer than at least ten years old, so this geometry
>>  is also unimportant for most uses.
>>
> 
> Is it because IDE drives support several IO operation modes ?
..

The earliest IDE drives for Compaq used only CHS sector addressing mode.

Within four years, though, all new drives had support for the more 
sensible linear block addressing (LBA) mode, as well.

LBA has been mandatory in new drives since the early 1990s,
so there's really no point to CHS addressing any more,
except when fiddling with MS-DOS style partition tables
(which have both CHS and LBA values stored inside).

Cheers
