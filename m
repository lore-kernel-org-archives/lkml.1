Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbYJ2IbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbYJ2IbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 04:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYJ2IbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 04:31:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60128 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbYJ2IbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 04:31:15 -0400
Date: Wed, 29 Oct 2008 09:30:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gary Hade <garyhade@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86_64: remove debug code from arch_add_memory()
Message-ID: <20081029083053.GB6364@elte.hu>
References: <20081028234314.GA16140@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028234314.GA16140@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gary Hade <garyhade@us.ibm.com> wrote:

> 
> Gets rid of dmesg spam created during physical memory hot-add which
> will very likely confuse users.  The change removes what appears to
> be debugging code which I assume was unintentionally included in:
>   x86: arch/x86/mm/init_64.c printk fixes
>   commit 10f22dde556d1ed41d55355d1fb8ad495f9810c8
> 
> Signed-off-by: Gary Hade <garyhade@us.ibm.com>
> 
> ---
>  arch/x86/mm/init_64.c |    1 -
>  1 file changed, 1 deletion(-)

applied to tip/x86/urgent, thanks Gary!

Note, i changed it slightly: instead of removing it completely i 
changed it to WARN_ON_ONCE(ret), to show us when __add_pages() fails. 
(which is what the original intention was there) This does not trigger 
in your tests, right?

	Ingo

--------------->
>From fe8b868eccb9f85a0e231e35f0abac5b39bac801 Mon Sep 17 00:00:00 2001
From: Gary Hade <garyhade@us.ibm.com>
Date: Tue, 28 Oct 2008 16:43:14 -0700
Subject: [PATCH] x86: remove debug code from arch_add_memory()

Impact: remove incorrect WARN_ON(1)

Gets rid of dmesg spam created during physical memory hot-add which
will very likely confuse users.  The change removes what appears to
be debugging code which I assume was unintentionally included in:

  x86: arch/x86/mm/init_64.c printk fixes
  commit 10f22dde556d1ed41d55355d1fb8ad495f9810c8

Signed-off-by: Gary Hade <garyhade@us.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/init_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index ebe1811..9db01db 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -858,7 +858,7 @@ int arch_add_memory(int nid, u64 start, u64 size)
 		max_pfn_mapped = last_mapped_pfn;
 
 	ret = __add_pages(zone, start_pfn, nr_pages);
-	WARN_ON(1);
+	WARN_ON_ONCE(ret);
 
 	return ret;
 }
