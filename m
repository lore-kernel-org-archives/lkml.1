Return-Path: <linux-kernel-owner+w=401wt.eu-S1758839AbXEJURv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbXEJURv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757350AbXEJURo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:17:44 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755635AbXEJURn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:17:43 -0400
Date: Thu, 10 May 2007 13:17:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org
Subject: Re: slub-i386-support.patch
Message-Id: <20070510131724.150e1e99.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 21:03:39 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> Just want to report that I've been running SLUB on i386, both in -mm
> and with slub-i386-support.patch applied to 2.6.21-git, and observed
> no problems with it.  I'm anxious that it (or an equivalent) go into
> 2.6.22-rc1, i386 being now the last ARCH_USES_SLAB_PAGE_STRUCT holdout.
> 
> In the frenzy over PowerPC, maybe Linus overlooked that i386
> was still not supporting SLUB; and I fear that once people get
> "# CONFIG_SLUB is not set" into their .config, they're less likely to
> switch over to testing CONFIG_SLUB=y - I remain anxious that it see
> as much testing as possible (but under EXPERIMENTAL for 2.6.22, yes).

ok..

> Though when I look at the patchset (copied below), I do wonder why
> it puts a quicklist_trim() into i386's cpu_idle() and flush_tlb_mm():
> neither is where I'd expect us to be secretly freeing pages.  Ah,
> several arches do it in cpu_idle(): how odd, oh well.

Christoph, could you please check that this is justified?
