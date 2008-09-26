Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbYIZBL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbYIZBL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 21:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYIZBLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 21:11:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39881 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYIZBLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 21:11:18 -0400
Date: Fri, 26 Sep 2008 10:17:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: Re: [PATCH 9/12] memcg allocate all page_cgroup at boot
Message-Id: <20080926101754.91e64254.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1222368047.15523.81.camel@nimitz>
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com>
	<20080925153206.281243dc.kamezawa.hiroyu@jp.fujitsu.com>
	<1222368047.15523.81.camel@nimitz>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008 11:40:47 -0700
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> On Thu, 2008-09-25 at 15:32 +0900, KAMEZAWA Hiroyuki wrote:
> > @@ -949,6 +953,11 @@ struct mem_section {
> > 
> >         /* See declaration of similar field in struct zone */
> >         unsigned long *pageblock_flags;
> > +#ifdef CONFIG_CGROUP_MEM_RES_CTLR
> > +       /* see page_cgroup.h */
> > +       struct page_cgroup *page_cgroup;
> > +       unsigned long pad;
> > +#endif
> >  };
> 
> I thought the use of this variable was under the
> 
> 	+#ifdef CONFIG_FLAT_NODE_MEM_MAP
> 
> options.  Otherwise, we unconditionally bloat mem_section, right?
> 
Hmmm......Oh, yes ! nice catch.

Thanks, I'll fix.
-Kame

