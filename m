Return-Path: <linux-kernel-owner+w=401wt.eu-S1763417AbYCDSAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763417AbYCDSAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757842AbYCDR7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:59:46 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:23698 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758107AbYCDR7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:59:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=UcVw9HgBHqm4DHgteH+mGfm6qyrR20DkV/Vbu9+eOtLmk1uN80mnex4Nt8btoTlxNauOF/+zkOBGP1m+uQjwrdeFp6MUEJmkesQ/9W/DybSo00y86woxprP96U6K3K+AjYQEoWC9H+kGuTln9TNwTncStB0WPSaZUm56lh2Oats=
Message-ID: <47CD8E02.1020207@gmail.com>
Date: Wed, 05 Mar 2008 02:59:30 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: walt <w41ter@gmail.com>
CC: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: fix residual byte count handling
References: <20080304175302T.fujita.tomonori@lab.ntt.co.jp> <20080304085944.GG6704@kernel.dk> <20080304180648W.fujita.tomonori@lab.ntt.co.jp> <20080304182228Z.fujita.tomonori@lab.ntt.co.jp> <20080304093536.GH6704@kernel.dk> <1204634238.5997.5.camel@homer.simson.net> <20080304123939.GM6704@kernel.dk> <fqk15l$lgq$1@ger.gmane.org>
In-Reply-To: <fqk15l$lgq$1@ger.gmane.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

walt wrote:
> Jens Axboe wrote:
>> On Tue, Mar 04 2008, Mike Galbraith wrote:
>>> On Tue, 2008-03-04 at 10:35 +0100, Jens Axboe wrote:
>>>
>>>> Looks excellent to me, has a variant of this been tested as OK by the
>>>> users reporting the regression?
>>> K3b burning seems to be a nogo here.  This is git pulled this morning
>>> though, so it's a somewhat different tree than previously tested fwtw.
>>
>> can you please try git as of this morning without any patches applied,
>> and then pull
>>
>> git://git.kernel.dk/linux-2.6-block.git for-linus
>>
>> into that and see if that works?
> 
> Unfortunately this doesn't fix a problem I've discussed off-list with
> Kiyoshi Ueda, who suggested that I should follow this thread and try
> any patches posted here.
> 
> Here is what happens when I try to mount a CD (before and after I
> pull 'for-linus'):
> 
> hdc: ide_cd_check_ireason: wrong transfer direction!
> cdrom: failed setting lba address space
> hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hdc: drive not ready for command
> hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hdc: drive not ready for command
> hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hdc: drive not ready for command
> hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hdc: drive not ready for command
> hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hdc: drive not ready for command
> hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hdc: drive not ready for command
> hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hdc: drive not ready for command
> hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hdc: drive not ready for command
> hdc: status timeout: status=0xd0 { Busy }
> ide: failed opcode was: unknown
> hdc: DMA disabled
> hdc: drive not ready for command
> hdc: ATAPI reset complete
> ISO 9660 Extensions: Microsoft Joliet Level 3
> ISOFS: changing to secondary root
> VFS: busy inodes on changed media.
> 
> The mount can take from 5 seconds on up to a minute or so before the
> CD can be accessed.

Which version did you try?  There was a recent IDE bug fix which
affected CD recording.  Commit bcd88ac3b2ff2eae3d0fa57a6b02d4fce5392f32
which is included in 2.6.25-rc3.  Also, did 2.6.24 work?

-- 
tejun
