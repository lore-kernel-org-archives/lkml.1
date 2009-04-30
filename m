Return-Path: <linux-kernel-owner+w=401wt.eu-S1762980AbZD3VTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762980AbZD3VTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 17:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759520AbZD3VTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 17:19:35 -0400
Received: from netrider.rowland.org ([192.131.102.5]:59620 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758808AbZD3VTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 17:19:34 -0400
Date: Thu, 30 Apr 2009 17:19:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: David VomLehn <dvomlehn@cisco.com>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>, <linux-scsi@cuplxvomd02.corp.sa.net>,
       <netdev@cuplxvomd02.corp.sa.net>
Subject: Re: [PATCH 1/5] KERNEL: Support asynchronously-discovered boot
 devices, v4 (resend)
In-Reply-To: <20090430140559.a2343f7c.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0904301712450.31375-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Andrew Morton wrote:

> Please do sort out your email issues - this patchset came dribbled out
> over a many-hour period with somewhat random cc's on each one, making
> it all quite hard to discuss in any sensible way.

David, my email works fine.  If you want, you can send the patches to 
me and I'll relay them to everyone else.

> On Wed, 29 Apr 2009 18:45:30 -0700
> David VomLehn <dvomlehn@cisco.com> wrote:
> 
> > This patch adds synchronization infrastructure between asynchronous device
> > discovery and code that uses possibly asynchronous discovered devices at
> > boot time. It provides the framework to fix race conditions, such as for
> > the console, that have arisen as a result of quite successful work that has
> > been done to reduce boot times.
> 
> Although I haven't read them yet, the patches themselves look very
> nice - cleanly coded, carefully explained and well documented.  Easy to merge.
> 
> Unfortunately I don't know who you should have sent them to - nobody
> really owns this stuff and it agglomerates over time as a result of
> drive-by bandaiding by whoever happens to have a problem at the time.
> 
> I guess that means you should send them to me ;)
> 
> What would help things along here would be if you were to better
> provide a description of what problem this all solves.  Presumably
> there are scenarios where the kernel does something bad, and this
> patchset fixes it.  Well, please describe some of these scenarios in
> sufficient detail, and explain to us how the patch fixes them?
> 
> I'm a bit queazy over the whole "bootdev" name.  To me, a bootdev is
> the storage device which we boot off: usually a spinning disk
> containing grub.conf, bzImage, etc.    So I need to remember that
> 
> > +Boot devices are those devices that must be used or configured during the
> > +boot process.
> 
> I wonder if we can think of something more new ad unique.  startupdev?  yuk.

Initdev?  Or does that mean something else also?

Really, these are devices that we want to have working before starting
up any userspace processes.  These would be the console device(s) (so
that the first process has open files for its stdin, stdout, and
stderr) and the block device containing the root filesystem (if the
initramfs image doesn't make its own arrangements).

Alan Stern

