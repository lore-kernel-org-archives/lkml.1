Return-Path: <linux-kernel-owner+w=401wt.eu-S1760874AbXKNSp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbXKNSp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbXKNSpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:45:19 -0500
Received: from relay1.sgi.com ([192.48.171.29]:43312 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752487AbXKNSpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:45:18 -0500
Message-ID: <473B423B.6030400@sgi.com>
Date: Wed, 14 Nov 2007 10:45:15 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
CC: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 1/1] x86: convert-cpuinfo_x86-array-to-a-per_cpu-array
 fix
References: <20071012225433.928899000@sgi.com> <20071012225434.102879000@sgi.com>
In-Reply-To: <20071012225434.102879000@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

It appears that this patch is missing from the latest 2.6.24 git kernel?

(Suresh noticed that it is still a problem.)

Thanks,
Mike

This fix corrects the problem that early_identify_cpu() sets
cpu_index to '0' (needed when called by setup_arch) after
smp_store_cpu_info() had set it to the correct value.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86_64/kernel/smpboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/arch/x86_64/kernel/smpboot.c	2007-10-12 14:28:45.000000000 -0700
+++ linux/arch/x86_64/kernel/smpboot.c	2007-10-12 14:53:42.753508152 -0700
@@ -141,8 +141,8 @@ static void __cpuinit smp_store_cpu_info
 	struct cpuinfo_x86 *c = &cpu_data(id);
 
 	*c = boot_cpu_data;
-	c->cpu_index = id;
 	identify_cpu(c);
+	c->cpu_index = id;
 	print_cpu_info(c);
 }
 


