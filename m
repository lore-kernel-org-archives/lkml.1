Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbZK0CsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbZK0CsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 21:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbZK0CsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 21:48:04 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38113 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbZK0CsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 21:48:03 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 27 Nov 2009 11:45:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
       containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v0 2/3] res_counter: implement thresholds
Message-Id: <20091127114511.bbb43d5a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091127092035.bbf2efdc.nishimura@mxp.nes.nec.co.jp>
References: <cover.1259255307.git.kirill@shutemov.name>
	<bc4dc055a7307c8667da85a4d4d9d5d189af27d5.1259255307.git.kirill@shutemov.name>
	<8524ba285f6dd59cda939c28da523f344cdab3da.1259255307.git.kirill@shutemov.name>
	<20091127092035.bbf2efdc.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Nov 2009 09:20:35 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> Hi.
> >  
> > @@ -73,6 +76,7 @@ void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val)
> >  		val = counter->usage;
> >  
> >  	counter->usage -= val;
> > +	res_counter_threshold_notify_locked(counter);
> >  }
> >  
> hmm.. this adds new checks to hot-path of process life cycle.
> 
> Do you have any number on performance impact of these patches(w/o setting any threshold)?
> IMHO, it might be small enough to be ignored because KAMEZAWA-san's coalesce charge/uncharge
> patches have decreased charge/uncharge for res_counter itself, but I want to know just to make sure.
> 
Another concern is to support root cgroup, you need another notifier hook in
memcg because root cgroup doesn't use res_counter now.

Can't this be implemented in a way like softlimit check ? 
Filter by the number of event will be good for notifier behavior, for avoiding
too much wake up, too.

Thanks,
-Kame

