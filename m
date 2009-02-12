Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbZBLACT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbZBLACT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 19:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbZBLACF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 19:02:05 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56461 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbZBLACE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 19:02:04 -0500
Date: Thu, 12 Feb 2009 09:00:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       MinChan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, riel@redhat.com
Subject: Re: [PATCH] mm: remove zone->prev_prioriy
Message-Id: <20090212090043.b07d6540.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090211201706.C3C0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20090211195252.C3BD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20090211031201.cace1c68.akpm@linux-foundation.org>
	<20090211201706.C3C0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Feb 2009 20:23:39 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > On Wed, 11 Feb 2009 20:06:46 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> > > > On Tue, 10 Feb 2009 19:57:01 +0900
> > > > MinChan Kim <minchan.kim@gmail.com> wrote:
> > > > 
> > > > > As you know, prev_priority is used as a measure of how much stress page reclaim.
> > > > > But now we doesn't need it due to split-lru's way.
> > > > > 
> > > > > I think it would be better to remain why prev_priority isn't needed any more
> > > > > and how split-lru can replace prev_priority's role in changelog.
> > > > > 
> > > > > In future, it help mm newbies understand change history, I think.
> > > > 
> > > > Yes, I'd be fascinated to see that explanation.
> > > > 
> > > > In http://groups.google.pn/group/linux.kernel/browse_thread/thread/fea9c9a0b43162a1
> > > > it was asserted that we intend to use prev_priority again in the future.
> > > > 
> > > > We discussed this back in November:
> > > > http://lkml.indiana.edu/hypermail/linux/kernel/0811.2/index.html#00001
> > > > 
> > > > And I think that I still think that the VM got worse due to its (new)
> > > > failure to track previous state.  IIRC, the response to that concern
> > > > was quite similar to handwavy waffling.
> > > 
> > > Yes.
> > > I still think it's valuable code.
> > > I think, In theory, VM sould take parallel reclaim bonus.
> > 
> > prev_priority had nothing to do with concurrent reclaim?
> > 
> > It was there so that when a task enters direct reclaim against a zone,
> > it will immediately adopt the state which the task which most recently
> > ran direct reclaim had.
> > 
> > Without this feature, each time a task enters direct reclaim it will need
> > to "relearn" that state - ramping up, making probably-incorrect
> > decisions as it does so.
> 
> Yes, I perfectly agree to you.
> theorically, prev_priority is very valuable stuff.
> 

Ok, please implement the lost logic again.

-Kame

