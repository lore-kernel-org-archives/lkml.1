Return-Path: <linux-kernel-owner+w=401wt.eu-S1758450AbZCaAFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbZCaAFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 20:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760900AbZCaAB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 20:01:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45527 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760876AbZCaABz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 20:01:55 -0400
Date: Tue, 31 Mar 2009 09:00:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 7/8] memcg soft limit LRU reorder
Message-Id: <20090331090023.e1d30a5a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090330075246.GA16497@balbir.in.ibm.com>
References: <20090327135933.789729cb.kamezawa.hiroyu@jp.fujitsu.com>
	<20090327141225.1e483acd.kamezawa.hiroyu@jp.fujitsu.com>
	<20090330075246.GA16497@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009 13:22:46 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-27 14:12:25]:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > This patch adds a function to change the LRU order of pages in global LRU
> > under control of memcg's victim of soft limit.
> > 
> > FILE and ANON victim is divided and LRU rotation will be done independently.
> > (memcg which only includes FILE cache or ANON can exists.)
> > 
> > The routine finds specfied number of pages from memcg's LRU and
> > move it to top of global LRU. They will be the first target of shrink_xxx_list.
> 
> This seems to be the core of the patch, but I don't like this very
> much. Moving LRU pages of the mem cgroup seems very subtle, why can't
> we directly use try_to_free_mem_cgroup_pages()?
> 
It ignores many things.

Thanks,
-Kame

