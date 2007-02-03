Return-Path: <linux-kernel-owner+w=401wt.eu-S1751043AbXBCXs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751043AbXBCXs7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 18:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbXBCXs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 18:48:59 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:55321 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbXBCXs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 18:48:58 -0500
Message-ID: <45C51F6C.7080300@us.ibm.com>
Date: Sat, 03 Feb 2007 17:49:00 -0600
From: Maynard Johnson <maynardj@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.3) Gecko/20040910
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: cbe-oss-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, oprofile-list@lists.sourceforge.net
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 4/4] Add support to OProfile for profiling
 Cell BE SPUs -- update
References: <45BE4ED0.5030808@us.ibm.com> <45BE4FA4.9020105@us.ibm.com> <200701300839.05144.arnd@arndb.de>
In-Reply-To: <200701300839.05144.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:

>On Monday 29 January 2007 20:48, Maynard Johnson wrote:
>  
>
>>Subject: Add support to OProfile for profiling Cell BE SPUs
>>
>>    
>>
>  
>
[snip]

>>+ * 
>>+ * Ideally, we would like to be able to create the cached_info for
>>+ * an SPU task just one time -- when libspe first loads the SPU 
>>+ * binary file.  We would store the cached_info in a list.  Then, as
>>+ * SPU tasks are switched out and new ones switched in, the cached_info
>>+ * for inactive tasks would be kept, and the active one would be placed
>>+ * at the head of the list.  But this technique may not with
>>+ * current spufs functionality since the spu used in bind_context may
>>+ * be a different spu than was used in a previous bind_context for a
>>+ * reactivated SPU task.  Additionally, a reactivated SPU task may be
>>+ * assigned to run on a different physical SPE.  We will investigate
>>+ * further if this can be done.
>>+ *
>>+ */
>>    
>>
>
>You should stuff a pointer to cached_info into struct spu_context,
>e.g. 'void *profile_private'.
>  
>
I seem to recall looking at this option a while back, but didn't go that 
route since struct spu_context is opaque to me.  With such a teqnique, I 
could then use a simple 16-element array of  pointers to cached_info 
objects, creating them as needed when spu_context->profile_private is 
NULL.  I suppose the better option for now is to add a 
get_profile_private() function to SPUFs, rather than requiring 
spu_context to be visible.  Don't know why I didn't think to do that 
before.  Ah, well, live and learn.

-Maynard

>  
>
>>+struct cached_info {
>>+       vma_map_t * map;
>>+       struct spu * the_spu;
>>+       struct kref cache_ref;
>>+       struct list_head list;
>>+};
>>    
>>
>
>And replace the 'the_spu' member with a back pointer to the
>spu_context if you need it.
>
>  
>
>	Arnd <><
>  
>


