Return-Path: <linux-kernel-owner+w=401wt.eu-S1751281AbZHaUjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbZHaUjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 16:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbZHaUjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 16:39:24 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:60332 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbZHaUjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 16:39:23 -0400
Message-ID: <4A9C34F8.2010307@corp.free.fr>
Date: Mon, 31 Aug 2009 22:39:20 +0200
From: Yohan <ytordjman@corp.free.fr>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Yohan <ytordjman@corp.free.fr>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: VM issue causing high CPU loads
References: <4A92A25A.4050608@yohan.staff.proxad.net> <20090824162155.ce323f08.akpm@linux-foundation.org> <4A96463E.5080002@corp.free.fr>
In-Reply-To: <4A96463E.5080002@corp.free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yohan wrote:
> Andrew Morton wrote:
>> On Mon, 24 Aug 2009 16:23:22 +0200
>> Yohan <kernel@yohan.staff.proxad.net> wrote:  
>>> Hi,
>>>
>>>     Is someone have an idea for that :
>>>
>>>         http://bugzilla.kernel.org/show_bug.cgi?id=14024
>>>     
>> Please generate a kernel profile to work out where all the CPU tie is
>> being spent.  Documentation/basic_profiling.txt is a starting point.
>>   
> I post some new reports, it seems that the problem is in  
> rpcauth_lookup_credcache ...
>
> for information, this is an imap mail server that mounts ~10 netapp 
> over ~300 mountpoints..
    I saw that : http://patchwork.kernel.org/patch/24747/

I did only:

--- linux-2.6.27.21/include/linux/sunrpc/auth.h	2009-03-23 23:04:09.000000000 +0100
+++ linux-2.6.27.21/include/linux/sunrpc/auth.h	2009-05-19 16:02:35.000000000 +0200
@@ -62,8 +62,12 @@ 
  */
- #define RPC_CREDCACHE_HASHBITS	4
+ #define RPC_CREDCACHE_HASHBITS	12


And i test it in prod since sunday: i only have 36% of one core used by 
system
versus more than 3 cores used by system in another server that did a 
drop_caches at morning...

Yohan
