Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbZHRB6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbZHRB6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 21:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbZHRB6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 21:58:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38052 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbZHRB6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 21:58:07 -0400
Message-ID: <4A8A0B0D.6080400@redhat.com>
Date: Tue, 18 Aug 2009 09:59:41 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Thomas Gleixner <tglx@linutronix.de>, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [Patch] proc: drop write permission on 'timer_list' and 'slabinfo'
References: <20090817094525.6355.88682.sendpatchset@localhost.localdomain>  <20090817094822.GA17838@elte.hu> <1250502847.5038.16.camel@penberg-laptop> <alpine.DEB.1.10.0908171228300.16267@gentwo.org> <4A8986BB.80409@cs.helsinki.fi> <alpine.DEB.1.10.0908171240370.16267@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0908171240370.16267@gentwo.org>
Content-Type: multipart/mixed;
 boundary="------------050500090409000700090907"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050500090409000700090907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Christoph Lameter wrote:
> On Mon, 17 Aug 2009, Pekka Enberg wrote:
>
>   
>>> slab needs the write permissions for tuning!
>>>       
>> Oh, crap, you're right, I had forgotten about that. It's probably best to keep
>> slub permissions as-is, no?
>>     

Oops! I misread the code... sorry.

>
> slub perms can be changed. The patch is okay for that. But there is no
> write method in slub. Effectively it makes no difference. Just the
> display is nicer in /proc.
>
>
>   
Ah, ok, I update this part of patch, attached.

Thanks!

Signed-off-by: WANG Cong <amwang@redhat.com>




--------------050500090409000700090907
Content-Type: text/plain;
 name="proc-file-write-permission-fix2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="proc-file-write-permission-fix2.diff"

diff --git a/mm/slub.c b/mm/slub.c
index b9f1491..aba2c1b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4726,7 +4726,7 @@ static const struct file_operations proc_slabinfo_operations = {
 
 static int __init slab_proc_init(void)
 {
-	proc_create("slabinfo",S_IWUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
+	proc_create("slabinfo",S_IRUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
 	return 0;
 }
 module_init(slab_proc_init);

--------------050500090409000700090907--
