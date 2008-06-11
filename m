Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYFKUtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYFKUtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbYFKUtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:49:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbYFKUtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:49:39 -0400
Date: Wed, 11 Jun 2008 16:48:55 -0400
From: Rik van Riel <riel@redhat.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH -mm 11/24] pageflag helpers for configed-out flags
Message-ID: <20080611164855.6d0a3f76@bree.surriel.com>
In-Reply-To: <1213216981.6436.74.camel@lts-notebook>
References: <20080611184214.605110868@redhat.com>
	<20080611184339.493423475@redhat.com>
	<20080611130145.2a202339.akpm@linux-foundation.org>
	<1213216083.6436.66.camel@lts-notebook>
	<20080611163230.30bd9f84@bree.surriel.com>
	<1213216981.6436.74.camel@lts-notebook>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008 16:43:01 -0400
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> On Wed, 2008-06-11 at 16:32 -0400, Rik van Riel wrote:
> > On Wed, 11 Jun 2008 16:28:03 -0400
> > Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> > > On Wed, 2008-06-11 at 13:01 -0700, Andrew Morton wrote:
> > > > On Wed, 11 Jun 2008 14:42:25 -0400
> > > > Rik van Riel <riel@redhat.com> wrote:
> > > > 
> > > > > Define proper false/noop inline functions for noreclaim page
> > > > > flags when !defined(CONFIG_NORECLAIM_LRU)
> > > > 
> > > > I changed that to CONFIG_UNEVICTABLE_LRU.
> > > 
> > > I noticed that the vmstat items [perhaps these will go away] still use
> > > "noreclaim".
> > 
> > $ cat /proc/vmstat
> > nr_free_pages 3887198
> > nr_inactive_anon 5043
> > nr_active_anon 2182
> > nr_inactive_file 67121
> > nr_active_file 49045
> > nr_unevictable 0
> > nr_mlock 0
> > 
> > Or am I looking at the wrong thing?
> 
> Do you have patch 21/24 applied?  In 26-rc5-mm1, I see the
> noreclaim_pgs_* vmstat items.  They're in the patch 21 you just posted,
> as well.

Doh!

I am working against:

http://userweb.kernel.org/~akpm/mmotm/

You may want to send Andrew an update against patch 21/24 that
changes those names from noreclaim_pgs_* to unevictable_pgs_*.

> Again, we might decide to drop that patch from the merge.  I found the
> stats useful during debug and test, but I don't know that they provide
> any value in the longer term.

That's an option too.  I'll let you and Kosaki-san decide on
that, since I had relatively little involvement with the
second half of the patch series recently.

-- 
All rights reversed.
