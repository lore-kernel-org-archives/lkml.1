Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab0CLDHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 22:07:23 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39149 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab0CLDHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 22:07:22 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 12 Mar 2010 12:03:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       kirill@shutemov.name
Subject: Re: [RFC][PATCH 1/3] memcg: wake up filter in oom waitqueue
Message-Id: <20100312120341.857de693.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100312115429.b1b0d994.nishimura@mxp.nes.nec.co.jp>
References: <20100311165315.c282d6d2.kamezawa.hiroyu@jp.fujitsu.com>
	<20100311165559.3f9166b2.kamezawa.hiroyu@jp.fujitsu.com>
	<20100312113028.1449915f.nishimura@mxp.nes.nec.co.jp>
	<20100312113838.d6072ae4.kamezawa.hiroyu@jp.fujitsu.com>
	<20100312115429.b1b0d994.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Mar 2010 11:54:29 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Fri, 12 Mar 2010 11:38:38 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Fri, 12 Mar 2010 11:30:28 +0900
> > Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > 
> > > On Thu, 11 Mar 2010 16:55:59 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > > +	/* check hierarchy */
> > > > +	if (!css_is_ancestor(&oom_wait_info->mem->css, &wake_mem->css) &&
> > > > +	    !css_is_ancestor(&wake_mem->css, &oom_wait_info->mem->css))
> > > > +		return 0;
> > > > +
> > > I think these conditions are wrong.
> > > This can wake up tasks in oom_wait_info->mem when:
> > > 
> > >   00/ <- wake_mem: use_hierarchy == false
> > >     aa/ <- oom_wait_info->mem: use_hierarchy == true;
> > > 
> > Hmm. I think this line bails out above case.
> > 
> > > +	if (!oom_wait_info->mem->use_hierarchy || !wake_mem->use_hierarchy)
> > > +		return 0;
> > 
> > No ?
> > 
> Oops! you're right. I misunderstood the code.
> 
> Then, this patch looks good to me.
> 
> 	Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 

Thank you very much!

-Kame

