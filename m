Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbZBPKXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbZBPKXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 05:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbZBPKXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 05:23:33 -0500
Received: from mail.klingt.org ([86.59.21.178]:57076 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845AbZBPKXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 05:23:32 -0500
Date: Mon, 16 Feb 2009 11:23:13 +0100
From: Tim Blechmann <tim@klingt.org>
To: Robert Richter <robert.richter@amd.com>
Cc: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc4 regression (was: Re: 2.6.28-rc9: oprofile
 regression)
Message-ID: <20090216112313.359ef437@thinkpad>
In-Reply-To: <20090213190740.GD25042@erda.amd.com>
References: <1229869416.6911.1.camel@thinkpad>
 <49932C35.3020300@klingt.org>
 <20090213190740.GD25042@erda.amd.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (klingt.org [127.0.0.1]); Mon, 16 Feb 2009 11:23:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> still, I can not reproduce this with my tests with v2.6.29-rc4. The
> regression on the systems I have runs fine on rc4. On the system you
> have, is commit b99170288421c79f0c2efa8b33e26e65f4bb7fb8 the first bad
> one? If so, I will split the patch into smaller pieces to find the
> change that introduces the bug.

i got revision df13b31c286b3e91c556167954eda088d90a4295 working, by not
resetting the counter width:

diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 12e207a..f0e019d 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -76,12 +76,14 @@ static void ppro_setup_ctrs(struct op_msrs const * const msrs)
 			return;
 	}
 
+#if 0
 	if (cpu_has_arch_perfmon) {
 		union cpuid10_eax eax;
 		eax.full = cpuid_eax(0xa);
 		if (counter_width < eax.split.bit_width)
 			counter_width = eax.split.bit_width;
 	}
+#endif


this tweak did not work on later kernels, that i tested, though, and i 
haven't had time to look into it in more detail.

tim

-- 
tim@klingt.org
http://tim.klingt.org

Linux is like a wigwam: no windows, no gates, apache inside, stable.
