Return-Path: <linux-kernel-owner+w=401wt.eu-S1031418AbXEDRnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031418AbXEDRnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031434AbXEDRnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:43:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031418AbXEDRni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:43:38 -0400
Message-ID: <463B7097.7070300@redhat.com>
Date: Fri, 04 May 2007 13:42:47 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Dave Jones <davej@codemonkey.org.uk>, cpufreq@lists.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: cpufreq longhaul locks up
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr> <463B687D.1020600@interia.pl>
In-Reply-To: <463B687D.1020600@interia.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafał Bilski wrote:
>> Hi,
> Hello all
>> I found that setting the cpufreq governor to ondemand making the box 
>> lock up solid in 2.6.20.2 and 2.6.21 after a few seconds.
>> [...]
> 
> I can't explain this. Some motherboards are running fine, some don't.
> I'm running longhaul too. It is working fine. No lockups at all. 
> So far I heard only about one Epia which had problems with longhaul. 
> It was almost like my Epia but older.
> What is possible:
> - some chipsets revisions are broken and aren't blocking DMA,
> - special setup is required, some versions of BIOS are doing 
> necessary things, some don't,
> - some chipsets revisions are broken and drivers are not aware. At 
> the beginning Unichrome driver was causing lockups on my machine, but 
> Openchrome was fine. Longhaul may trigger, somehow, other hardware bug. 
> 

The below is in the cpufreq git tree.

(Maybe also ondemand needs to be disabled for Longhaul?)

From: Rafal Bilski <rafalbilski@interia.pl>
Date: Sun, 22 Apr 2007 10:26:04 +0000 (+0200)
Subject: [CPUFREQ] Longhaul - Revert Longhaul ver. 2
X-Git-Url: http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fdavej%2Fcpufreq.git;a=commitdiff_plain;h=07844252ffd81ec192a62014bada1016c9703765

[CPUFREQ] Longhaul - Revert Longhaul ver. 2

There is something wrong with this code. It needs more
testing. It is better to disable it for now because support
for some machines will be broken.

Signed-off-by: Rafal Bilski <rafalbilski@interia.pl>
Signed-off-by: Dave Jones <davej@redhat.com>
---

diff --git a/arch/i386/kernel/cpu/cpufreq/longhaul.c b/arch/i386/kernel/cpu/cpufreq/longhaul.c
index e5fee72..a3df9c0 100644
--- a/arch/i386/kernel/cpu/cpufreq/longhaul.c
+++ b/arch/i386/kernel/cpu/cpufreq/longhaul.c
@@ -683,7 +683,7 @@ static int __init longhaul_cpu_init(struct cpufreq_policy *policy)
 				sizeof(samuel2_eblcr));
 			break;
 		case 1 ... 15:
-			longhaul_version = TYPE_LONGHAUL_V2;
+			longhaul_version = TYPE_LONGHAUL_V1;
 			if (c->x86_mask < 8) {
 				cpu_model = CPU_SAMUEL2;
 				cpuname = "C3 'Samuel 2' [C5B]";

