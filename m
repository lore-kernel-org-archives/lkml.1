Return-Path: <linux-kernel-owner+w=401wt.eu-S1761606AbYAKPt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761606AbYAKPt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 10:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759850AbYAKPtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 10:49:19 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:31464 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759438AbYAKPtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 10:49:18 -0500
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20080111143627.FD64.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080108205939.323955454@redhat.com>
	 <20080108210002.638347207@redhat.com>
	 <20080111143627.FD64.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 11 Jan 2008 10:50:09 -0500
Message-Id: <1200066610.5304.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-11 at 15:24 +0900, KOSAKI Motohiro wrote:
> Hi Rik
> 
> > +static inline int is_file_lru(enum lru_list l)
> > +{
> > +	BUILD_BUG_ON(LRU_INACTIVE_FILE != 2 || LRU_ACTIVE_FILE != 3);
> > +	return (l/2 == 1);
> > +}
> 
> below patch is a bit cleanup proposal.
> i think LRU_FILE is more clarify than "/2".
> 
> What do you think it?
> 
> 
> 
> Index: linux-2.6.24-rc6-mm1-rvr/include/linux/mmzone.h
> ===================================================================
> --- linux-2.6.24-rc6-mm1-rvr.orig/include/linux/mmzone.h        2008-01-11 11:10:30.000000000 +0900
> +++ linux-2.6.24-rc6-mm1-rvr/include/linux/mmzone.h     2008-01-11 14:40:31.000000000 +0900
> @@ -147,7 +147,7 @@
>  static inline int is_file_lru(enum lru_list l)
>  {
>         BUILD_BUG_ON(LRU_INACTIVE_FILE != 2 || LRU_ACTIVE_FILE != 3);
> -       return (l/2 == 1);
> +       return !!(l & LRU_FILE);
>  }
> 
>  struct per_cpu_pages {
> 

Kosaki-san:

Again, my doing.  I agree that the calculation is a bit strange, but I
wanted to "future-proof" this function in case we ever get to a value of
'6' for the lru_list enum.  In that case, the AND will evaluate to
non-zero for what may not be a file LRU.  Between the build time
assertion and the division [which could just be a 'l >> 1', I suppose]
we should be safe.

Thanks,
Lee

