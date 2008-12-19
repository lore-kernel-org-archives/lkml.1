Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbYLSJl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbYLSJl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 04:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYLSJlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 04:41:21 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56014 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbYLSJlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 04:41:20 -0500
Date: Fri, 19 Dec 2008 18:40:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "Hugh Dickins" <hugh@veritas.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [bug][mmtom] memcg: MEM_CGROUP_ZSTAT underflow
Message-Id: <20081219184017.7da8748e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081219182929.428380df.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081219172903.7ca9b123.nishimura@mxp.nes.nec.co.jp>
	<20081219182929.428380df.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008 18:29:29 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> +	/*
> + 	 * Don't clear pc->mem_cgroup because del_from_lru() will see this.
> + 	 * The fully unchaged page is assumed to be freed after us, so it's
> + 	 * safe. When this page is reused before free, we have to be careful.
> + 	 * (In SwapCache case...it can happen.)
> +  	 */
>  
Maybe this is better.
==
       /*
         * Don't clear pc->mem_cgroup because del_from_lru() may see this.
         * If this page is fully unchaged, it's assumed to be freed soon,or it
         * is isolated from LRU.  When this page is reused before free
         * (and on LRU), we have to be careful.
         * (In SwapCache case...it can happen.)
         */
==
Hmm.

