Return-Path: <linux-kernel-owner+w=401wt.eu-S1763468AbYBHD0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763468AbYBHD0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 22:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760768AbYBHDZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 22:25:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758147AbYBHDZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 22:25:56 -0500
Date: Fri, 8 Feb 2008 03:24:23 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Brian Wood <brian.j.wood@intel.com>, Daniel Walker <dwalker@mvista.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Jonathan Brassow <jbrassow@redhat.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Milan Broz <mbroz@redhat.com>, Paul Jimenez <pj@place.org>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>, Vasily Averin <vvs@sw.ru>,
       dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [git pull] device-mapper update for 2.6.25
Message-ID: <20080208032423.GX8075@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Brian Wood <brian.j.wood@intel.com>,
	Daniel Walker <dwalker@mvista.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jonathan Brassow <jbrassow@redhat.com>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>,
	Milan Broz <mbroz@redhat.com>, Paul Jimenez <pj@place.org>,
	"Robert P. J. Day" <rpjday@crashcourse.ca>,
	Vasily Averin <vvs@sw.ru>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org
References: <20080208024532.GC24157@agk.fab.redhat.com> <20080207190447.b4dcfe0c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207190447.b4dcfe0c.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 07:04:47PM -0800, Andrew Morton wrote:
> On Fri, 8 Feb 2008 02:45:32 +0000 Alasdair G Kergon <agk@redhat.com> wrote:
> 
> >       dm: move deferred bio flushing to workqueue
> 
> To my unpracticed eye this one looks fairly fundamental.  Unfortunately the
> changelog:
> 
>   Add a single-thread workqueue for each mapped device and move flushing
>   of the lists of pushback and deferred bios to this new workqueue.
> 
> tells us nothing of the reasons for this change.  (It should have done so!)
> 
> It _looks_ pretty unscalable.  Perhaps these deferred BIOs don't happen
> very often?
 
Indeed - it's a rare occurrence - happens when the dm device is
suspended/resumed which usually means it was being reconfigured by something in
userspace.

It's the first patch of a series that will provide barrier support (slated for
2.6.26).

The appearance of all these workqueues in dm goes back to this old change:
  md-dm-reduce-stack-usage-with-stacked-block-devices.patch

Alasdair
-- 
agk@redhat.com
