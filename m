Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbZANEu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbZANEu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 23:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbZANEur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 23:50:47 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:8790 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbZANEuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 23:50:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=t87iqLjHG7BaOA2Z27ClNYATB22Lco230PznBL41J5R0pwiQQfw1nkVreoWVGGzCFU
         Jeb1qCJfv2ZEIe2+22eCUe26aUbu4RC4u9BnPzAG3Xmp/h7X4FVTkZ6IA39Ax/ZHTbpK
         X3CLkyAHuGv+IWey5jRXRHECVhb7GDmwVAc2M=
Message-ID: <b9df5fa10901132043j5a577b2fxeaaa4cc1fdd551f2@mail.gmail.com>
Date: Wed, 14 Jan 2009 10:43:24 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: Fix section mismatch in memcontrol.c
Cc: "Li Zefan" <lizf@cn.fujitsu.com>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       mingo@elte.hu, "Andrew Morton" <akpm@linux-foundation.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>
In-Reply-To: <20090113151307.e9ddc085.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b9df5fa10901122139h4bfb727i64f864ec185c731d@mail.gmail.com>
	 <496C2B4F.3090406@cn.fujitsu.com>
	 <20090113151307.e9ddc085.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure. You can carryout your other jobs. Here is the patch.
Thanks for your help guys.

--- linux-2.6-orig/mm/memcontrol.c	2009-01-12 09:53:10.000000000 +0600
+++ linux-2.6/mm/memcontrol.c	2009-01-13 19:55:02.846459224 +0600
@@ -2170,13 +2170,13 @@ static void mem_cgroup_put(struct mem_cg


 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
-static void __init enable_swap_cgroup(void)
+static void __init_refok enable_swap_cgroup(void)
 {
 	if (!mem_cgroup_disabled() && really_do_swap_account)
 		do_swap_account = 1;
 }
 #else
-static void __init enable_swap_cgroup(void)
+static void __init_refok enable_swap_cgroup(void)
 {
 }
 #endif


On 1/13/09, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 13 Jan 2009 13:49:03 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
>
>> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
>>
>> Rakib Mullick wrote:
>> > Impact: Fix section mismatch warning.
>> >
>> > The annotation for __init in enable_swap_cgroup() and __initdata for
>> > really_do_swap_account produces the following warning. Which is not
>> > right, since this function is called from non-init section. This patch
>> > fixes it. If anything else please notice.
>> >
>>
>> I saw this warning on IA64. But this fix is wrong IMO.
>>
>> enable_swap_cgroup() will be called at system boot only:
>>
>> start_kernel()
>>   cgroup_init()
>>     mem_cgroup_create()
>>       enable_swap_cgroup()
>>
>> I think the proper fix is annotate mem_cgroup_create() with __init_refok.
>>
> I think Li Zefan's fix is correct.
> Could you make a patch ? or I'll schedule this as my work.
>
> Thanks,
> -Kame
>
>
>
