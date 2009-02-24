Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbZBXLjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbZBXLjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 06:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZBXLjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 06:39:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:60777 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbZBXLji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 06:39:38 -0500
Message-ID: <49A3DC56.5010907@kernel.org>
Date: Tue, 24 Feb 2009 20:39:02 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Subject: Re: [PATCH 02/10] bootmem: clean up arch-specific bootmem wrapping
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <1235445101-7882-3-git-send-email-tj@kernel.org> <20090224113044.GA2060@cmpxchg.org>
In-Reply-To: <20090224113044.GA2060@cmpxchg.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Feb 2009 11:39:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Johannes Weiner wrote:
> This won't suffice as reserve_bootmem() doesn't use
> alloc_bootmem_core(), so now you effectively removed the node-0
> restriction for reserve_bootmem() on this configuration.

Ah... right.  :-(

> I wonder why this setup wants to register several bootmem nodes but
> only use node 0, anyway.  Does someone remember? :)
> 
...
>> -static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
>> +static void * __init __alloc_bootmem_core(struct bootmem_data *bdata,
>>  				unsigned long size, unsigned long align,
>>  				unsigned long goal, unsigned long limit)
> 
> static but you refer to it in arch/x86/include/mmzone_32.h.

Yeah, that's why it's a macro.  I thought about putting it into a
separate header file, say, asm/bootmem-wrapper.h and including it only
from bootmem.c but it looked like an overkill, so...

Thanks.

-- 
tejun
