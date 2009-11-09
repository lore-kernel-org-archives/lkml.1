Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbZKIKL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbZKIKL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 05:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbZKIKL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 05:11:28 -0500
Received: from gir.skynet.ie ([193.1.99.77]:36790 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202AbZKIKL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 05:11:27 -0500
Date: Mon, 9 Nov 2009 10:11:28 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Pavel Machek <pavel@ucw.cz>
Cc: David Rientjes <rientjes@google.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
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
Message-ID: <20091109101128.GB6657@csn.ul.ie>
References: <alpine.DEB.2.00.0910271411530.9183@chino.kir.corp.google.com> <20091031184054.GB1475@ucw.cz> <alpine.DEB.2.00.0910311248490.13829@chino.kir.corp.google.com> <20091031201158.GB29536@elf.ucw.cz> <4AECCF6A.4020206@redhat.com> <alpine.DEB.1.10.0911021139100.24535@V090114053VZO-1> <alpine.DEB.2.00.0911021249470.22525@chino.kir.corp.google.com> <alpine.DEB.1.10.0911031208150.21943@V090114053VZO-1> <alpine.DEB.2.00.0911031739380.1187@chino.kir.corp.google.com> <20091104090140.GA14694@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091104090140.GA14694@elf.ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 10:01:40AM +0100, Pavel Machek wrote:
> 
> > I hope we can move this to another thread if people would like to remove 
> > this exemption completely instead of talking about this trivial fix, which 
> > I doubt there's any objection to.
> 
> I'm arguing that this "trivial fix" is wrong, and that you should just
> remove those two lines.
> 
> If going into reserves from interrupts hurts, doing that from task
> context will hurt, too. "realtime" task should not be normally allowed
> to "hurt" the system like that.
> 									Pavel

As David points out, it has been the behaviour of the system for 4 years
and removing it should be made as a separate decision and not in the
guise of a fix. In the particular case causing concern, there are a lot
more allocations from interrupt due to network receive than there are
from the activities of tasks with a high priority.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
