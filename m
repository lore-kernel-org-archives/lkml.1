Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbZCDMzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbZCDMzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 07:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbZCDMzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 07:55:23 -0500
Received: from mga14.intel.com ([143.182.124.37]:48522 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbZCDMzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 07:55:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,301,1233561600"; 
   d="scan'208";a="116625985"
Date: Wed, 4 Mar 2009 20:54:25 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: drop_caches ...
Message-ID: <20090304125425.GA20435@localhost>
References: <20090304123836.GA13706@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304123836.GA13706@ics.muni.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 02:38:36PM +0200, Lukas Hejtmanek wrote:
> Hello,
> 
> > So you don't have lots of mapped pages(Mapped=51M) or tmpfs files. It's
> > strange to me that there are so many undroppable cached pages(Cached=359M),
> > and most of them lie out of the LRU queue(Active+Inactive file=53M)...
> 
> > Anyone have better clues on these 'hidden' pages?
> 
> I think he is simply using Intel driver + GEM + UXA = TONS of drm mm objects
> in tmpfs which is 'hidden' unless you have /proc/filecache to see them.

Ah I was about to ask him to try filecache before you and Zdenek kick in.

I was expecting the shm pages to be accounted in /dev/shm, however the
GEM shm pages are allocated from an in-kernel tmpfs mount...

And I noticed in filecache that you are compiling your own
/usr/local/drm/lib/libdrm_intel.so.1.0.0, now I know what are you doing ;-)

Good job, Lukas!

Thanks,
Fengguang
