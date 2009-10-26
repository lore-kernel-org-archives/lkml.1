Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbZJZVMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbZJZVMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbZJZVMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:12:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:36842 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbZJZVMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:12:50 -0400
X-ExtLoop1: 1
Date: Mon, 26 Oct 2009 14:12:52 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Schlichter <thomas.schlichter@web.de>,
       LKML <linux-kernel@vger.kernel.org>, Eric Anholt <eric@anholt.net>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Jan Beulich <JBeulich@novell.com>
Subject: Re: [patch] x86, pat: return EINVAL for pci mmap WC request for
 !pat_enabled
Message-ID: <20091026141252.57803f63@jbarnes-g45>
In-Reply-To: <1256336760.2576.8.camel@sbs-t61>
References: <1256336760.2576.8.camel@sbs-t61>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009 13:21:32 -0800
Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> Thomas Schlichter reported:
> > X.org uses libpciaccess which tries to mmap with write combining
> > enabled via /sys/bus/pci/devices/*/resource0_wc. Currently, when
> > PAT is not enabled, the kernel does fall back to uncached mmap.
> > Then libpciaccess thinks it succeeded mapping with write combining
> > enabled and does not set up suited MTRR entries. ;-(
> 
> Instead of silently mapping pci mmap region as UC minus in the case
> of !pat_enabled and wc request, we can return error. Eric Anholt
> mentioned that caller (like X) typically follows up with UC minus pci
> mmap request and if there is a free mtrr slot, caller will manage
> adding WC mtrr.
> 
> Jesse Barnes says:
> > Older versions of libpciaccess will behave better if we do it that
> > way (iirc it only allocates an MTRR if the resource_wc file doesn't
> > exist or fails to get mapped).
> 
> Reported-by: Thomas Schlichter <thomas.schlichter@web.de>
> Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Acked-by: Eric Anholt <eric@anholt.net>
> Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
> 

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
