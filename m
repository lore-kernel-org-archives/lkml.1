Return-Path: <linux-kernel-owner+w=401wt.eu-S1759281AbYETGxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281AbYETGxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 02:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbYETGxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 02:53:32 -0400
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:58945 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753588AbYETGxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 02:53:32 -0400
Message-ID: <48327569.9070306@gmail.com>
Date: Mon, 19 May 2008 23:53:29 -0700
From: John Hubbard <john.hubbard@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Soumyadip Das Mahapatra <kernelhacker@visualserver.org>,
       linux-kernel@vger.kernel.org, akinobu.mita@gmail.com
Subject: Re: [PATCH 1/2] bitreversal program
References: <Pine.LNX.4.64.0805191859411.18461@visualserver.org> <1211229736.5915.86.camel@brick>
In-Reply-To: <1211229736.5915.86.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a340b2e653f5c7e365dae0426e8fce169ef193a6bfc3dd48c1abc0394cd169fc15f9fa569e8f3b6a85709c4405726f5b350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 70.231.148.90
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:

>> +static inline u32 gen_bit_rev(u32 x, u32 k)
>>   {
>> -       return byte_rev_table[byte];
>> +       if(k & 1)
>> +               x = (x & 0x55555555) << 1 | (x & 0xaaaaaaaa) >> 1;
>> +       if(k & 2)
>> +               x = (x & 0x33333333) << 2 | (x & 0xcccccccc) >> 2;
>> +       if(k & 4)
>> +               x = (x & 0x0f0f0f0f) << 4 | (x & 0xf0f0f0f0) >> 4;
>> +       if(k & 8)
>> +               x = (x & 0x00ff00ff) << 8 | (x & 0xff00ff00) >> 8;
>> +       if(k & 16)
>> +               x = (x & 0x0000ffff) << 16 | (x & 0xffff0000) >> 16;
>> +
>> +       return x;
>>   }
> 
> Why is this better than a single 256 byte table?
> 
> Harvey
> 

One reason it could be better, at least in some situations, is that the 
above is more likely to execute directly from the CPU's instruction 
cache. The table lookup appears more efficient at first, until you 
consider the memory caching hierarchy.

--John Hubbard
