Return-Path: <linux-kernel-owner+w=401wt.eu-S1762655AbZLKVWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762655AbZLKVWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 16:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759184AbZLKVWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 16:22:47 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52724 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758850AbZLKVWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 16:22:47 -0500
Date: Fri, 11 Dec 2009 21:22:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Jamie Iles <jamie.iles@picochip.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] perf tools: allow building for ARM
Message-ID: <20091211212222.GD12628@n2100.arm.linux.org.uk>
References: <1260523260-15694-1-git-send-email-jamie.iles@picochip.com> <20091211102316.GB16882@elte.hu> <20091211103030.GC4164@wear.picochip.com> <20091211103848.GA9947@elte.hu> <20091211110111.GD4164@wear.picochip.com> <19234.11393.632298.555005@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19234.11393.632298.555005@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 12:26:57PM +0100, Mikael Pettersson wrote:
> The correct solution is to invoke a kernel-exported CPU-specific helper
> function in the ARM kernel helper page.
> 
> I see a __kuser_memory_barrier entry there which maps to smp_dmb.

That is indeed the correct way to do this - otherwise user programs will
be tied to particular architecture versions, and either an undefined
instruction fault will happen, or worse, the desired effect will not
happen.
