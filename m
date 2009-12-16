Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbZLPKQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbZLPKQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 05:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbZLPKQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 05:16:23 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40593 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358AbZLPKQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 05:16:22 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Dec 2009 19:13:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>, minchan.kim@gmail.com
Subject: Re: [mm][RFC][PATCH 0/11] mm accessor updates.
Message-Id: <20091216191312.f4655dac.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091216101107.GA15031@basil.fritz.box>
References: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com>
	<20091216101107.GA15031@basil.fritz.box>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Dec 2009 11:11:07 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> On Wed, Dec 16, 2009 at 12:00:11PM +0900, KAMEZAWA Hiroyuki wrote:
> > This is from Christoph Lameter's mm_accessor patch posted 5/Nov.
> > 
> > Replacing all access to mm->mmap_sem with mm-accessor functions as
> >  mm_read_lock,
> >  mm_write_lock,
> >  etc...
> > 
> > This kind of function allows us to improve page fault performance etc..
> > For example, skil down_read(mmap_sem) in some situation.
> > (as: http://marc.info/?l=linux-mm&m=125809791306459&w=2)
> 
> The problem is that it also slows down the writers, and we have
> some workloads where writing is the bottleneck.
> 
> I don't think this is the right trade off at this time.
> 
Maybe you don't see my patch. (above URL) no slow down to write side.
My one doesn't use percpu counter.

> Also the patches didn't fare too well in testing unfortunately.
> 
> I suspect we'll rather need multiple locks split per address
> space range.

This set doesn't include any changes of the logic. Just replace all mmap_sem.
I think this is good start point (for introducing another logic etc..)


Thanks,
-Kame

