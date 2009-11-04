Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbZKDJBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbZKDJBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 04:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbZKDJBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 04:01:44 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54998 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZKDJBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 04:01:43 -0500
Date: Wed, 4 Nov 2009 10:01:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       stable@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 2/3] page allocator: Do not allow interrupts to use
 ALLOC_HARDER
Message-ID: <20091104090140.GA14694@elf.ucw.cz>
References: <20091027130924.fa903f5a.akpm@linux-foundation.org>
 <alpine.DEB.2.00.0910271411530.9183@chino.kir.corp.google.com>
 <20091031184054.GB1475@ucw.cz>
 <alpine.DEB.2.00.0910311248490.13829@chino.kir.corp.google.com>
 <20091031201158.GB29536@elf.ucw.cz>
 <4AECCF6A.4020206@redhat.com>
 <alpine.DEB.1.10.0911021139100.24535@V090114053VZO-1>
 <alpine.DEB.2.00.0911021249470.22525@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0911031208150.21943@V090114053VZO-1>
 <alpine.DEB.2.00.0911031739380.1187@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0911031739380.1187@chino.kir.corp.google.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I hope we can move this to another thread if people would like to remove 
> this exemption completely instead of talking about this trivial fix, which 
> I doubt there's any objection to.

I'm arguing that this "trivial fix" is wrong, and that you should just
remove those two lines.

If going into reserves from interrupts hurts, doing that from task
context will hurt, too. "realtime" task should not be normally allowed
to "hurt" the system like that.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
