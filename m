Return-Path: <linux-kernel-owner+w=401wt.eu-S1763069AbYCDBar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763069AbYCDBar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 20:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755651AbYCDBai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 20:30:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755550AbYCDBah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 20:30:37 -0500
Date: Mon, 3 Mar 2008 17:30:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: travis@sgi.com, mingo@elte.hu, tglx@linutronix.de, ak@suse.de,
       clameter@sgi.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2/2] x86_64: Cleanup non-smp usage of cpu maps v3
Message-Id: <20080303173011.b0d9a89d.akpm@linux-foundation.org>
In-Reply-To: <20080303170235.4334e841.akpm@linux-foundation.org>
References: <20080219203335.866324000@polaris-admin.engr.sgi.com>
	<20080219203336.177905000@polaris-admin.engr.sgi.com>
	<20080303170235.4334e841.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008 17:02:35 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> I was unable to bisect it more finely than this:
> 
> init-move-setup-of-nr_cpu_ids-to-as-early-as-possible-v3.patch
> generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3.patch OK
> x86_64-fold-pda-into-per-cpu-area-v3.patch
> x86_64-fold-pda-into-per-cpu-area-v3-fix.patch				
> x86_64-cleanup-non-smp-usage-of-cpu-maps-v3.patch			BAD
> 
> because when x86_64-cleanup-non-smp-usage-of-cpu-maps-v3.patch was removed
> the machine hung quite early, when playing around with TSC calibration I
> think.

This just happened again with the patches dropped, so it is a separate bug -
just another regression.


I now recall that it has been happening on every fifth-odd boot for a few
weeks now.  The machine prints

Time: tsc clocksource has been installed

then five instances of "system 00:01: iomem range 0x...", then it hangs. 
ie: it never prints "system 00:01: iomem range 0xfe600000-0xfe6fffff has
been reserved" from http://userweb.kernel.org/~akpm/dmesg-akpm2.txt.

It may have some correlation with whether the machine was booted via
poweron versus `reboot -f', dunno.

