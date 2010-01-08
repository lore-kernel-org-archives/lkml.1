Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267Ab0AHWkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab0AHWkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 17:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181Ab0AHWkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 17:40:36 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:40392 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab0AHWkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 17:40:35 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Date: Fri, 08 Jan 2010 15:40:33 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [ANNOUNCE] util-linux-ng v2.17 (stable)
In-reply-to: <4B47A713.9060405@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Message-id: <329167C1-CF54-4742-B0B7-AD0B9DEFDEC1@sun.com>
X-Mailer: Apple Mail (2.936)
References: <20100108093302.GS1969@nb.net.home> <4B47A713.9060405@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-01-08, at 14:43, H. Peter Anvin wrote:
> On 01/08/2010 01:33 AM, Karel Zak wrote:
>> fdisk:
>>   - the fdisk command aligns newly created partitions to  
>> minimum_io_size
>>     boundary ("minimum_io_size" is physical sector size or stripe  
>> chunk
>>     size on RAIDs).
>>
>>   - the fdisk command supports disks with alignment_offset now.
>
> I think we should align, by default, much more aggressively than  
> that --
> because frequently we just don't know what the real physical alignment
> is (think of flash media, which uses large erase blocks underneath.)
> Windows aligns partitions 1 MB boundaries by default now -- I think
> that's probably a reasonably good idea, at least for any disk that's  
> not
> tiny, say 256 MB or less.

I agree whole heartedly.  We steer users very sharply away from using  
partitions at all, because on h/w RAID devices the 512-byte offset  
from fdisk completely kills RAID-5/6 performance.

Making the default minimum alignment for DOS/GPT partitions makes a  
lot of sense, and LVM PEs should be on 1MB boundaries as well (I don't  
think that is the case today either).


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

