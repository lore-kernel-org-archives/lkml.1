Return-Path: <linux-kernel-owner+w=401wt.eu-S1760350AbZFLTeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760350AbZFLTeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 15:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757556AbZFLTe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 15:34:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:42062 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757381AbZFLTe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 15:34:29 -0400
Subject: Re: [PATCH 2/2 -tip] x86: perf_counter update AMD hw caching
 related event table
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090612173520.GB22015@elte.hu>
References: <1244714289.6923.0.camel@ht.satnam>
	 <1244714379.6923.2.camel@ht.satnam>  <20090612173520.GB22015@elte.hu>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 01:05:18 +0530
Message-Id: <1244835318.2802.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 19:35 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > AMD shares same hw caching related event table.
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  arch/x86/kernel/cpu/perf_counter.c |   36 +++++++++++++++---------------------
> >  1 files changed, 15 insertions(+), 21 deletions(-)
> 
> Looks good - but your patch does not apply anymore. (Neither to -git 
> nor to -tip)
> 

It is because of L2 -> LL

Here are new patches :

[PATCH 1/2 -tip] x86: perf_counter check AMD performance monitoring support

AMD supports performance monitoring from K7.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/perf_counter.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 275bc14..b74e602 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1459,6 +1459,10 @@ static int intel_pmu_init(void)
 
 static int amd_pmu_init(void)
 {
+	/* performance-monitoring supported from K7 */
+	if (boot_cpu_data.x86 < 6)
+		return -ENODEV;
+
 	x86_pmu = amd_pmu;
 
 	switch (boot_cpu_data.x86) {
-- 
1.6.0.6



