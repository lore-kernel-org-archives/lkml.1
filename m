Return-Path: <linux-kernel-owner+w=401wt.eu-S1761939AbYDNQNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761939AbYDNQNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbYDNQNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:13:23 -0400
Received: from tamago.serverit.net ([91.189.209.155]:51631 "EHLO
	mail.hosting2.serverit.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755051AbYDNQNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:13:22 -0400
Date: Mon, 14 Apr 2008 19:12:50 +0300 (EEST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@tamago.serverit.net
To: Anton Altaparmakov <aia21@cam.ac.uk>
cc: Miklos Szeredi <miklos@szeredi.hu>, dwmw2@infradead.org, hch@infradead.org,
       me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
In-Reply-To: <38B7FCFD-9F4F-4D03-9FEE-E44EA19D1599@cam.ac.uk>
Message-ID: <Pine.LNX.4.62.0804141812040.3058@tamago.serverit.net>
References: <14725485.776281208170999085.JavaMail.szaka@kolumbus.fi>
 <Pine.LNX.4.62.0804141444320.22065@tamago.serverit.net>
 <38B7FCFD-9F4F-4D03-9FEE-E44EA19D1599@cam.ac.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 14 Apr 2008, Anton Altaparmakov wrote:

> > I consider this as a benefit for FUSE file systems. An unloadable kernel
> > module results reboot which is much more intrusive.
> 
> Kernel modules don't become "unloadable" unless there is a bug.  

That's exactly what I meant. The majority of the system crashes are due to 
kernel drivers.

> The "kill -9" can happen inadvertently even without any bugs in the FUSE 
> or the FUSE-fs. 

Not really. And if so then distros solve it, as some of them already did 
(e.g. during system shutdown). 

> > The OOM killer can be configured and if the fs still uses too much memory
> > then probably it's better to be killed/restarted with journaling support.
> > The important here would be the kernel finally fixing the non-sync behavior
> > when it clams to do so (see recent kernel threads).
> 
> You don't get the point.  Any process in the system can be using too much
> memory and trigger the OOM killer even when the FS is behaving just fine...

Actually you missed when I wrote "the OOM killer can be configured".

FUSE is a new thing which sometimes requires non-conventional thinking and 
minor adjustments here and there. These works are ongoing for some years 
now.
 
> I never said it was a FUSE problem!  It is a ntfsmount/ntfs-3g problem.  At
> least a few years ago someone was trying to use ntfsmount (or ntfs-3g I can't
> remember if you had already forked it then) on a 32MiB RAM embedded ARM box
> and he was running OOM when trying to list directories due to the ntfs/fuse
> implementation.  In the kernel ntfs driver that does not happen.

Listing a directory with over 100k files can be still an ENOMEM problem 
using 32 MB RAM but of course it's solvable. Nobody was interested so far.

	Szaka

--
NTFS-3G:  http://ntfs-3g.org
