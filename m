Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbZFOElS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbZFOElS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 00:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbZFOElK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 00:41:10 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56438 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbZFOElJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 00:41:09 -0400
Date: Mon, 15 Jun 2009 10:11:09 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: Low overhead patches for the memory cgroup controller (v5)
Message-ID: <20090615044109.GG23577@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090615043900.GF23577@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090615043900.GF23577@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balbir Singh <balbir@linux.vnet.ibm.com> [2009-06-15 10:09:00]:

> 
> Feature: Remove the overhead associated with the root cgroup
> 
> From: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> Changelog v5 -> v4
> 1. Moved back to v3 logic (Daisuke and Kamezawa like that better)
> 2. Incorporated changes from Daisuke (remove list_empty() checks)
> 3. Updated documentation to reflect that limits cannot be set on root
>    cgroup
> 
> Changelog v4 -> v3
> 1. Rebase to mmotm 9th june 2009
> 2. Remove PageCgroupRoot, we have account LRU flags to indicate that
>    we do only accounting and no reclaim.
> 3. pcg_default_flags has been used again, since PCGF_ROOT is gone,
>    we set PCGF_ACCT_LRU only in mem_cgroup_add_lru_list
> 4. More LRU functions are aware of PageCgroupAcctLRU
> 
> Changelog v3 -> v2
> 
> 1. Rebase to mmotm 2nd June 2009
> 2. Test with some of the test cases recommended by Daisuke-San
> 
> Changelog v2 -> v1
> 1. Rebase to latest mmotm
> 
> This patch changes the memory cgroup and removes the overhead associated
> with accounting all pages in the root cgroup. As a side-effect, we can
> no longer set a memory hard limit in the root cgroup.
> 
> A new flag to track whether the page has been accounted or not
> has been added as well. Flags are now set atomically for page_cgroup,
> pcg_default_flags is now obsolete and removed.
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

CC'ing the correct Kamezawa-San

-- 
	Balbir
