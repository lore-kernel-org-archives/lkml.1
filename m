Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbZG2PEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbZG2PEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 11:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbZG2PEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 11:04:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53997 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbZG2PEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 11:04:52 -0400
Date: Wed, 29 Jul 2009 17:04:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH -mm] throttle direct reclaim when too many pages are
	isolated already (v3)
Message-ID: <20090729150443.GB1534@ucw.cz>
References: <20090715223854.7548740a@bree.surriel.com> <20090715194820.237a4d77.akpm@linux-foundation.org> <4A5E9A33.3030704@redhat.com> <20090715202114.789d36f7.akpm@linux-foundation.org> <4A5E9E4E.5000308@redhat.com> <20090715203854.336de2d5.akpm@linux-foundation.org> <20090715235318.6d2f5247@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090715235318.6d2f5247@bree.surriel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-07-15 23:53:18, Rik van Riel wrote:
> When way too many processes go into direct reclaim, it is possible
> for all of the pages to be taken off the LRU.  One result of this
> is that the next process in the page reclaim code thinks there are
> no reclaimable pages left and triggers an out of memory kill.
> 
> One solution to this problem is to never let so many processes into
> the page reclaim path that the entire LRU is emptied.  Limiting the
> system to only having half of each inactive list isolated for
> reclaim should be safe.

Is this still racy? Like on 100cpu machine, with LRU size of 50...?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
