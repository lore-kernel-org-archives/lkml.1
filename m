Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZCEP1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZCEP1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 10:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZCEP0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 10:26:53 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:37225 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbZCEP0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 10:26:52 -0500
Date: Thu, 5 Mar 2009 20:56:42 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] Memory controller soft limit patches (v3)
Message-ID: <20090305152642.GA5482@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090302060519.GG11421@balbir.in.ibm.com> <20090302152128.e74f51ef.kamezawa.hiroyu@jp.fujitsu.com> <20090302063649.GJ11421@balbir.in.ibm.com> <20090302160602.521928a5.kamezawa.hiroyu@jp.fujitsu.com> <20090302124210.GK11421@balbir.in.ibm.com> <c31ccd23cb41f0f7594b3f56b20f0165.squirrel@webmail-b.css.fujitsu.com> <20090302174156.GM11421@balbir.in.ibm.com> <20090303085914.555089b1.kamezawa.hiroyu@jp.fujitsu.com> <20090303111244.GP11421@balbir.in.ibm.com> <20090305180410.a44035e0.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090305180410.a44035e0.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-05 18:04:10]:

> On Tue, 3 Mar 2009 16:42:44 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > > I wrote
> > > ==
> > >  if (victim is not over soft-limit)
> > > ==
> > > ....Maybe this discussion style is bad and I should explain my approach in patch.
> > > (I can't write code today, sorry.)
> > > 
> 
> This is an example of my direction, " do it lazy" softlimit.
> 
> Maybe this is not perfect but this addresses almost all my concern.
> I hope this will be an input for you.
> I didn't divide patch into small pieces intentionally to show a big picture.
> Thanks,
> -Kame
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> An example patch. Don't trust me, this patch may have bugs.
>

Well this is not do it lazy, all memcg's are scanned tree is built everytime
kswapd invokes soft limit reclaim. With 100 cgroups and 5 nodes, we'll
end up scanning cgroups 500 times. There is no ordering of selected
victims, so the largest victim might still be running unaffected.

-- 
	Balbir
