Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbZFYOye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbZFYOye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZFYOy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:54:26 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:43588 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbZFYOyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:54:25 -0400
Subject: Re: [PATCH] prevent to reclaim anon page of lumpy reclaim for no
	swap  space
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <28c262360906250744h5bf9f0a0w265d8c35e7d69335@mail.gmail.com>
References: <20090625183616.23b55b24.minchan.kim@barrios-desktop>
	 <2f11576a0906250714o5d77db11wd32c1c7139753cb5@mail.gmail.com>
	 <28c262360906250744h5bf9f0a0w265d8c35e7d69335@mail.gmail.com>
Content-Type: text/plain
Organization: HP/LKTT
Date: Thu, 25 Jun 2009 10:54:25 -0400
Message-Id: <1245941665.6459.18.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 23:44 +0900, Minchan Kim wrote:
> On Thu, Jun 25, 2009 at 11:14 PM, KOSAKI
> Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
> >> This patch prevent to reclaim anon page in case of no swap space.
> >> VM already prevent to reclaim anon page in various place.
> >> But it doesnt't prevent it for lumpy reclaim.
> >>
> >> It shuffles lru list unnecessary so that it is pointless.
> >
> > NAK.
> >
> > 1. if system have no swap, add_to_swap() never get swap entry.
> >   eary check don't improve performance so much.
> 
> Hmm. I mean no swap space but not no swap device.
> add_to_swap ? You mean Rik pointed me out ?
> If system have swap device, Rik's pointing is right.
> I will update his suggestion.
> 
> > 2. __isolate_lru_page() is not only called lumpy reclaim case, but
> > also be called
> >    normal reclaim.
> 
> You mean about performance degradation ?
> I think most case have enough swap space and then one condition
> variable(nr_swap_page) check is trivial. I think.
> We can also use [un]likely but I am not sure it help us.
> 
> 
> > 3. if system have no swap, anon pages shuffuling doesn't cause any matter.
> 
> Again, I mean no swap space but no swap device system.
> And I have a plan to remove anon_vma in no swap device system.
> 
> As you point me out, it's pointless in no swap device system.
> I don't like unnecessary structure memory footprint and locking overhead.
> I think no swap device system is problem in server environment as well
> as embedded. but I am not sure when I will do. :)
> 

How will we walk the reverse map for try_to_unmap() for page migration
or try_to_munlock() w/o anon_vma?  Perhaps one can remove anon_vma when
there is no swap device and migration and the unevictable lru are not
configured--e.g., for embedded systems.

Lee

