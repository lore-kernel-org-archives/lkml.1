Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab0BHQzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 11:55:42 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:45916 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab0BHQzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 11:55:40 -0500
Message-ID: <4B704188.4020009@oracle.com>
Date: Mon, 08 Feb 2010 08:53:28 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       fweisbec@gmail.com, mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       mhiramat@redhat.com
Subject: Re: [PATCH 5/6] syscalls: add define syscall prefix macro
References: <cover.1265142153.git.jbaron@redhat.com> <ce5ccbcc86e34954948239b17010c5537fb62917.1265142153.git.jbaron@redhat.com> <20100203130104.GB30003@osiris.boeblingen.de.ibm.com> <20100208154856.GC2688@redhat.com>
In-Reply-To: <20100208154856.GC2688@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B7041E3.01F9:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/10 07:48, Jason Baron wrote:
> On Wed, Feb 03, 2010 at 02:01:04PM +0100, Heiko Carstens wrote:
>> On Tue, Feb 02, 2010 at 04:21:55PM -0500, Jason Baron wrote:
>>> Add a new 'SYSCALL_PREFIX_DEFINE#()' style macro to include/linux/syscalls.h.
>>> This allows us to create syscalls via:
>>>
>>> SYSCALL_PREFIX_DEFINE1(32_, mmap, struct mmap_arg_struct __user *, arg);
>>>
>>> The standard 'SYSCALL_DEFINE#()' macro forces 'sys_blah', but for the 32 compat
>>> calls we want 'sys32_blah'.
>>
>> Not really. That's what you want for x86. But the generic name for compat syscalls
>> is compat_sys_whatever. The arch specific compat syscalls don't follow a common
>> naming scheme (yet).
>> Especially if you consider the idea to get automated correct sign extension via
>> hpa's planned script for compat syscalls it would be good if you would just name
>> that define something like SYSCALL_COMPAT.. or COMPAT_SYSCALL..
>> That way it would be easy to add a hook in there.
> 
> So I was trying to keep the names of the arch ia32 compat sys calls the
> same, ie 'sys32_blah'. However, I agree a common naming scheme makes
> more sense. what about 'arch_compat_sys_blah'? So as to distinguish from
> the common compat syscalls 'compat_sys_blah'.

Hi,
I can't find my copy of the original posting... sorry about that.

Are these new SYSCALL macros just a shorthand/shortcut to cut down on typing
(and/or errors)?

The added level of indirection makes problems for scripts/kernel-doc (well, if any of
the syscalls have kernel-doc notation, that is).  I'd prefer not to see 2 levels of macros
for defining a syscall, but if it has to live, please look into updating scripts/kernel-doc
also.

thanks,
-- 
~Randy
