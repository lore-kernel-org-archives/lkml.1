Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbYDIAiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbYDIAiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 20:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYDIAiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 20:38:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50198 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYDIAiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 20:38:09 -0400
Date: Wed, 9 Apr 2008 09:42:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm] Add an owner to the mm_struct (v8)
Message-Id: <20080409094246.f9a2a901.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080404080544.26313.38199.sendpatchset@localhost.localdomain>
References: <20080404080544.26313.38199.sendpatchset@localhost.localdomain>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Apr 2008 13:35:44 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> +	/*
> +	 * Search through everything else. We should not get
> +	 * here often
> +	 */
> +	do_each_thread(g, c) {
> +		if (c->mm == mm)
> +			goto assign_new_owner;
> +	} while_each_thread(g, c);
> +
I'm sorry for my laziness.

Why do_each_thread() ? for_each_process() is not enough ?
(because of delay_group_leader().)

And what we have to test for the worst case is following, right ?
==
 1. create a tons of threads.
 2. create a process which calls vfork().
 3. keep child alive and vfork() caller exits
==

Thanks,
-Kame

