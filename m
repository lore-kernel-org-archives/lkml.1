Return-Path: <linux-kernel-owner+w=401wt.eu-S1752442AbXBDRdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbXBDRdp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 12:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbXBDRdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 12:33:45 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58135 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbXBDRdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 12:33:44 -0500
Message-ID: <45C618FA.3060000@us.ibm.com>
Date: Sun, 04 Feb 2007 11:33:46 -0600
From: Maynard Johnson <maynardj@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.3) Gecko/20040910
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: cbe-oss-dev@ozlabs.org, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 4/4] Add support to OProfile for profiling
 Cell BE SPUs -- update
References: <45BE4ED0.5030808@us.ibm.com> <200701300839.05144.arnd@arndb.de> <45C51F6C.7080300@us.ibm.com> <200702040352.03792.arnd@arndb.de>
In-Reply-To: <200702040352.03792.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:

>On Sunday 04 February 2007 00:49, Maynard Johnson wrote:
>  
>
>>I seem to recall looking at this option a while back, but didn't go that 
>>route since struct spu_context is opaque to me.  With such a teqnique, I 
>>could then use a simple 16-element array of  pointers to cached_info 
>>objects, creating them as needed when spu_context->profile_private is 
>>NULL.  I suppose the better option for now is to add a 
>>get_profile_private() function to SPUFs, rather than requiring 
>>spu_context to be visible.
>>    
>>
>
>Yes, that sounds good. Note that the file providing the 
>spufs_get_profile_private (and respective spufs_set_profile_private)
>functions needs to be compiled into the kernel then in case oprofile
>gets linked in but spufs is a module.
>  
>
Hmm . . . we already depend on the register/unregister functions in 
sched.c, so my patch changes the oprofile Kconfig to default to 'm' and 
'depends on SPU_FS'.

>I think it would also be necessary to have another interface for cleaning
>up this data when spufs destroys the context. That could possibly
>a variation of the existing notifier call, or a new call, or you
>establish the convention that if the private pointer is non-NULL,
>spufs will kfree it.
>  
>
Yes, I was thnking along the lines of your last suggestion.  I presume 
OProfile gets notified (object_id == 0) before the context is actually 
destroyed.  At that time, we would NULL-out the reference to the 
cached_info, so then SPUFS would kfree it at destroy time.

-Maynard

>	Arnd <><
>  
>


