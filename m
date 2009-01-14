Return-Path: <linux-kernel-owner+w=401wt.eu-S1760203AbZANNzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203AbZANNzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 08:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbZANNzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 08:55:43 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:41860 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbZANNzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 08:55:41 -0500
Date: Wed, 14 Jan 2009 19:25:39 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>
Subject: Re: [RFC][PATCH 5/4] memcg: don't call res_counter_uncharge when
	obsolete
Message-ID: <20090114135539.GA21516@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090113184533.6ffd2af9.nishimura@mxp.nes.nec.co.jp> <20090114175121.275ecd59.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090114175121.275ecd59.nishimura@mxp.nes.nec.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> [2009-01-14 17:51:21]:

> This is a new one. Please review.
> 
> ===
> From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> mem_cgroup_get ensures that the memcg that has been got can be accessed
> even after the directory has been removed, but it doesn't ensure that parents
> of it can be accessed: parents might have been freed already by rmdir.
> 
> This causes a bug in case of use_hierarchy==1, because res_counter_uncharge
> climb up the tree.
> 
> Check if the memcg is obsolete, and don't call res_counter_uncharge when obsole.
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

I liked the earlier, EBUSY approach that ensured that parents could
not go away if children exist. IMHO, the code has gotten too complex
and has too many corner cases. Time to revisit it.

-- 
	Balbir
