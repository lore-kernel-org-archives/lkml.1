Return-Path: <linux-kernel-owner+w=401wt.eu-S1752665AbYKLDwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbYKLDwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 22:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYKLDwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 22:52:44 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56521 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbYKLDwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 22:52:43 -0500
Date: Wed, 12 Nov 2008 12:52:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][mm] [PATCH 3/4] Memory cgroup hierarchical reclaim (v3)
Message-Id: <20081112125204.a92816cc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081111123417.6566.52629.sendpatchset@balbir-laptop>
References: <20081111123314.6566.54133.sendpatchset@balbir-laptop>
	<20081111123417.6566.52629.sendpatchset@balbir-laptop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 18:04:17 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> +
> +		/*
> +		 * We need to give up the cgroup lock if it is held, since
> +		 * it creates the potential for deadlock. cgroup_mutex should
> +		 * be acquired after cpu_hotplug lock. In this path, we
> +		 * acquire the cpu_hotplug lock after acquiring the cgroup_mutex
> +		 * Giving it up should be OK
> +		 */
> +		if (cgroup_locked)
> +			cgroup_unlock();

nice catch. I'll post a fix to this as its own patch. 

Thanks,
-Kame


