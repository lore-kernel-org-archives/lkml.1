Return-Path: <linux-kernel-owner+w=401wt.eu-S933212AbZJaUMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbZJaUMH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 16:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933202AbZJaUMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 16:12:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36451 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933198AbZJaUME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 16:12:04 -0400
Date: Sat, 31 Oct 2009 21:11:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       stable@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 2/3] page allocator: Do not allow interrupts to use
 ALLOC_HARDER
Message-ID: <20091031201158.GB29536@elf.ucw.cz>
References: <1256650833-15516-1-git-send-email-mel@csn.ul.ie>
 <1256650833-15516-3-git-send-email-mel@csn.ul.ie>
 <20091027130924.fa903f5a.akpm@linux-foundation.org>
 <alpine.DEB.2.00.0910271411530.9183@chino.kir.corp.google.com>
 <20091031184054.GB1475@ucw.cz>
 <alpine.DEB.2.00.0910311248490.13829@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910311248490.13829@chino.kir.corp.google.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-10-31 12:51:14, David Rientjes wrote:
> On Sat, 31 Oct 2009, Pavel Machek wrote:
> 
> > > Giving rt tasks access to memory reserves is necessary to reduce latency, 
> > > the privilege does not apply to interrupts that subsequently get run on 
> > > the same cpu.
> > 
> > If rt task needs to allocate memory like that, then its broken,
> > anyway...
> 
> Um, no, it's a matter of the kernel implementation.  We allow such tasks 
> to allocate deeper into reserves to avoid the page allocator from 
> incurring a significant penalty when direct reclaim is required.  
> Background reclaim has already commenced at this point in the
>slowpath.

But we can't guarantee that enough memory will be ready in the
reserves. So if realtime task relies on it, it is broken, and will
fail to meet its deadlines from time to time.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
