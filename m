Return-Path: <linux-kernel-owner+w=401wt.eu-S1751522AbZKAHfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbZKAHfg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 02:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZKAHfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 02:35:33 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59138 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbZKAHfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 02:35:33 -0500
Date: Sun, 1 Nov 2009 08:35:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       stable@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 2/3] page allocator: Do not allow interrupts to use
 ALLOC_HARDER
Message-ID: <20091101073527.GB32720@elf.ucw.cz>
References: <1256650833-15516-1-git-send-email-mel@csn.ul.ie>
 <1256650833-15516-3-git-send-email-mel@csn.ul.ie>
 <20091027130924.fa903f5a.akpm@linux-foundation.org>
 <alpine.DEB.2.00.0910271411530.9183@chino.kir.corp.google.com>
 <20091031184054.GB1475@ucw.cz>
 <alpine.DEB.2.00.0910311248490.13829@chino.kir.corp.google.com>
 <20091031201158.GB29536@elf.ucw.cz>
 <alpine.DEB.2.00.0910311413160.25524@chino.kir.corp.google.com>
 <20091031222905.GA32720@elf.ucw.cz>
 <4AECC04B.9060808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AECC04B.9060808@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I believe it would be better to simply remove it.
> 
> You are against trying to give the realtime tasks a best effort
> advantage at memory allocation?

Yes. Those memory reserves were for kernel, GPF_ATOMIC and stuff. Now
realtime tasks are allowed to eat into them. That feels wrong.

"realtime" tasks are not automatically "more important".

> Realtime apps often *have* to allocate memory on the kernel side,
> because they use network system calls, etc...

So what? As soon as they do that, they lose any guarantees, anyway.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
