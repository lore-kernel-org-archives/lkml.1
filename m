Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbYEGENF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbYEGENF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 00:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbYEGEMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 00:12:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980AbYEGEMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 00:12:53 -0400
Date: Tue, 6 May 2008 21:12:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: David Miller <davem@davemloft.net>, tony@bakeyournoodle.com,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] Silence 'ignoring return value' warnings in
 drivers/video/aty/radeon_base.c
Message-Id: <20080506211233.f050fd41.akpm@linux-foundation.org>
In-Reply-To: <20080506210055.75e2f881@infradead.org>
References: <20080424043400.GS20457@bakeyournoodle.com>
	<20080506143936.6357e578.akpm@linux-foundation.org>
	<20080506.144301.233784820.davem@davemloft.net>
	<20080506145608.565b61bf.akpm@linux-foundation.org>
	<20080506210055.75e2f881@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 21:00:55 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> ...
>
> > +	if (err)
> > +		pr_warning("%s() Creating sysfs files failed,
> > continuing\n",
> > +		           __func__);
> >  
> >  	/* save current mode regs before we switch into the new one
> >  	 * so we can restore this upon __exit
> > _
> > 
> > 
> > So from what you say, it sounds like we will be seeing that warning.
> > I wonder why.
> 
> can we make it a WARN_ON() as well? that way we'll see it in various
> kerneloops.org stats etc etc.. and we also get a nice backtrace for
> free to go with it....
> 
> (rationale: users tend to not read their dmesg much, but WARN_ON()'s do
> get noticed)

OK by me, although if we're going to do much more of this it might be time
to add a WARN_ON which takes (fmt, args...).

Which should be called WARN, but of course 12,000,000 drivers have gone and
screwed that up with indiscriminate namespace poaching.


