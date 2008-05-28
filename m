Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbYE1BIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbYE1BIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 21:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYE1BHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 21:07:55 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51053 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbYE1BHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 21:07:54 -0400
Date: Wed, 28 May 2008 10:12:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm 00/16] VM pageout scalability improvements (V8)
Message-Id: <20080528101229.f14e0f09.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1211903642.7283.16.camel@lts-notebook>
References: <20080523195506.084894989@redhat.com>
	<483B0077.7000207@linux.vnet.ibm.com>
	<20080526153318.29edc0b2@bree.surriel.com>
	<1211903642.7283.16.camel@lts-notebook>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 11:54:02 -0400
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> Since Balbir is starting to look at this, I need to ask about
> interaction with the memory controller.  It is currently unaware of the
> noreclaim list.  I'm not sure what will happen if/when the memory
> controller tries to reclaim a page that system has moved to the
> noreclaim list.  Something we'll need to address.  It's on my list, but
> I won't get to it for a couple of weeks.
> 
In my understanding, 2 checks we have to do.

1. When memcg finds PG_noreclaim page in its LRU, move it to noreclaim list of
   memcg.
2. When PG_noreclaim page is moved back to generic LRU, memcg should move
   it on its list. (we have to add a hook somewhere.)

But this may break current 'loose' synchronization between global LRU and
memcg's LRU. When PG_noreclaim page is put back into active/inactive LRU ?

concerns are
A. how to implement '2'
B. race condtions.

But maybe we don't have to write a big patch.

Thanks,
-Kame

