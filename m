Return-Path: <linux-kernel-owner+w=401wt.eu-S932389AbZE1Bqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbZE1Bqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 21:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758276AbZE1Bq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 21:46:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44465 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760803AbZE1BqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 21:46:25 -0400
Date: Thu, 28 May 2009 10:44:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/5] add SWAP_HAS_CACHE flag to swap_map
Message-Id: <20090528104448.17c4b37c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090528104013.e410235e.nishimura@mxp.nes.nec.co.jp>
References: <20090526121259.b91b3e9d.kamezawa.hiroyu@jp.fujitsu.com>
	<20090526121547.ce866fe4.kamezawa.hiroyu@jp.fujitsu.com>
	<20090528094157.5c39ac57.nishimura@mxp.nes.nec.co.jp>
	<20090528100501.ab26953f.kamezawa.hiroyu@jp.fujitsu.com>
	<20090528104013.e410235e.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 10:40:13 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> > > So I think it should be like:
> > > 
> > > 	read_swap_cache_async()
> > > 		:
> > > 		valid = swapcache_prepare(entry);
> > > 		if (!valid)
> > > 			break;
> > > 		if (valid == -EAGAIN);
> > > 			continue;
> > > 
> > > to let the context that succeeded in swapcache_prepare() do add_to_swap_cache().
> > > 
> > 
> > What you reccomend is code like this ?
> > 
> > ==
> > 	ret = swapcache_prapare(entry);
> > 	if (ret == -ENOENT)
> > 		break;    /* unused swap entry */
> > 	if (ret == -EBUSY)
> > 		continue; /* to call find_get_page() again */
> > ==
> > 
> Yes.
> By current version of your patch, read_swap_cache_async() might return NULL
> if concurrent read_swap_cache_async() exists. It is different from current behavior.
> And this means swapin_readahead() might fail(it calls read_swap_cache_async()
> twice, though) and can cause oom, right ?
> 
Good point. I fixed this in a patch in my box ;)
Thank you fot good review.

Thanks,
-Kame



