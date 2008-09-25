Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYIYSlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYIYSlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbYIYSlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:41:13 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47927 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbYIYSlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:41:09 -0400
Subject: Re: [PATCH 9/12] memcg allocate all page_cgroup at boot
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
In-Reply-To: <20080925153206.281243dc.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080925153206.281243dc.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 11:40:47 -0700
Message-Id: <1222368047.15523.81.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-25 at 15:32 +0900, KAMEZAWA Hiroyuki wrote:
> @@ -949,6 +953,11 @@ struct mem_section {
> 
>         /* See declaration of similar field in struct zone */
>         unsigned long *pageblock_flags;
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR
> +       /* see page_cgroup.h */
> +       struct page_cgroup *page_cgroup;
> +       unsigned long pad;
> +#endif
>  };

I thought the use of this variable was under the

	+#ifdef CONFIG_FLAT_NODE_MEM_MAP

options.  Otherwise, we unconditionally bloat mem_section, right?

-- Dave

