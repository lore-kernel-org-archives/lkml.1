Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbYIZJMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbYIZJMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 05:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbYIZJLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 05:11:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40899 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbYIZJLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 05:11:48 -0400
Date: Fri, 26 Sep 2008 18:18:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: Re: [PATCH 2/12] memcg move charege() call to swapped-in page under
 lock_page()
Message-Id: <20080926181803.351e94cf.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48DC9EF2.10004@linux.vnet.ibm.com>
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com>
	<20080925151457.0ad68293.kamezawa.hiroyu@jp.fujitsu.com>
	<48DC9EF2.10004@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2008 14:06:02 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > While page-cache's charge/uncharge is done under page_lock(), swap-cache
> > isn't. (anonymous page is charged when it's newly allocated.)
> > 
> > This patch moves do_swap_page()'s charge() call under lock. This helps
> > us to avoid to charge already mapped one, unnecessary calls.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Seems reasonable to me
> 
> Just one quick comment though, as a result of this change, mark_page_accessed is
> now called with PageLock held, I suspect you would want to move that call prior
> to lock_page().
> 
Ok. I'll check it

Thanks,
-Kame
> 
> 
> -- 
> 	Balbir
> 

