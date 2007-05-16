Return-Path: <linux-kernel-owner+w=401wt.eu-S934236AbXEPT32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934236AbXEPT32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933320AbXEPT3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:29:03 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:16237 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759555AbXEPT3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:29:00 -0400
Date: Wed, 16 May 2007 15:25:58 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: filesystem benchmarking fun
Message-ID: <20070516192558.GB26766@think.oraclecorp.com>
References: <20070516144205.GV26766@think.oraclecorp.com> <Pine.LNX.4.61.0705162010370.9019@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705162010370.9019@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 08:12:09PM +0200, Jan Engelhardt wrote:
> 
> On May 16 2007 10:42, Chris Mason wrote:
> >
> >For example, I'll pick on xfs for a minute.  compilebench shows the
> >default FS you get from mkfs.xfs is pretty slow for untarring a bunch of
> >kernel trees.
> 
> I suppose you used 'nobarrier'? [ http://lkml.org/lkml/2006/5/19/33 ]

Oddly, xfs fails barriers on this sata drive although the other filesystems
don't.  But yes, I tried both ways.

> 
> >Dave Chinner gave me some mount options that make it
> >dramatically better,
> 
> and `mkfs.xfs -l version=2` is also said to make it better

I used mkfs.xfs -l size=128m,version=2
mount -o logbsize=256k,nobarrier 

> 
> >but it still writes at 10MB/s on a sata drive that
> >can do 80MB/s.  Ext3 is better, but still only 20MB/s. 
> >
> >Both are presumably picking a reasonable file and directory layout.
> >Still, our writeback algorithms are clearly not optimized for this kind
> >of workload.  Should we fix it?
> 
> Also try with tmpfs.
> 
Sorry, I'm not entirely clear on what we learn from trying tmpfs?

-chris

