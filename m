Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbYI0AFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbYI0AFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 20:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbYI0AFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 20:05:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:15964 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbYI0AFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 20:05:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,316,1220252400"; 
   d="scan'208";a="52030810"
Date: Fri, 26 Sep 2008 17:05:15 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: Tim Gardner <timg@tpi.com>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       Jiri Kosina <jkosina@suse.cz>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, agospoda@redhat.com,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       tglx@linutronix.de, chris.jones@canonical.com, arjan@linux.jf.intel.com
Subject: Re: e1000e NVM corruption issue status
In-Reply-To: <48DD2F98.8070509@tpi.com>
Message-ID: <Pine.WNT.4.63.0809261316310.4052@jbrandeb-desk.amr.corp.intel.com>
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com>
 <48DCCC5F.8040609@linux.intel.com> <200809261052.38966.jbarnes@virtuousgeek.org>
 <200809261123.52198.jbarnes@virtuousgeek.org> <48DD2F98.8070509@tpi.com>
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: jesse.brandeburg@intel.com@imap.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2008, Tim Gardner wrote:
> > Ok here's an updated one.  Jesse (Br) can you add it to your list?  If the X 
> > driver really is mapping too much this should catch it, as long as it goes 
> > through sysfs.

I have, am testing with it now.

> I've been experimenting with unmapping flash space until its actually
> needed, e.g., in the functions that use the E1000_READ_FLASH and
> E1000_WRITE_FLASH macros. Along the way I looked at how flash write

That sounds like a good patch set.  I had thought of trying that but 
hadn't gotten to it yet, so if you have something to look at in diff 
format just post it and we'll take a look.

> cycles are initiated because I was having a hard time believing that
> having flash space mapped was part of the root cause. However, it looks
> like its pretty simple to initiate a write or erase cycle. All of the
> required action bits in ICH_FLASH_HSFSTS and ICH_FLASH_HSFCTL must be 1,
> and these 2 register are in the correct order if X was writing 0xff in
> ascending order.

Seems simple but when I tried it for a couple of hours yesterday I 
couldn't get anything to happen to my flash.  This included putting 
ew16flash writes in the e1000e driver, and writing those magic bits.
