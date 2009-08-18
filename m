Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbZHRDH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbZHRDH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 23:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbZHRDHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 23:07:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48032 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbZHRDHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 23:07:25 -0400
Message-ID: <4A8A1B2E.20505@redhat.com>
Date: Tue, 18 Aug 2009 11:08:30 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Thomas Gleixner <tglx@linutronix.de>, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [Patch] proc: drop write permission on 'timer_list' and 'slabinfo'
References: <20090817094525.6355.88682.sendpatchset@localhost.localdomain>  <20090817094822.GA17838@elte.hu> <1250502847.5038.16.camel@penberg-laptop> <alpine.DEB.1.10.0908171228300.16267@gentwo.org> <4A8986BB.80409@cs.helsinki.fi> <alpine.DEB.1.10.0908171240370.16267@gentwo.org> <4A8A0B0D.6080400@redhat.com> <4A8A0B14.8040700@cn.fujitsu.com>
In-Reply-To: <4A8A0B14.8040700@cn.fujitsu.com>
Content-Type: multipart/mixed;
 boundary="------------000201070303040303050302"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000201070303040303050302
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Li Zefan wrote:
>>  static int __init slab_proc_init(void)
>>  {
>> -	proc_create("slabinfo",S_IWUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
>> +	proc_create("slabinfo",S_IRUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
>>     
>
> S_IRUSR|S_IRUGO == S_IRUGO
>
>   

Ah, yeah. Thanks!

Update it.

Signed-off-by: WANG Cong <amwang@redhat.com>



--------------000201070303040303050302
Content-Type: text/plain;
 name="proc-file-write-permission-fix2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="proc-file-write-permission-fix2.diff"

diff --git a/mm/slub.c b/mm/slub.c
index b9f1491..61398c0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4726,7 +4726,7 @@ static const struct file_operations proc_slabinfo_operations = {
 
 static int __init slab_proc_init(void)
 {
-	proc_create("slabinfo",S_IWUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
+	proc_create("slabinfo",S_IRUGO,NULL,&proc_slabinfo_operations);
 	return 0;
 }
 module_init(slab_proc_init);

--------------000201070303040303050302--
