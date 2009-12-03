Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbZLCCPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbZLCCPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 21:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbZLCCPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 21:15:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51695 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbZLCCPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 21:15:37 -0500
Message-ID: <4B171F35.1010908@cn.fujitsu.com>
Date: Thu, 03 Dec 2009 10:15:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>, Nick Piggin <npiggin@suse.de>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 22/24] HWPOISON: add memory cgroup filter
References: <20091202031231.735876003@intel.com> <20091202043046.519053333@intel.com> <20091202124446.GA18989@one.firstfloor.org> <20091202125842.GA13277@localhost>
In-Reply-To: <20091202125842.GA13277@localhost>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifdef	CONFIG_CGROUP_MEM_RES_CTLR_SWAP
> +u32 hwpoison_filter_memcg;
> +static int hwpoison_filter_task(struct page *p)
> +{
> +	struct mem_cgroup *mem;
> +	struct cgroup_subsys_state *css;
> +
> +	if (!hwpoison_filter_memcg)
> +		return 0;
> +
> +	mem = try_get_mem_cgroup_from_page(p);
> +	if (!mem)
> +		return -EINVAL;
> +
> +	css = mem_cgroup_css(mem);
> +	if (!css)
> +		return -EINVAL;
> +

Here, if mem != NULL, then css won't be NULL.

> +	css_put(css);
> +	return 0;
> +}
