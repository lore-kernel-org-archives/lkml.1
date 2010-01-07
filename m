Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470Ab0AGClT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab0AGClT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 21:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756071Ab0AGClS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 21:41:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60158 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752355Ab0AGClR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 21:41:17 -0500
Message-ID: <4B4549CB.8000809@cn.fujitsu.com>
Date: Thu, 07 Jan 2010 10:41:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "menage@google.com" <menage@google.com>,
       kirill@shutemov.name
Subject: Re: mmotm 2010-01-06-14-34 uploaded (kernel/cgroup)
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>	<20100106170849.d0d95c9b.randy.dunlap@oracle.com> <20100107113154.a1fa0103.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100107113154.a1fa0103.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 6 Jan 2010 17:08:49 -0800
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> On Wed, 06 Jan 2010 14:34:36 -0800 akpm@linux-foundation.org wrote:
>>
>>> The mm-of-the-moment snapshot 2010-01-06-14-34 has been uploaded to
>>>
>>>    http://userweb.kernel.org/~akpm/mmotm/
>>>
>>> and will soon be available at
>>>
>>>    git://zen-kernel.org/kernel/mmotm.git
>>>
>>> It contains the following patches against 2.6.33-rc3:
>>
>> kernel/cgroup.c: In function 'cgroup_write_event_control':
>> kernel/cgroup.c:2949: error: implicit declaration of function 'eventfd_fget'
>> kernel/cgroup.c:2949: warning: assignment makes pointer from integer without a cast
>> kernel/cgroup.c:2955: error: implicit declaration of function 'eventfd_ctx_fileget'
>> kernel/cgroup.c:2955: warning: assignment makes pointer from integer without a cast
>> make[2]: *** [kernel/cgroup.o] Error 1
>>
> 
> Hmm, how about this rather than adding #ifdefs..
> Paul, Li, how do you think ?

I think make CONFIG_CGROUPS select EVENTFD would be better.

> ==
> Cgroup's eventdf feature has depenedecy to EVENTFD
> 
> This is a patch onto
> cgroup-implement-eventfd-based-generic-api-for-notifications.patch
> 
> CC: Li Zefan <lizf@cn.fujitsu.com>
> CC: Kirill A. Shutemov <kirill@shutemov.name>
> CC: Paul Menage <menage@google.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> ---
>  init/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: ref-mmotm/init/Kconfig
> ===================================================================
> --- ref-mmotm.orig/init/Kconfig
> +++ ref-mmotm/init/Kconfig
> @@ -509,6 +509,7 @@ endchoice
>  
>  menuconfig CGROUPS
>  	boolean "Control Group support"
> +	depends on EVENTFD
>  	help
>  	  This option adds support for grouping sets of processes together, for
>  	  use with process control subsystems such as Cpusets, CFS, memory
> 
> 
> 
