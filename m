Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbZKLXSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbZKLXSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbZKLXSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:18:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755023AbZKLXSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:18:45 -0500
Date: Thu, 12 Nov 2009 18:15:43 -0500
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Travis <travis@sgi.com>, Andi Kleen <ak@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Limit the number of processor bootup messages
Message-ID: <20091112231542.GA7129@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>,
	Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Roland Dreier <rdreier@cisco.com>,
	Randy Dunlap <rdunlap@xenotime.net>, Tejun Heo <tj@kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Yinghai Lu <yinghai@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
	Jack Steiner <steiner@sgi.com>,
	Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
 <20091023233746.128967000@alcatraz.americas.sgi.com>
 <87tyxmy6x6.fsf@basil.nowhere.org>
 <4AE5E48F.6020408@sgi.com>
 <20091026215544.GA3355@basil.fritz.box>
 <4AEB3D95.50300@sgi.com>
 <4AEEBE65.3070202@linux.intel.com>
 <4AEF3143.2030701@sgi.com>
 <20091112222200.GA19109@redhat.com>
 <4AFC92DD.3020105@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFC92DD.3020105@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 02:57:33PM -0800, H. Peter Anvin wrote:
 > On 11/12/2009 02:22 PM, Dave Jones wrote:
 > > 
 > > But I don't disagree with Andi either, that it's not particularly useful,
 > > and we can get all this from userspace in /proc/cpuinfo, or x86info.
 > > 
 > 
 > I personally don't think it's useful at all.  It gives information about
 > the processor which can be obtained from other sources.  What we want is
 > enough information that the CPU can be unambiguously identified, so that
 > when someone posts dmesg we can tell what machine they came from.

In which case..

	Dave

--- 


Remove the CPU cache size printk's.

They aren't useful, and pollute the dmesg output a lot (especially on machines with many cores).
Also the same information can be trivially found out from userspace.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 804c40e..868fcdd 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -488,22 +493,6 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 #endif
 	}
 
-	if (trace)
-		printk(KERN_INFO "CPU: Trace cache: %dK uops", trace);
-	else if (l1i)
-		printk(KERN_INFO "CPU: L1 I cache: %dK", l1i);
-
-	if (l1d)
-		printk(KERN_CONT ", L1 D cache: %dK\n", l1d);
-	else
-		printk(KERN_CONT "\n");
-
-	if (l2)
-		printk(KERN_INFO "CPU: L2 cache: %dK\n", l2);
-
-	if (l3)
-		printk(KERN_INFO "CPU: L3 cache: %dK\n", l3);
-
 	c->x86_cache_size = l3 ? l3 : (l2 ? l2 : (l1i+l1d));
 
 	return l2;
