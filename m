Return-Path: <linux-kernel-owner+w=401wt.eu-S1764591AbYEBAga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764591AbYEBAga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 20:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933513AbYEBAfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 20:35:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932699AbYEBAfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 20:35:39 -0400
Date: Thu, 1 May 2008 17:34:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
cc: Tom Rini <trini@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       davem@davemloft.net, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: huge gcc 4.1.{0,1} __weak problem
In-Reply-To: <20080501233038.GA20601@linux-os.sc.intel.com>
Message-ID: <alpine.LFD.1.10.0805011729540.5994@woody.linux-foundation.org>
References: <20080430013108.GA18207@linux-os.sc.intel.com> <20080429.212833.192304794.davem@davemloft.net> <924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com> <20080501215633.GU29330@cs181133002.pp.htv.fi> <20080501152051.4eb4bad3.akpm@linux-foundation.org>
 <alpine.LFD.1.10.0805011525460.5994@woody.linux-foundation.org> <20080501223515.GA11366@linux-os.sc.intel.com> <20080501154238.eccdb6ff.akpm@linux-foundation.org> <20080501232116.GD4354@smtp.west.cox.net> <20080501233038.GA20601@linux-os.sc.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 May 2008, Venki Pallipadi wrote:
> 
> __weak function with single return statement, did not get inlined when called
> from say

Is it always about inlining? If so, can't we add a __noinline__ to the 
declaration of __weak?

Something like this oneliner?

		Linus

---
 include/linux/compiler-gcc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 5c8351b..4061fc7 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -41,7 +41,7 @@
 
 #define __deprecated			__attribute__((deprecated))
 #define __packed			__attribute__((packed))
-#define __weak				__attribute__((weak))
+#define __weak				__attribute__((weak)) noinline
 #define __naked				__attribute__((naked))
 #define __noreturn			__attribute__((noreturn))
 
