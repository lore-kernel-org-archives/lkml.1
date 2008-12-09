Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbYLID7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbYLID7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 22:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbYLID7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 22:59:25 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52556 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbYLID7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 22:59:24 -0500
Date: Tue, 9 Dec 2008 12:58:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: balbir@linux.vnet.ibm.com, linux-mm@kvack.org,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [mm] [PATCH 3/4] Memory cgroup hierarchical reclaim (v4)
Message-Id: <20081209125829.556b1e40.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081209125341.456bf635.nishimura@mxp.nes.nec.co.jp>
References: <20081116081034.25166.7586.sendpatchset@balbir-laptop>
	<20081116081055.25166.85066.sendpatchset@balbir-laptop>
	<20081125205832.38f8c365.nishimura@mxp.nes.nec.co.jp>
	<492C1345.9090201@linux.vnet.ibm.com>
	<20081126111447.106ec275.nishimura@mxp.nes.nec.co.jp>
	<20081209115943.7d6a0ea3.kamezawa.hiroyu@jp.fujitsu.com>
	<20081209125341.456bf635.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2008 12:53:41 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> Not yet.
> 
> Those dead locks cannot be fixed as long as reclaim path tries to hold cgroup_mutex.
> (current mmotm doesn't hold cgroup_mutex on reclaim path if !use_hierarchy and
> I'm testing with !use_hierarchy. It works well basically, but I got another bug
> at rmdir today, and digging it now.)
> 
> The dead lock I've fixed by memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach.patch
> is another one(removed cgroup_lock from oom code).
> 
Okay, then removing cgroup_lock from memory-reclaim path is a way to go..

Thank you.

-Kame

