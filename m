Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbZCMNNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbZCMNNG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 09:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbZCMNMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 09:12:52 -0400
Received: from ozlabs.org ([203.10.76.45]:33718 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859AbZCMNMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 09:12:52 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PULL] x86 cpumask work
Date: Fri, 13 Mar 2009 23:42:42 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Mike Travis <travis@sgi.com>
References: <200903121453.45163.rusty@rustcorp.com.au> <20090313052754.GA20389@elte.hu> <20090313053214.GA21183@elte.hu>
In-Reply-To: <20090313053214.GA21183@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903132342.42813.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 March 2009 16:02:14 Ingo Molnar wrote:
> 
> another box crashed too, with:

Interestingly, I needed both these patches.  And *both* generated compile
warnings.  Grr...

Rusty.

Subject: cpumask: fix CONFIG_DEBUG_PER_CPU_MAPS=y cpumask_of_node version.

Impact: Fix crash

c032ef60d1aa9af33730b7a35bbea751b131adc1 "cpumask: convert
node_to_cpumask_map[] to cpumask_var_t" didn't get this one
conversion.  There was a compile warning, but I missed it.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -61,7 +61,7 @@ const cpumask_t *cpumask_of_node(int nod
 		dump_stack();
 		return cpu_online_mask;
 	}
-	return &node_to_cpumask_map[node];
+	return node_to_cpumask_map[node];
 }
 EXPORT_SYMBOL(cpumask_of_node);
 #endif
