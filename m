Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbXBRXS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbXBRXS4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 18:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbXBRXSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 18:18:55 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53768 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbXBRXSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 18:18:55 -0500
Message-ID: <45D8DEE0.4020203@us.ibm.com>
Date: Sun, 18 Feb 2007 17:18:56 -0600
From: Maynard Johnson <maynardj@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.3) Gecko/20040910
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: maynardj@us.ibm.com
CC: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
       Carl Love <cel@us.ibm.com>, cbe-oss-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling updated
 patch
References: <1171497138.23691.8.camel@dyn9047021078.beaverton.ibm.com> <200702151537.51202.arnd@arndb.de> <45D4FBB0.7090109@us.ibm.com> <200702161814.26855.arnd@arndb.de> <45D62583.5080701@us.ibm.com>
In-Reply-To: <45D62583.5080701@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maynard Johnson wrote:

>Arnd Bergmann wrote:
>
>  
>
>>On Friday 16 February 2007 01:32, Maynard Johnson wrote:
>>
>>    
>>
>>>config OPROFILE_CELL
>>>       bool "OProfile for Cell Broadband Engine"
>>>       depends on OPROFILE && SPU_FS
>>>       default y if ((SPU_FS = y && OPROFILE = y) || (SPU_FS = m && 
>>>OPROFILE = m))
>>>       help
>>>         Profiling of Cell BE SPUs requires special support enabled
>>>         by this option.  Both SPU_FS and OPROFILE options must be
>>>         set 'y' or both be set 'm'.
>>>=============
>>>
>>>Can anyone see a problem with any of this . . . or perhaps a suggestion 
>>>of a better way?
>>>      
>>>
>>The text suggests it doesn't allow SPU_FS=y with OPROFILE=m, which I think
>>should be allowed. 
>>    
>>
>Right, good catch.  I'll add another OR to the 'default y' and correct 
>the text.
>  
>
Actually, it makes more sense to do the following:

config OPROFILE_CELL
       bool "OProfile for Cell Broadband Engine"
       depends on  (SPU_FS = y && OPROFILE = m) || (SPU_FS = y && 
OPROFILE = y) || (SPU_FS = m && OPROFILE = m)
       default y
       help
         Profiling of Cell BE SPUs requires special support enabled by 
this option.

> > I also don't see any place in the code where you actually
>  
>
>>use CONFIG_OPROFILE_CELL.
>>    
>>
>As I mentioned, I will use CONFIG_OPROFILE_CELL in the 
>arch/powerpc/oprofile/Makefile as follows:
>      oprofile-$(CONFIG_OPROFILE_CELL) += op_model_cell.o \
>               cell/spu_profiler.o cell/vma_map.o cell/spu_task_sync.o
>
>  
>
>
[snip]

>>	Arnd <><
>>    
>>
>
>
>_______________________________________________
>Linuxppc-dev mailing list
>Linuxppc-dev@ozlabs.org
>https://ozlabs.org/mailman/listinfo/linuxppc-dev
>  
>


