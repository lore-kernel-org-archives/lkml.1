Return-Path: <linux-kernel-owner+w=401wt.eu-S1762290AbXEPPjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762290AbXEPPjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 11:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760905AbXEPPjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 11:39:42 -0400
Received: from ozlabs.org ([203.10.76.45]:53197 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756659AbXEPPjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 11:39:41 -0400
Date: Wed, 16 May 2007 10:37:03 -0500
From: Anton Blanchard <anton@samba.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, sfr@canb.auug.org.au, ak@suse.de
Subject: Re: select(0, ..) is valid ?
Message-ID: <20070516153703.GA26912@kryten>
References: <1179250159.2836.117.camel@dyn9047017100.beaverton.ibm.com> <20070515104453.f901e91f.akpm@linux-foundation.org> <Pine.LNX.4.64.0705151109021.31972@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0705151927360.28895@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705151927360.28895@blonde.wat.veritas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Hugh,

> It's interesting that compat_core_sys_select() shows this kmalloc(0)
> failure but core_sys_select() does not.  That's because core_sys_select()
> avoids kmalloc by using a buffer on the stack for small allocations (and
> 0 sure is small).  Shouldn't compat_core_sys_select() do just the same?
> Or is SLUB going to be so efficient that doing so is a waste of time?

Nice catch, the original optimisation from Andi is:

http://git.kernel.org/git-new/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=70674f95c0a2ea694d5c39f4e514f538a09be36f

And I think it makes sense for the compat code to do it too.

Anton
