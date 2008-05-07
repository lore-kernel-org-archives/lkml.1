Return-Path: <linux-kernel-owner+w=401wt.eu-S1758937AbYEGEXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937AbYEGEXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 00:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYEGEXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 00:23:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805AbYEGEXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 00:23:33 -0400
Date: Tue, 6 May 2008 21:23:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: David Miller <davem@davemloft.net>, tony@bakeyournoodle.com,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] Silence 'ignoring return value' warnings in
 drivers/video/aty/radeon_base.c
Message-Id: <20080506212314.695daf98.akpm@linux-foundation.org>
In-Reply-To: <20080506211552.6af7cecc@infradead.org>
References: <20080424043400.GS20457@bakeyournoodle.com>
	<20080506143936.6357e578.akpm@linux-foundation.org>
	<20080506.144301.233784820.davem@davemloft.net>
	<20080506145608.565b61bf.akpm@linux-foundation.org>
	<20080506210055.75e2f881@infradead.org>
	<20080506211233.f050fd41.akpm@linux-foundation.org>
	<20080506211552.6af7cecc@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 21:15:52 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> On Tue, 6 May 2008 21:12:33 -0700
> 
> > > can we make it a WARN_ON() as well? that way we'll see it in various
> > > kerneloops.org stats etc etc.. and we also get a nice backtrace for
> > > free to go with it....
> > > 
> > > (rationale: users tend to not read their dmesg much, but
> > > WARN_ON()'s do get noticed)
> > 
> > OK by me, although if we're going to do much more of this it might be
> > time to add a WARN_ON which takes (fmt, args...).
> 
> totally; I was just talking to some others about doing just this.

The challenge will be to minimise the code footprint.

otcompletelyoh, perhaps we could generate a backtrace from within printk()
itself for when it sees messages which have KERN_ERR or some other
suitably-chosen (and probably configurable) facility level.

That'll generate false positives and will reveal dubious choices, but we
can fix those up.

> > 
> > Which should be called WARN, but of course 12,000,000 drivers have
> > gone and screwed that up with indiscriminate namespace poaching.
> 
> how about this deal: I implement it, you pick the name ? :=)

AKPM()!
