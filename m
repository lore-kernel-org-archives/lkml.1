Return-Path: <linux-kernel-owner+w=401wt.eu-S1751346AbZH1QDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbZH1QDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 12:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbZH1QDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 12:03:45 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:49808 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZH1QDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 12:03:45 -0400
Date: Fri, 28 Aug 2009 21:33:40 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 2/5] memcg: uncharge in batched manner
Message-ID: <20090828160340.GU4889@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com> <20090828132438.b33828bc.kamezawa.hiroyu@jp.fujitsu.com> <20090828151011.GS4889@balbir.in.ibm.com> <b9c52b465bda540da8dbcd434bff55be.squirrel@webmail-b.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <b9c52b465bda540da8dbcd434bff55be.squirrel@webmail-b.css.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-29 00:21:50]:

> > tof unmap_vmas, exit_mmap, etc so that we don't have to keep
> > additional data structures around.
> >
> We can't. We uncharge when page->mapcount goes down to 0.
> This is unknown until page_remove_rmap() decrement page->mapcount
> by "atomic" ops.
> 
> My first version allocated memcg_batch_info on stack ...and..
> I had to pass an extra argument to page_remove_rmap() etc....
> That was very ugly ;(
> Now, I adds per-task memcg_batch_info to task struct.
> Because it will be always used at exit() and make exit() path
> much faster, it's not very costly.
>

Aaah.. I see that makes a lot of sense. Thanks for the clarification. 

-- 
	Balbir
