Return-Path: <linux-kernel-owner+w=401wt.eu-S1030310AbXDKTxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030310AbXDKTxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030314AbXDKTxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:53:19 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:59085 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030310AbXDKTxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:53:18 -0400
Date: Wed, 11 Apr 2007 12:52:56 -0700
From: Zach Brown <zach.brown@oracle.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Ken Chen <kenchen@google.com>, akpm@linux-foundation.org,
       linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] convert aio event reap to use atomic-op instead of spin_lock
Message-ID: <20070411195256.GD9602@mami.zabbo.net>
References: <20070410235353.325A7346F64@localhost> <20070411180038.GN28322@mami.zabbo.net> <b040c32a0704111228t5065253en9249ff88db5b1384@mail.gmail.com> <20070411194504.GM13621@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070411194504.GM13621@kvack.org>
User-Agent: Mutt/1.4.2.1i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I kept on getting requests from application developers who want that
> > feature.  My initial patch was dated back May 2004.
> 
> The right way to do it involves synchronization between the kernel side 
> io_getevents() and the userspace code pulling events out of the ring.  
> Alan Cox suggested embedding a futex in the shared memory region, but I 
> don't think anyone ever implemented that.

Yeah, I like the idea of futexes.

I'm worried that virtual aliasing spells doom for the current
home-brewed serialization that fs/aio.c is doing with the shared ring
head/tail accesses.  Am I worrying about nothing here?

> > I will look into this aside from this patch.
> 
> That's probably the case.  Also, any changes in this area *must* correctly 
> update the compat/incompat feature flags in the ring buffer header.  That 
> has been missed in the past...

Do you know of anyone using the current ring info ABI?

The *only* user I know of is the check of ctx->magic in libaio.

- z
