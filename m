Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328Ab0AHXdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab0AHXdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 18:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285Ab0AHXdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 18:33:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51588 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab0AHXdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 18:33:36 -0500
Message-ID: <4B47C0BD.5010700@zytor.com>
Date: Fri, 08 Jan 2010 15:33:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Andreas Dilger <adilger@Sun.COM>
CC: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng v2.17 (stable)
References: <20100108093302.GS1969@nb.net.home> <4B47A713.9060405@zytor.com> <329167C1-CF54-4742-B0B7-AD0B9DEFDEC1@sun.com>
In-Reply-To: <329167C1-CF54-4742-B0B7-AD0B9DEFDEC1@sun.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2010 02:40 PM, Andreas Dilger wrote:
> On 2010-01-08, at 14:43, H. Peter Anvin wrote:
>> On 01/08/2010 01:33 AM, Karel Zak wrote:
>>> fdisk:
>>>   - the fdisk command aligns newly created partitions to  
>>> minimum_io_size
>>>     boundary ("minimum_io_size" is physical sector size or stripe  
>>> chunk
>>>     size on RAIDs).
>>>
>>>   - the fdisk command supports disks with alignment_offset now.
>>
>> I think we should align, by default, much more aggressively than  
>> that --
>> because frequently we just don't know what the real physical alignment
>> is (think of flash media, which uses large erase blocks underneath.)
>> Windows aligns partitions 1 MB boundaries by default now -- I think
>> that's probably a reasonably good idea, at least for any disk that's  
>> not
>> tiny, say 256 MB or less.
> 
> I agree whole heartedly.  We steer users very sharply away from using  
> partitions at all, because on h/w RAID devices the 512-byte offset  
> from fdisk completely kills RAID-5/6 performance.
> 
> Making the default minimum alignment for DOS/GPT partitions makes a  
> lot of sense, and LVM PEs should be on 1MB boundaries as well (I don't  
> think that is the case today either).
> 

As far as I can tell, there is absolutely no reason to not align all
partitions, all the time (for both GPT and MBR... GPT may need a "dummy
alignment partition" to fulfill the "no nonpartitioned space" dictum,
although it seems like an impossible requirement in practice -- I think
they main reason for it is to avoid abusers like Grub relying on putting
data in unpartitioned space.)

	-hpa
