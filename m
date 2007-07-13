Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbXGMKDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbXGMKDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 06:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbXGMKDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 06:03:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60524 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbXGMKDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 06:03:33 -0400
Date: Fri, 13 Jul 2007 11:03:29 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>
Subject: Re: [patch] x86_64: Avoid too many remote cpu references due to /proc/stat
Message-ID: <20070713100329.GE16304@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ravikiran G Thirumalai <kiran@scalex86.org>,
	Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	"Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>
References: <20070713000615.GA11942@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713000615.GA11942@localdomain>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 05:06:16PM -0700, Ravikiran G Thirumalai wrote:
> Too many remote cpu references due to /proc/stat.
> 
> On x86_64, with newer kernel versions, kstat_irqs is a bit of a problem.
> On every call to kstat_irqs, the process brings in per-cpu data from all
> online cpus.  Doing this for NR_IRQS, which is now 256 + 32 * NR_CPUS
> results in (256+32*63) * 63 remote cpu references on a 64 cpu config.
> /proc/stat is parsed by common commands like top, who etc, causing
> lots of cacheline transfers
> 
> This statistic seems useless. Other 'big iron' arches disable this.
> Can we disable computing/reporting this statistic?  This piece of
> statistic is not human readable on x86_64 anymore,

At which point we might just remove it completely..

