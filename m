Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbZAPB2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbZAPB2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 20:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZAPB2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 20:28:31 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:18604 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbZAPB23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 20:28:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=XzRHzpBGefjRBgAQwEA8TrndHko+ph2Ul/mnjhKaOP/Ck9ku48Pl4W2zC+NuBZNRnU
         EvLFR7EgbS4YyK04KNIHnRT5bMEjXLrZH6mz7nlIWlR4dRHx36GqixVL1A4scIBAcZS4
         Zw162s5rIKOsKLSo1sh7Ic84OP6eLX9jMkt2g=
Message-ID: <496FE2B3.3060706@gmail.com>
Date: Fri, 16 Jan 2009 10:28:19 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: roel kluin <roel.kluin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, ebiederm@xmission.com,
       cl@linux-foundation.org, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: [PATCH x86/percpu] x86: fix build bug introduced during merge
References: <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu> <25e057c00901150204x61c54d9fl91afe23477d1f12f@mail.gmail.com> <496F0F5E.3080404@kernel.org> <20090115113230.GH22850@elte.hu> <496F1FA6.6050204@kernel.org> <20090115122222.GI22850@elte.hu> <496F3577.4020303@kernel.org> <20090115133206.GA31416@elte.hu> <20090115133916.GA3417@elte.hu> <496FB09A.8020808@kernel.org>
In-Reply-To: <496FB09A.8020808@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_PER_CPU_SYMBOL() got misplaced during merge leading to build
failure.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/setup_percpu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-integrator/clock.h b/arch/arm/mach-integrator/clock.h
deleted file mode 100644
index e69de29..0000000
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index daeedf8..b5c35af 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -86,9 +86,8 @@ void __cpuinit load_pda_offset(int cpu)
 }
 #ifndef CONFIG_SMP
 DEFINE_PER_CPU(struct x8664_pda, __pda);
-EXPORT_PER_CPU_SYMBOL(__pda);
 #endif
-
+EXPORT_PER_CPU_SYMBOL(__pda);
 #endif /* CONFIG_SMP && CONFIG_X86_64 */
 
 #ifdef CONFIG_X86_64
