Return-Path: <linux-kernel-owner+w=401wt.eu-S1762307AbZFKFda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762307AbZFKFda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 01:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759494AbZFKFdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 01:33:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:42388 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755738AbZFKFdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 01:33:14 -0400
Subject: Re: [PATCH -tip] x86: perf_counter AMD supports performance
 monitoring for K7
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090611001341.GA5631@elte.hu>
References: <1244659775.4255.1.camel@ht.satnam>
	 <20090611001341.GA5631@elte.hu>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 11:03:58 +0530
Message-Id: <1244698438.2479.4.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 02:13 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  arch/x86/kernel/cpu/perf_counter.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
> > index 240ca56..5d56742 100644
> > --- a/arch/x86/kernel/cpu/perf_counter.c
> > +++ b/arch/x86/kernel/cpu/perf_counter.c
> > @@ -1436,6 +1436,10 @@ static int intel_pmu_init(void)
> >  
> >  static int amd_pmu_init(void)
> >  {
> > +	/* performance-monitoring supported from K7 */
> > +	if (boot_cpu_data.x86 < 7)
> > +		return -ENODEV;
> > +
> >  	x86_pmu = amd_pmu;
> >  
> >  	switch (boot_cpu_data.x86) {
> 
> A commit under Linux consists of three parts:
> 
>   1) the title
>   2) the changlog
>   3) the body
> 
> This sloppy patch of yours manages to get _all_ three wrong:
> 
>   - the title is wrong (it is incorrect)
>   - the changelog is wrong (it is missing)
>   - the body is wrong (it is broken - K7 != family 7)
> 

oops, sorry here is updated patch :

[PATCH -tip] x86: perf_counter check AMD performance monitoring support

AMD supports performance monitoring from K7.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/perf_counter.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 57ae1be..719a7d5 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1452,6 +1452,10 @@ static int intel_pmu_init(void)
 
 static int amd_pmu_init(void)
 {
+	/* performance-monitoring supported from K7 */
+	if (boot_cpu_data.x86 < 6)
+		return -ENODEV;
+
 	x86_pmu = amd_pmu;
 
 	switch (boot_cpu_data.x86) {
-- 
1.6.3.2


> What the heck is going on here?
> 

hmm, I am really surprise how I wrote Signed-off-by line correct, I was
really very upset at that time, and you know the reason, Please help
me ;-)

Thanks,
--
JSR

