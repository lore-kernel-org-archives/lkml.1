Return-Path: <linux-kernel-owner+w=401wt.eu-S1753719AbZFEO23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbZFEO23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbZFEO2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:28:22 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:32195 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZFEO2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:28:22 -0400
Message-ID: <4A292B0D.8030807@oracle.com>
Date: Fri, 05 Jun 2009 22:26:21 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Amerigo Wang <xiyou.wangcong@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: /proc/kcore has a unreasonable size(281474974617600) in x86_64
 2.6.30-rc8.
References: <4A289928.7040508@oracle.com> <20090604223805.2962e826.akpm@linux-foundation.org> <4A28C262.5020605@oracle.com> <20090605075614.GC8171@cr0.nay.redhat.com> <4A28DDEB.4000409@oracle.com> <2375c9f90906050209h191df8fav36fc9507654c5ca6@mail.gmail.com> <20090605021424.ba352b0f.akpm@linux-foundation.org> <4A28E5C9.6010408@oracle.com> <20090605095155.GC8354@cr0.nay.redhat.com>
In-Reply-To: <20090605095155.GC8354@cr0.nay.redhat.com>
Content-Type: multipart/mixed;
 boundary="------------020801040705060709020408"
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.4A292B17.01B6:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020801040705060709020408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



Amerigo Wang wrote:
> On Fri, Jun 05, 2009 at 05:30:49PM +0800, Tao Ma wrote:
>>> Please send the boot logs: dmesg -s 1000000 > foo
>> attached.
> 
>> #######high memory 18446612137615818752, size_t 18446612137615818752
>> #######kcore size 5301604352, PAGE_OFFSET 0, PAGE_SIZE 4096
> 
> 
> These two lines must be added by yourself...
> 
> What?!
> How can PAGE_OFFSET be 0??
> Can you show us these two printk() you just added?
> 
> And, the size of kcore is not the crazy number in the subject...
> This one is much saner..
Sorry, I used the wrong printk. the correct one is:
#######high memory 18446612137615818752, size_t 18446612137615818752
#######kcore size 5301604352, PAGE_OFFSET 18446612132314218496, 
PAGE_SIZE 4096

the printk is attached.

Thanks.
Tao

--------------020801040705060709020408
Content-Type: text/plain;
 name="printk.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="printk.diff"

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 59b43a0..50830c7 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -408,6 +408,13 @@ static int __init proc_kcore_init(void)
 	if (proc_root_kcore)
 		proc_root_kcore->size =
 				(size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
+	printk(KERN_INFO "#######high memory %lu, size_t %llu\n",
+	       (unsigned long long)high_memory, (size_t)high_memory);
+	if (proc_root_kcore)
+		printk(KERN_INFO "#######kcore size %lu, "
+		       "PAGE_OFFSET %lu, PAGE_SIZE %lu\n",
+		       proc_root_kcore->size,
+		       PAGE_OFFSET, PAGE_SIZE);
 	return 0;
 }
 module_init(proc_kcore_init);

--------------020801040705060709020408--
