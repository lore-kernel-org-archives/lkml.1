Return-Path: <linux-kernel-owner+w=401wt.eu-S1762283AbYGBGvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762283AbYGBGvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 02:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbYGBGvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 02:51:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57915 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755151AbYGBGvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 02:51:36 -0400
Message-ID: <486B250D.3090605@cn.fujitsu.com>
Date: Wed, 02 Jul 2008 14:49:49 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelianov <xemul@openvz.org>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH -mmotm] res_counter: fix building failure
References: <486B1D3D.5070805@cn.fujitsu.com> <6599ad830807012345r4f02f9acq3c8e9be633e109e8@mail.gmail.com>
In-Reply-To: <6599ad830807012345r4f02f9acq3c8e9be633e109e8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Tue, Jul 1, 2008 at 11:16 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> kernel/res_counter.c: In function 'res_counter_memparse_write_strategy':
>> kernel/res_counter.c:115: error: implicit declaration of function 'PAGE_ALIGN'
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Acked-by: Paul Menage <menage@google.com>
> 
> Thanks - what architecture did it break on?
> 

On my x86_32.

I guess this break has something to do with:

http://marc.info/?l=linux-mm&m=121389282702302&w=2
([PATCH -mm] PAGE_ALIGN(): correctly handle 64-bit values on 32-bit)

You tested the patch before that patch was accepted by Andrew.

> Paul
> 
>> ---
>>
>> should follow cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler.patch
>>
>> --- linux-mm/kernel/res_counter.c.bak   2008-07-02 14:05:37.000000000 +0800
>> +++ linux-mm/kernel/res_counter.c       2008-07-02 14:07:36.000000000 +0800
>> @@ -13,6 +13,7 @@
>>  #include <linux/slab.h>
>>  #include <linux/res_counter.h>
>>  #include <linux/uaccess.h>
>> +#include <linux/mm.h>
>>
>>  void res_counter_init(struct res_counter *counter)
>>  {
>>
> 
>
