Return-Path: <linux-kernel-owner+w=401wt.eu-S1030951AbXDXA0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030951AbXDXA0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 20:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030937AbXDXA0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 20:26:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53752 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030951AbXDXA0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 20:26:31 -0400
Date: Tue, 24 Apr 2007 09:26:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: mel@skynet.ie (Mel Gorman)
Cc: y-goto@jp.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, tony.luck@intel.com
Subject: Re: [PATCH]Fix parsing kernelcore boot option for ia64
Message-Id: <20070424092625.b2b24a76.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070423183246.GA11841@skynet.ie>
References: <20070413140533.A239.Y-GOTO@jp.fujitsu.com>
	<20070421232248.431ef2da.akpm@linux-foundation.org>
	<20070423203837.23AD.Y-GOTO@jp.fujitsu.com>
	<20070423183246.GA11841@skynet.ie>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007 19:32:46 +0100
mel@skynet.ie (Mel Gorman) wrote:

> > > I wasn't even aware of this kernelcore thing.  It's pretty nasty-looking. 
> > > yet another reminder that this code hasn't been properly reviewed in the
> > > past year or three.
> > 
> > Just now, I'm making memory-unplug patches with current MOVABLE_ZONE
> > code. So, I might be the first user of it on ia64.
> > 
> > Anyway, I'll try to fix it.
> > 
> 
> Can you review this patch and see does it fix the problem please? There
> was a second problem that showed up while testing this in relation to the
> bootmem allocator assumptions about zone boundary alignment. I'll follow up
> this mail with the patch in case you are seeing that problem.
> 
> Subject: Fix parsing kernelcore boot option V2
> cmdline_parse_kernelcore() should return the next pointer of boot option
> like memparse() doing. If not, it is cause of eternal loop on ia64 box.
> This patch is for 2.6.21-rc6-mm1. This patch changes the kernelcore command
> line parsing so that is compatible with both early_param() way of doing
> things and IA64.
> 
In my understanding, why ia64 doesn't use early_param() macro for mem= at el. is that 
it has to use mem= option at efi handling which is called before parse_early_param().

Current ia64's boot path is
 setup_arch()
    -> efi handling -> parse_early_param() -> numa handling -> pgdat/zone init

kernelcore= option is just used at pgdat/zone initialization. (no arch dependent part...)

So I think just adding
==
early_param("kernelcore",cmpdline_parse_kernelcore)
==
to ia64 is ok.....

-Kame

