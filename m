Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbYB0VA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbYB0VA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYB0VAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:00:21 -0500
Received: from www.tglx.de ([62.245.132.106]:38710 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbYB0VAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:00:21 -0500
Date: Wed, 27 Feb 2008 21:59:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       Thomas Mingarelli <thomas.mingarelli@hp.com>
Subject: Re: hpwdt oops in clflush_cache_range
In-Reply-To: <alpine.LFD.1.00.0802272140050.7583@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.00.0802272155190.7583@apollo.tec.linutronix.de>
References: <adad4qiwcmz.fsf@cisco.com> <alpine.LFD.1.00.0802271913050.7583@apollo.tec.linutronix.de> <ada1w6y1bzk.fsf@cisco.com> <alpine.LFD.1.00.0802272011130.7583@apollo.tec.linutronix.de> <20080227203655.GA30054@elte.hu>
 <alpine.LFD.1.00.0802272140050.7583@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Thomas Gleixner wrote:
> +static inline int phys_addr_valid(unsigned long addr)
> +{
> +	return addr < (1 << boot_cpu_data.x86_phys_bits);

That needs to be:

+     return addr < (1UL << boot_cpu_data.x86_phys_bits);

Where is my brown paperbag ? I know that GCC _is_ stupid, but I never
remember.

      tglx

