Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbZGVXsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbZGVXsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 19:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbZGVXsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 19:48:50 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57778 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbZGVXst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 19:48:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 23 Jul 2009 08:46:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Nick Piggin <npiggin@suse.de>,
       linux-mm@kvack.org
Subject: Re: [PATCH] hibernate / memory hotplug: always use
 for_each_populated_zone()
Message-Id: <20090723084654.3076d3c5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200907221949.56211.rjw@sisk.pl>
References: <1248103551.23961.0.camel@localhost.localdomain>
	<200907211611.09525.rjw@sisk.pl>
	<20090722092535.5eac1ff6.kamezawa.hiroyu@jp.fujitsu.com>
	<200907221949.56211.rjw@sisk.pl>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 19:49:55 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > and enough simple. But this may allow you to access remapped device's memory...
> > Then, some range check will be required anyway.
> > Can we detect io-remapped range from memmap or any ?
> > (I think we'll have to skip PG_reserved page...)
> > 
> > > > Alternative is making use of walk_memory_resource() as memory hotplug does.
> > > > It checks resource information registered.
> > > 
> > > I'd be fine with any _simple_ mechanism allowing us to check whether there's
> > > a physical page frame for given page (or given PFN).
> > > 
> > 
> > walk_memory_resource() is enough _simple_,  IMHO.
> > Now, I'm removing #ifdef CONFIG_MEMORY_HOTPLUG for walk_memory_resource() to
> > rewrite /proc/kcore. 
> 
> Hmm.  Which architectures set CONFIG_ARCH_HAS_WALK_MEMORY ?
> 

ppc only. It has its own.

I'm now prepareing a patch to remove #ifdef CONFIG_MEMORY_HOTPLUG for /proc/kcore
and rename it to walk_system_ram_range(). plz see "kcore:...." patches currently
posted to lkml if you are interested in.

Thanks,
-Kame

Thanks,
-Kame


> Best,
> Rafael

