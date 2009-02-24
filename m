Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbZBXQyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbZBXQyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 11:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756933AbZBXQxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 11:53:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50910 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734AbZBXQxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 11:53:47 -0500
Date: Tue, 24 Feb 2009 11:52:50 -0500
From: Dave Jones <davej@redhat.com>
To: Frans Pop <elendil@planet.nl>
Cc: Mattias-Christian Ott <ott@mirix.org>, Dominik Brodowski <linux@brodo.de>,
       Joerg Platte <jplatte@naasa.net>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH] p4-clockmod: Calculate frequency based on TSC value
	for P4 models 0 and 1
Message-ID: <20090224165250.GB2998@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Frans Pop <elendil@planet.nl>,
	Mattias-Christian Ott <ott@mirix.org>,
	Dominik Brodowski <linux@brodo.de>,
	Joerg Platte <jplatte@naasa.net>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	cpufreq@vger.kernel.org
References: <200902240809.01312.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902240809.01312.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 08:08:58AM +0100, Frans Pop wrote:
 > From: Mattias-Christian Ott <ott@mirix.org>
 > 
 > Commit ed9cbcd40004904dbe61ccc16d6106a7de38c998 reverted an incorrect
 > change that resulted in random frequencies being displayed in some cases
 > for early P4 models because the MSR_FBC_REGISTER_ID ratio is undefined.
 >     
 > Result of the revert is that for some users the CPU frequency is displayed
 > multiplied by a factor 8 in /proc/cpuinfo when p4-clockmod is loaded.
 >     
 > Calculating the frequency from the TSC value should work in all cases.

I already picked this up in cpufreq-next. 
Additionally, it needs the chunk below.

(checkpatch also complains about the overlong line in the original
 patch which I fixed up before merging).

	Dave

diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
index 2bb6a83..4f5c247 100644
--- a/arch/x86/include/asm/timer.h
+++ b/arch/x86/include/asm/timer.h
@@ -11,8 +11,8 @@ unsigned long native_calibrate_tsc(void);
 
 #ifdef CONFIG_X86_32
 extern int timer_ack;
+#endif
 extern int recalibrate_cpu_khz(void);
-#endif /* CONFIG_X86_32 */

-- 
http://www.codemonkey.org.uk
