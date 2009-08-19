Return-Path: <linux-kernel-owner+w=401wt.eu-S1751950AbZHSIPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbZHSIPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 04:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbZHSIPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 04:15:48 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56621 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbZHSIPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 04:15:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 19 Aug 2009 17:13:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org, linux-mm@kvack.org,
       Neil Horman <nhorman@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       akpm@linux-foundation.org, bernhard.walle@gmx.de,
       Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 8/8] kexec: allow to shrink reserved memory
Message-Id: <20090819171346.aadfeb2c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4A8B6649.3080103@redhat.com>
References: <20090812081731.5757.25254.sendpatchset@localhost.localdomain>
	<20090812081906.5757.39417.sendpatchset@localhost.localdomain>
	<m1bpmk8l1g.fsf@fess.ebiederm.org>
	<4A83893D.50707@redhat.com>
	<m1eirg5j9i.fsf@fess.ebiederm.org>
	<4A83CD84.8040609@redhat.com>
	<m1tz0avy4h.fsf@fess.ebiederm.org>
	<4A8927DD.6060209@redhat.com>
	<20090818092939.2efbe158.kamezawa.hiroyu@jp.fujitsu.com>
	<4A8A4ABB.70003@redhat.com>
	<20090818172552.779d0768.kamezawa.hiroyu@jp.fujitsu.com>
	<4A8A83F4.6010408@redhat.com>
	<20090819085703.ccf9992a.kamezawa.hiroyu@jp.fujitsu.com>
	<4A8B6649.3080103@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009 10:41:13 +0800
Amerigo Wang <amwang@redhat.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Tue, 18 Aug 2009 18:35:32 +0800
> > Amerigo Wang <amwang@redhat.com> wrote:
> >
> >   
> >> KAMEZAWA Hiroyuki wrote:
> >>     
> >>> On Tue, 18 Aug 2009 14:31:23 +0800
> >>> Amerigo Wang <amwang@redhat.com> wrote:
> >>>   
> >>>       
> >>>>>     It's hidden from the system before mem_init() ?
> >>>>>   
> >>>>>       
> >>>>>           
> >>>> Not sure, but probably yes. It is reserved in setup_arch() which is 
> >>>> before mm_init() which calls mem_init().
> >>>>
> >>>> Do you have any advice to free that reserved memory after boot? :)
> >>>>
> >>>>     
> >>>>         
> >>> Let's see arch/x86/mm/init.c::free_initmem()
> >>>
> >>> Maybe it's all you want.
> >>>
> >>> 	- ClearPageReserved()
> >>> 	- init_page_count()
> >>> 	- free_page()
> >>> 	- totalram_pages++
> >>>   
> >>>       
> >> Just FYI: calling ClearPageReserved() caused an oops: "Unable to handle 
> >> paging request".
> >>
> >> I am trying to figure out why...
> >>
> >>     
> > Hmm...then....memmap is not there.
> > pfn_valid() check will help you. What arch ? x86-64 ?
> >   
> 
> Hmm, yes, x86_64, but this code is arch-independent, I mean it should 
> work or not work on all arch, no?
> 
> So I am afraid we need to use other API to free it...
> 
The, problem is whether memmap is there or not. That's all.
plz see init sequence and check there are memmap.
If memory-for-crash is obtained via bootmem,
Don't you try to free memory hole ?


Thanks,
-Kame




