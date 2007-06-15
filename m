Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbXFODoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbXFODoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 23:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbXFODoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 23:44:09 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:39619
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbXFODoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 23:44:07 -0400
Date: Thu, 14 Jun 2007 20:43:18 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Neil Brown <neilb@suse.de>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: limits on raid
In-Reply-To: <18034.479.256870.600360@notabene.brown>
Message-ID: <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
 <18034.479.256870.600360@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007, Neil Brown wrote:

> On Thursday June 14, david@lang.hm wrote:
>> what is the limit for the number of devices that can be in a single array?
>>
>> I'm trying to build a 45x750G array and want to experiment with the
>> different configurations. I'm trying to start with raid6, but mdadm is
>> complaining about an invalid number of drives
>>
>> David Lang
>
> "man mdadm"  search for "limits".  (forgive typos).

thanks.

why does it still default to the old format after so many new versions? 
(by the way, the documetnation said 28 devices, but I couldn't get it to 
accept more then 27)

it's now churning away 'rebuilding' the brand new array.

a few questions/thoughts.

why does it need to do a rebuild when makeing a new array? couldn't it 
just zero all the drives instead? (or better still just record most of the 
space as 'unused' and initialize it as it starts useing it?)

while I consider zfs to be ~80% hype, one advantage it could have (but I 
don't know if it has) is that since the filesystem an raid are integrated 
into one layer they can optimize the case where files are being written 
onto unallocated space and instead of reading blocks from disk to 
calculate the parity they could just put zeros in the unallocated space, 
potentially speeding up the system by reducing the amount of disk I/O.

.this wouldn't work if the filesystem is crowded, but a lot of large 
arrays are used for storing large files (i.e. sequential writes of large 
amounts of data) and it would seem that this could be a substantial win in 
these cases.

is there any way that linux would be able to do this sort of thing? or is 
it impossible due to the layering preventing the nessasary knowledge from 
being in the right place?

David Lang
