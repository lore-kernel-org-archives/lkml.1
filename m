Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202Ab0AKQxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab0AKQxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 11:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269Ab0AKQxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 11:53:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47173 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab0AKQxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 11:53:30 -0500
Message-ID: <4B4B5768.2040005@zytor.com>
Date: Mon, 11 Jan 2010 08:52:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng v2.17 (stable)
References: <20100108093302.GS1969@nb.net.home> <4B47A713.9060405@zytor.com> <20100111140255.GA1416@ucw.cz>
In-Reply-To: <20100111140255.GA1416@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2010 06:05 AM, Pavel Machek wrote:
> On Fri 2010-01-08 13:43:47, H. Peter Anvin wrote:
>> On 01/08/2010 01:33 AM, Karel Zak wrote:
>>>
>>> fdisk:
>>>     - the fdisk command aligns newly created partitions to minimum_io_size
>>>       boundary ("minimum_io_size" is physical sector size or stripe chunk
>>>       size on RAIDs).
>>>
>>>     - the fdisk command supports disks with alignment_offset now.
>>>
>>
>> I think we should align, by default, much more aggressively than that --
>> because frequently we just don't know what the real physical alignment
>> is (think of flash media, which uses large erase blocks underneath.)
>
> Flash has special mapping layer, and does not care (SD/MMC), or is a
> raw nand and can't be used as block device (smartmedia).
>

Uhm, that's just plain wrong.

It doesn't matter if there is a "special mapping layer" -- if you're 
crossing multiple erase blocks you're still having more churn in your 
flash translation layer, with more wear on the device, and lower 
performance than if you didn't.

	-hpa
