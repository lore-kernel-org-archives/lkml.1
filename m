Return-Path: <linux-kernel-owner+w=401wt.eu-S1760953AbZLJQNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953AbZLJQNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 11:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbZLJQNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 11:13:32 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:64466 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbZLJQNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 11:13:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IOPZaMfpSM7l/Q3mqJp+UolYduCYwsxxNBb0B6JSw0yWYjGDLMRnfB8taih6xaQaZB
         V2v18WSQODaTCQrOW/84LUrvWd/K8/TuWX888JmpGQ13zkZl0PPzKvdnieFLABC4mOY9
         Pmq4FsTWJPfVK2WfKeWv5EoFwrIN4tLGyycPQ=
Date: Thu, 10 Dec 2009 19:13:35 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.32] WARNING: at arch/x86/kernel/apic/apic.c:249
	native_apic_write_dummy+0x30/0x3c()
Message-ID: <20091210161335.GC5086@lenovo>
References: <20091210154837.GT30903@charite.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210154837.GT30903@charite.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 04:48:37PM +0100, Ralf Hildebrandt wrote:
> Running a vanilla 2.6.32 as Xen DomU, I'm getting:
> 
> [    0.000999] CPU: Physical Processor ID: 0
> [    0.000999] CPU: Processor Core ID: 1
> [    0.000999] Performance Events: AMD PMU driver.
> [    0.000999] ------------[ cut here ]------------
> [    0.000999] WARNING: at arch/x86/kernel/apic/apic.c:249 native_apic_write_dummy+0x30/0x3c()
> [    0.000999] Modules linked in:
> [    0.000999] Pid: 0, comm: swapper Not tainted 2.6.32 #3
> [    0.000999] Call Trace:
> [    0.000999]  [<ffffffff8102611a>] ? native_apic_write_dummy+0x30/0x3c
> [    0.000999]  [<ffffffff8104c5a2>] warn_slowpath_common+0x77/0x8f
> [    0.000999]  [<ffffffff8104c5c9>] warn_slowpath_null+0xf/0x11
> [    0.000999]  [<ffffffff8102611a>] native_apic_write_dummy+0x30/0x3c
> [    0.000999]  [<ffffffff8101bf49>] perf_events_lapic_init+0x2e/0x30
> [    0.000999]  [<ffffffff818cc6fe>] init_hw_perf_events+0x300/0x39d
> [    0.000999]  [<ffffffff818cc25a>] identify_boot_cpu+0x3c/0x3e
> [    0.000999]  [<ffffffff818cc3da>] check_bugs+0x9/0x2d
> [    0.000999]  [<ffffffff818c4cae>] start_kernel+0x37a/0x38f
> [    0.000999]  [<ffffffff818c42c1>] x86_64_start_reservations+0xac/0xb0
> [    0.000999]  [<ffffffff818c7b79>] xen_start_kernel+0x530/0x534
> [    0.000999] ---[ end trace 4eaa2a86a8e2da22 ]---
> [    0.000999] ... version:                0
> [    0.000999] ... bit width:              48
> [    0.000999] ... generic registers:      4
> [    0.000999] ... value mask:             0000ffffffffffff
> [    0.000999] ... max period:             00007fffffffffff
> [    0.000999] ... fixed-purpose events:   0
> [    0.000999] ... event mask:             000000000000000f
> [    0.000999] SMP alternatives: switching to UP code
> 

It seems amd_pmu_init() do not check if apic is enabled :(
Thanks for report!

	-- Cyrill
