Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbZINBwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbZINBwv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 21:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbZINBwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 21:52:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbZINBwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 21:52:50 -0400
Message-ID: <4AADA1F9.9080305@redhat.com>
Date: Mon, 14 Sep 2009 09:52:57 +0800
From: Danny Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: cl@linux-foundation.org, penberg@cs.helsinki.fi, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT BISECT] BUG kmalloc-8192: Object already free from kmem_cache_destroy
References: <1252866835.13780.37.camel@dhcp231-106.rdu.redhat.com> <1252883493.16335.8.camel@dhcp231-106.rdu.redhat.com>
In-Reply-To: <1252883493.16335.8.camel@dhcp231-106.rdu.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2009 07:11 AM, Eric Paris wrote:
> On Sun, 2009-09-13 at 14:33 -0400, Eric Paris wrote:
>> 2a38a002fbee06556489091c30b04746222167e4 is first bad commit
>> commit 2a38a002fbee06556489091c30b04746222167e4
>> Author: Xiaotian Feng<dfeng@redhat.com>
>> Date:   Wed Jul 22 17:03:57 2009 +0800
>>
>>      slub: sysfs_slab_remove should free kmem_cache when debug is enabled
>>
>>      kmem_cache_destroy use sysfs_slab_remove to release the kmem_cache,
>>      but when CONFIG_SLUB_DEBUG is enabled, sysfs_slab_remove just release
>>      related kobject, the whole kmem_cache is missed to release and cause
>>      a memory leak.
>>
>>      Acked-by: Christoph Lameer<cl@linux-foundation.org>
>>      Signed-off-by: Xiaotian Feng<dfeng@redhat.com>
>>      Signed-off-by: Pekka Enberg<penberg@cs.helsinki.fi>
>>
>> CONFIG_SLUB_DEBUG=y
>> CONFIG_SLUB=y
>> CONFIG_SLUB_DEBUG_ON=y
>> # CONFIG_SLUB_STATS is not set
>
> I also had problems destroying a kmem_cache in a security_initcall()
> function which had a different backtrace (it's what made me create the
> module and bisect.)   So be sure to let me know what you find so I can
> be sure that we fix that place as well   (I believe that was a kref
> problem rather than a double free)
>
> -Eric
>
>
Could you please tell me the tree you're using? I'll debug on it first...
