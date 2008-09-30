Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbYI3I11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbYI3I11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbYI3I1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:27:19 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:37298 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbYI3I1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:27:19 -0400
Message-ID: <48E1DDD5.9040304@linux.vnet.ibm.com>
Date: Tue, 30 Sep 2008 13:35:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 1/4] memcg: account swap cache under lock
References: <20080929191927.caabec89.kamezawa.hiroyu@jp.fujitsu.com> <20080929192123.5ce60c24.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080929192123.5ce60c24.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> While page-cache's charge/uncharge is done under page_lock(), swap-cache
> isn't. (anonymous page is charged when it's newly allocated.)
> 
> This patch moves do_swap_page()'s charge() call under lock.
> I don't see any bad problem *now* but this fix will be good for future
> for avoiding unneccesary racy state.
> 
> 
> Changelog: (v5) -> (v6)
>  - mark_page_accessed() is moved before lock_page().
>  - fixed missing unlock_page()
> (no changes in previous version)

Looks good to me

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Balbir
