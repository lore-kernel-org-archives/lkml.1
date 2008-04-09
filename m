Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbYDICPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbYDICPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 22:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYDICPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 22:15:22 -0400
Received: from mail.rz.uni-duesseldorf.de ([134.99.128.30]:46773 "EHLO
	mail.rz.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868AbYDICPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 22:15:22 -0400
X-Greylist: delayed 2085 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Apr 2008 22:15:21 EDT
Date: Wed, 09 Apr 2008 03:40:34 +0200 (CEST)
From: Michael Schmitz <schmitz@zirkon.biophys.uni-duesseldorf.de>
Subject: Re: [PATCH 5/5] falconide/q40ide: add ->atapi_*put_bytes and
 ->ata_*put_data methods
In-reply-to: <20080408094029.GA1005@linux-m68k.org>
To: Richard Zidlicky <rz@linux-m68k.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Michael Schmitz <schmitz@debian.org>
Message-id: <alpine.DEB.1.00.0804090337110.19638@zirkon.biophys.uni-duesseldorf.de>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
References: <200803301714.04527.bzolnier@gmail.com>
 <200803302134.42569.bzolnier@gmail.com>
 <Pine.LNX.4.64.0803310750230.6871@anakin>
 <200804072113.42441.bzolnier@gmail.com> <20080408094029.GA1005@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> v2:
>> * Add 'struct request *rq' argument to ->ata_{in,out}put_data methods
>>   and don't byte-swap disk fs requests (we shouldn't un-swap fs requests
>>   because fs itself is stored byte-swapped on the disk) - this is how
>>   things were done before the patch (ideally device mapper should be
>>   used instead but it would break existing setups and would have some
>>   performance impact).
>
> I like the part about checking 'struct request *rq', will make a  clean
> distinction between ide command data and ide disk/medium data which is badly
> needed.
>
> However, not only FS data is byteswapped, complete disk including partition
> table and everything else is. Will "rq->cmd_type == REQ_TYPE_FS" also catch
> all these cases?

IIRC only identify data (and perhaps ATAPI data) need to be byteswapped 
twice (or not at all), so REQ_TYPE_FS should catch all other cases.

(Good catch about ATAPI there, BTW - I never thought about that, and ISTR 
that IDE CD-ROMs never worked in Linux. That would be the reason why..)

 	Michael
