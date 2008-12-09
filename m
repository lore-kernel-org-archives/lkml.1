Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbYLIMct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbYLIMct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 07:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbYLIMci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 07:32:38 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:39233 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbYLIMch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 07:32:37 -0500
Date: Tue, 9 Dec 2008 17:57:31 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 4/6] Flat hierarchical reclaim by ID
Message-ID: <20081209122731.GB4174@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
	"lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
	"menage@google.com" <menage@google.com>,
	"kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20081209200213.0e2128c1.kamezawa.hiroyu@jp.fujitsu.com> <20081209200915.41917722.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081209200915.41917722.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2008-12-09 20:09:15]:

> 
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Implement hierarchy reclaim by cgroup_id.
> 
> What changes:
> 	- Page reclaim is not done by tree-walk algorithm
> 	- mem_cgroup->last_schan_child is changed to be ID, not pointer.
> 	- no cgroup_lock, done under RCU.
> 	- scanning order is just defined by ID's order.
> 	  (Scan by round-robin logic.)
> 
> Changelog: v3 -> v4
> 	- adjusted to changes in base kernel.
> 	- is_acnestor() is moved to other patch.
> 
> Changelog: v2 -> v3
> 	- fixed use_hierarchy==0 case
> 
> Changelog: v1 -> v2
> 	- make use of css_tryget();
> 	- count # of loops rather than remembering position.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujisu.com>

I have not yet run the patch, but the heuristics seem a lot like
magic. I am not against scanning by order, but is order the right way
to scan groups? Does this order reflect their position in the
hierarchy? Shouldn't id's belong to cgroups instead of just memory
controller? I would push back ids to cgroups infrastructure.

-- 
	Balbir
