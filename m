Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab0BDUDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:03:08 -0500
Received: from xenotime.net ([72.52.64.118]:53140 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932976Ab0BDUDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:03:04 -0500
Message-ID: <4B6B27F5.6090504@xenotime.net>
Date: Thu, 04 Feb 2010 12:03:01 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>
Subject: Re: mmotm 2010-02-03-20-09 uploaded (mmap.c)
References: <201002040435.o144Z5jc007582@imap1.linux-foundation.org>	<4B6B0E9F.5060002@xenotime.net> <20100204105827.2270aff0.akpm@linux-foundation.org>
In-Reply-To: <20100204105827.2270aff0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/10 10:58, Andrew Morton wrote:
> On Thu, 04 Feb 2010 10:14:55 -0800
> Randy Dunlap<rdunlap@xenotime.net>  wrote:
>
>> On 02/03/10 20:09, akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2010-02-03-20-09 has been uploaded to
>>>
>>>      http://userweb.kernel.org/~akpm/mmotm/
>>>
>>> and will soon be available at
>>>
>>>      git://zen-kernel.org/kernel/mmotm.git
>>>
>>> It contains the following patches against 2.6.33-rc6:
>>
>>
>> In some config cases, this patch seems to have a problem:
>>     sysctl-clean-up-vm-related-variable-declarations.patch
>>
>> In mm/mmap.c:
>> +#ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
>> +/* Used by each architecture's private code and sysctl. */
>> +int sysctl_legacy_va_layout;
>> +#endif
>>
>> mm/mmap.c:92: error: expected identifier or '(' before numeric constant
>>
>> I guess that sometimes sysctl_legacy_va_layout is a #define:
>> from include/linux/mm.h:
>>
>> #ifdef CONFIG_SYSCTL
>> extern int sysctl_legacy_va_layout;
>> #else
>> #define sysctl_legacy_va_layout 0
>> #endif
>>
>> and indeed the failing builds do not have CONFIG_SYSCTL enabled.
>
> Thanks.  This, I guess:
>
> --- a/mm/mmap.c~sysctl-clean-up-vm-related-variable-declarations-fix
> +++ a/mm/mmap.c
> @@ -87,7 +87,7 @@ int sysctl_overcommit_ratio = 50;	/* def
>   int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
>   struct percpu_counter vm_committed_as;
>
> -#ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
> +#if defined(HAVE_ARCH_PICK_MMAP_LAYOUT)&&  defined(CONFIG_SYSCTL)
>   /* Used by each architecture's private code and sysctl. */
>   int sysctl_legacy_va_layout;
>   #endif
> _
>

Yep, that works.  Thanks.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>


-- 
~Randy
