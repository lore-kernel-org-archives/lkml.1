Return-Path: <linux-kernel-owner+w=401wt.eu-S1761390AbZLJSP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761390AbZLJSP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 13:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761215AbZLJSP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 13:15:56 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49553 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761101AbZLJSPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 13:15:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U669eUD6eIcOJpOffHP5D2sZpswBsaT2tQho72OVURXzR9U3JlnhmXFJekAviEdE9k
         97S5tBPaxlxVhzLM59J8HqjUl4nLskaMpwi71ig8mCOT2mZhc1O6ZlS1K32pJaCqEdI9
         WWRX93995Bdr08wM99KpCL60o0YOS9LZVw6k8=
Date: Thu, 10 Dec 2009 21:15:58 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, Ralf.Hildebrandt@charite.de, tglx@linutronix.de,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] x86, perf events: Check if we have APIC
	enabled
Message-ID: <20091210181558.GI5086@lenovo>
References: <20091210165634.GF5086@lenovo> <tip-125580380f418000b1a06d9a54700f1191b6e561@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-125580380f418000b1a06d9a54700f1191b6e561@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 05:18:32PM +0000, tip-bot for Cyrill Gorcunov wrote:
> Commit-ID:  125580380f418000b1a06d9a54700f1191b6e561
> Gitweb:     http://git.kernel.org/tip/125580380f418000b1a06d9a54700f1191b6e561
> Author:     Cyrill Gorcunov <gorcunov@openvz.org>
> AuthorDate: Thu, 10 Dec 2009 19:56:34 +0300
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 10 Dec 2009 18:00:30 +0100
> 
> x86, perf events: Check if we have APIC enabled
> 
> Ralf Hildebrandt reported this boot warning:
> 
> | Running a vanilla 2.6.32 as Xen DomU, I'm getting:
> |
> | [    0.000999] CPU: Physical Processor ID: 0
> | [    0.000999] CPU: Processor Core ID: 1
> | [    0.000999] Performance Events: AMD PMU driver.
> | [    0.000999] ------------[ cut here ]------------
> | [    0.000999] WARNING: at arch/x86/kernel/apic/apic.c:249 native_apic_write_dummy
> 
> So we need to check if APIC functionality is available, and
> not just in the P6 driver but elsewhere as well.
> 
> Reported-by: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> LKML-Reference: <20091210165634.GF5086@lenovo>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/cpu/perf_event.c |   18 ++++++++++++------
>  1 files changed, 12 insertions(+), 6 deletions(-)
>
...

Btw, is there some particular reason to have x86_pmu::apic item?
Can't we use cpu_has_apic directly? Or there some plans about
this item? Or I miss something obvious?
 
	-- Cyrill
