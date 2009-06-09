Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbZFID4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbZFID4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 23:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbZFID4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 23:56:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50085 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbZFID4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 23:56:31 -0400
Date: Tue, 9 Jun 2009 13:56:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: linux-next: manual merge of the rr tree with the  tree
Message-Id: <20090609135627.944b1851.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

Today's linux-next merge of the rr tree got a conflict in
arch/x86/kernel/cpu/mcheck/mce{,_64}.c between commit mce_init_device
("x86, mce: Rename sysfs variables") from the  tree and commit
10242805fc2c7f25d63097426def1bb3c8545db9 ("cpumask: alloc zeroed cpumask
for static cpumask_var_ts") from the rr tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/cpu/mcheck/mce.c
index 1d0aa9c,705bc24..0000000
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@@ -1297,7 -1163,7 +1297,7 @@@ static __init int mce_init_device(void
  	if (!mce_available(&boot_cpu_data))
  		return -EIO;
  
- 	alloc_cpumask_var(&mce_dev_initialized, GFP_KERNEL);
 -	alloc_cpumask_var(&mce_device_initialized, GFP_KERNEL | __GFP_ZERO);
++	alloc_cpumask_var(&mce_dev_initialized, GFP_KERNEL | __GFP_ZERO);
  
  	err = mce_init_banks();
  	if (err)
