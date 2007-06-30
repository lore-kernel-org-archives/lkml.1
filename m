Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbXF3JTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbXF3JTY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 05:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbXF3JTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 05:19:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44539 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751679AbXF3JTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 05:19:15 -0400
Date: Sat, 30 Jun 2007 02:18:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux@horizon.com, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, ak@suse.de, bk@suse.de,
       michal.k.k.piotrowski@gmail.com
Subject: Re: 2.6.22-rcX Transmeta/APM regression
Message-Id: <20070630021847.ec7ae2b6.akpm@linux-foundation.org>
In-Reply-To: <4685D6CC.9070007@zytor.com>
References: <20070630030343.31711.qmail@science.horizon.com>
	<4685D6CC.9070007@zytor.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jun 2007 00:06:36 -0400 "H. Peter Anvin" <hpa@zytor.com> wrote:

> linux@horizon.com wrote:
> > 
> > Anyway, the patch which introduces the problem is the aptly named 3ebad:
> > 3ebad59056: [PATCH] x86: Save and restore the fixed-range MTRRs of the BSP when suspending
> > 
> > 2.6.22-rc6 plus that one commit reverted successfully does APM suspend
> > (and resume) for me.
> 
> Okay, I would guess that that patch probably touches MTRRs without 
> actually verify that the CPU *has* MTRRs -- the Transmeta Crusoe CPU 
> doesn't have MTRRs.
> 

This?

--- a/arch/i386/kernel/cpu/mtrr/generic.c~i386-mtrr-crash-fix
+++ a/arch/i386/kernel/cpu/mtrr/generic.c
@@ -65,7 +65,8 @@ get_fixed_ranges(mtrr_type * frs)
 
 void mtrr_save_fixed_ranges(void *info)
 {
-	get_fixed_ranges(mtrr_state.fixed_ranges);
+	if (cpu_has_mtrr)
+		get_fixed_ranges(mtrr_state.fixed_ranges);
 }
 
 static void print_fixed(unsigned base, unsigned step, const mtrr_type*types)
_

