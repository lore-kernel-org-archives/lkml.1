Return-Path: <linux-kernel-owner+w=401wt.eu-S1762700AbXEPFYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762700AbXEPFYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 01:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759504AbXEPFY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 01:24:29 -0400
Received: from 1wt.eu ([62.212.114.60]:2662 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758781AbXEPFY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 01:24:28 -0400
Date: Wed, 16 May 2007 07:22:54 +0200
From: Willy Tarreau <w@1wt.eu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070516052253.GI943@1wt.eu>
References: <20070515151919.GA32510@lazybastard.org> <20070515133759.9ee434a2.akpm@linux-foundation.org> <20070516000630.GD1220@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070516000630.GD1220@lazybastard.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 02:06:31AM +0200, Jörn Engel wrote:
> On Tue, 15 May 2007 13:37:59 -0700, Andrew Morton wrote:
> > It's strange and a bit regrettable that an fs would have dependency on MTD,
> > really.
> 
> It is and changing this wouldn't be too hard.  All device access goes
> through five functions (read, write, erase, is_bad and mark_bad).  As
> soon as someone seriously cares I will add a struct logfs_device_ops and
> have a second set of these functions for block devices.
> 
> On hard disks it shouldn't make too much sense.  The filesystem will
> fragment like a splinter bomb and be just as popular.

On hard disks, yes, but as you suggested, there are lots of other flash
devices interfaced as block devices. CompactFlash comes to mind, USB
keys too. And on these ones, the most important is to reduce the number
of writes and to support large sizes. I already see LogFS as an interesting
alternative to JFFS2 on such devices, eventhough it does not (yet?) support
compression.

Regards,
Willy

