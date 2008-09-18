Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbYIRElt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbYIRElt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 00:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbYIREll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 00:41:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36992 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbYIREll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 00:41:41 -0400
Date: Thu, 18 Sep 2008 13:43:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: balbir@linux.vnet.ibm.com, Dave Hansen <dave@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page (v3)
Message-Id: <20080918134304.93985542.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080917184008.92b7fc4c.akpm@linux-foundation.org>
References: <200809091500.10619.nickpiggin@yahoo.com.au>
	<20080909141244.721dfd39.kamezawa.hiroyu@jp.fujitsu.com>
	<30229398.1220963412858.kamezawa.hiroyu@jp.fujitsu.com>
	<20080910012048.GA32752@balbir.in.ibm.com>
	<1221085260.6781.69.camel@nimitz>
	<48C84C0A.30902@linux.vnet.ibm.com>
	<1221087408.6781.73.camel@nimitz>
	<20080911103500.d22d0ea1.kamezawa.hiroyu@jp.fujitsu.com>
	<48C878AD.4040404@linux.vnet.ibm.com>
	<20080911105638.1581db90.kamezawa.hiroyu@jp.fujitsu.com>
	<20080917232826.GA19256@balbir.in.ibm.com>
	<20080917184008.92b7fc4c.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008 18:40:08 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> > Advantages of the patch
> > 
> > 1. It removes the extra pointer in struct page
> > 
> > Disadvantages
> > 
> > 1. Radix tree lookup is not an O(1) operation, once the page is known
> >    getting to the page_cgroup (pc) is a little more expensive now.
> 
> Why are we doing this?  I can guess, but I'd rather not have to.
> 
> a) It's slower.
> 
> b) It uses even more memory worst-case.
> 
> c) It uses less memory best-case.
> 
> someone somewhere decided that (Aa + Bb) / Cc < 1.0.  What are the values
> of A, B and C and where did they come from? ;)
> 

Balbir, don't you like pre-allocate-page-cgroup-at-boot at all ?
I don't like radix-tree for objects which can spread to very vast/sparse area ;)

BTW, I already have lazy-lru-by-pagevec protocol on my patch(hash version) and
seems to work well. I'm now testing it and will post today if I'm enough lucky.

Thanks,
-Kame

