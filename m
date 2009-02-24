Return-Path: <linux-kernel-owner+w=401wt.eu-S1760853AbZBXWAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853AbZBXWAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbZBXWAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:00:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753852AbZBXWAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:00:18 -0500
Date: Tue, 24 Feb 2009 13:59:04 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andy Isaacson <adi@hexapodia.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "lenb@kernel.org" <lenb@kernel.org>, mjg@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, rui.zhang@intel.com
Subject: Re: [Linux 2.6.29-rc6] [drm:i915_set_status_page] *ERROR* can not
 ioremap virtual address for G33 hw status page
In-Reply-To: <1235511845.20084.2.camel@optimus>
Message-ID: <alpine.LFD.2.00.0902241354220.3111@localhost.localdomain>
References: <8db1092f0902230646o78a07a09t920ad65369b5a20d@mail.gmail.com>  <1235419343.4816.27.camel@gaiman> <200902232230.29501.rjw@sisk.pl>  <8db1092f0902231340k7c7d0fd1me49302f2efd03491@mail.gmail.com>  <86802c440902231701q1e169a67oa12bd84ac0e4c7aa@mail.gmail.com>
  <20090224032304.GA26344@hexapodia.org>  <86802c440902232150m2b22e3cfg8993193f8867dfbf@mail.gmail.com>  <20090224194432.GB28772@elte.hu> <49A44F0F.4060105@kernel.org>  <20090224213907.GA12601@elte.hu> <1235511845.20084.2.camel@optimus>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Feb 2009, Dave Airlie wrote:
> > 
> > The other question is, why did the ioremap_wc() fail? Why doesnt 
> > it fall back to UC transparently?
>
> I'm sort of worried the drivers are going to end up doing, which at
> the moment is the only option that will work.
> 
> blah = ioremap_wc();
> if (!blah)
> 	blah = ioremap_nocache();
> 
> which seems pointless so this is a good point, where is the fallback?

I agree.

We should not fail the ioremap_wc(), we should just fall back to nocache, 
(possibly with a warning). In fact I thought we did exactly that, but 
maybe it only happens in certain directions.

			Linus
