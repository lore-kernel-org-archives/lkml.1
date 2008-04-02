Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbYDBEtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbYDBEtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 00:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbYDBEtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 00:49:39 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42882 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbYDBEtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 00:49:39 -0400
Date: Wed, 2 Apr 2008 13:53:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][-mm] Add an owner to the mm_struct (v4)
Message-Id: <20080402135357.04c3e79f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47F2FCAE.7070401@linux.vnet.ibm.com>
References: <20080401124312.23664.64616.sendpatchset@localhost.localdomain>
	<20080402093157.e445acfb.kamezawa.hiroyu@jp.fujitsu.com>
	<47F2FCAE.7070401@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Apr 2008 08:55:34 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> > 
> >> +	/*
> >> +	 * Search through everything else. We should not get
> >> +	 * here often
> >> +	 */
> >> +	do_each_thread(g, c) {
> >> +		if (c->mm == mm)
> >> +			goto assign_new_owner;
> >> +	} while_each_thread(g, c);
> > 
> > Doing above in synchronized manner seems too heavy.
> > When this happen ? or Can this be done in lazy "on-demand" manner ?
> > 
> 
> Do you mean under task_lock()?
> 
No, scanning itself. 
How rarely this scan happens under a server which has 10000- threads ?

Thanks,
-Kame

