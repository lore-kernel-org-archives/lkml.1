Return-Path: <linux-kernel-owner+w=401wt.eu-S1751747AbZHSKif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbZHSKif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 06:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbZHSKie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 06:38:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58033 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751380AbZHSKie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 06:38:34 -0400
Message-ID: <4A8BD67F.8020007@redhat.com>
Date: Wed, 19 Aug 2009 18:39:59 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Li Zefan <lizf@cn.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [Patch] proc: drop write permission on 'timer_list' and	'slabinfo'
References: <20090817094822.GA17838@elte.hu> <1250502847.5038.16.camel@penberg-laptop> <alpine.DEB.1.10.0908171228300.16267@gentwo.org> <4A8986BB.80409@cs.helsinki.fi> <alpine.DEB.1.10.0908171240370.16267@gentwo.org> <4A8A0B0D.6080400@redhat.com> <4A8A0B14.8040700@cn.fujitsu.com> <4A8A1B2E.20505@redhat.com> <20090818120032.GA22152@localhost> <4A8B652E.40905@redhat.com> <20090819023737.GA17710@localhost>
In-Reply-To: <20090819023737.GA17710@localhost>
Content-Type: multipart/mixed;
 boundary="------------030905000202030905000704"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030905000202030905000704
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Wu Fengguang wrote:
> On Wed, Aug 19, 2009 at 10:36:30AM +0800, Amerigo Wang wrote:
>   
>> Wu Fengguang wrote:
>>     
>>> On Tue, Aug 18, 2009 at 11:08:30AM +0800, Amerigo Wang wrote:
>>>
>>>   
>>>       
>>>> -	proc_create("slabinfo",S_IWUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
>>>> +	proc_create("slabinfo",S_IRUGO,NULL,&proc_slabinfo_operations);
>>>>     
>>>>         
>>> Style nitpick. The spaces were packed to fit into 80-col I guess.
>>>
>>>   
>>>       
>> Yeah, I noticed this too, the reason I didn't fix this is that I don't 
>> want to mix coding style fix with this one. We can fix it in another 
>> patch, if you want. :)
>>     
>
> Why not? This don't hurt readability of the patch, hehe.
>   

Here we go.

Pekka, could you please also take the patch attached below? It is just a 
trivial coding style fix. And it is based on the my previous patch.

Thanks!


Signed-off-by: WANG Cong <amwang@redhat.com>




--------------030905000202030905000704
Content-Type: text/plain;
 name="mm-slub_c-style-fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mm-slub_c-style-fix.diff"

diff --git a/mm/slub.c b/mm/slub.c
index 61398c0..1cd60ff 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1109,8 +1109,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	}
 
 	if (kmemcheck_enabled
-		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS)))
-	{
+		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS))) {
 		int pages = 1 << oo_order(oo);
 
 		kmemcheck_alloc_shadow(page, oo_order(oo), flags, node);
@@ -2001,7 +2000,7 @@ static inline int calculate_order(int size)
 				return order;
 			fraction /= 2;
 		}
-		min_objects --;
+		min_objects--;
 	}
 
 	/*
@@ -4726,7 +4725,7 @@ static const struct file_operations proc_slabinfo_operations = {
 
 static int __init slab_proc_init(void)
 {
-	proc_create("slabinfo",S_IRUGO,NULL,&proc_slabinfo_operations);
+	proc_create("slabinfo", S_IRUGO, NULL, &proc_slabinfo_operations);
 	return 0;
 }
 module_init(slab_proc_init);

--------------030905000202030905000704--
