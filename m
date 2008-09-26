Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbYIZIgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbYIZIgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 04:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbYIZIgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 04:36:10 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:33056 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753239AbYIZIgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 04:36:09 -0400
Message-ID: <48DC9EF2.10004@linux.vnet.ibm.com>
Date: Fri, 26 Sep 2008 14:06:02 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: Re: [PATCH 2/12] memcg move charege() call to swapped-in page under
 lock_page()
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com> <20080925151457.0ad68293.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080925151457.0ad68293.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> While page-cache's charge/uncharge is done under page_lock(), swap-cache
> isn't. (anonymous page is charged when it's newly allocated.)
> 
> This patch moves do_swap_page()'s charge() call under lock. This helps
> us to avoid to charge already mapped one, unnecessary calls.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Seems reasonable to me

Just one quick comment though, as a result of this change, mark_page_accessed is
now called with PageLock held, I suspect you would want to move that call prior
to lock_page().



-- 
	Balbir
