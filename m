Return-Path: <linux-kernel-owner+w=401wt.eu-S1757714AbZKSBJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714AbZKSBJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 20:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757193AbZKSBJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 20:09:21 -0500
Received: from mail.sdinet.de ([78.47.32.153]:48781 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756061AbZKSBJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 20:09:20 -0500
Date: Thu, 19 Nov 2009 02:09:09 +0100 (CET)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: Dan Merillat <dan.merillat@gmail.com>
cc: Tomasz Chmielewski <mangoo@wpkg.org>, preining@logic.at, riel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.31 - very swap-happy with plenty of free RAM
In-Reply-To: <c0c067900911181640h64971680l4da14cdbe9fa6d59@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0911190200370.32644@aurora.sdinet.de>
References: <4B046AEA.80109@wpkg.org> <c0c067900911181640h64971680l4da14cdbe9fa6d59@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Nov 2009, Dan Merillat wrote:

> On Wed, Nov 18, 2009 at 4:45 PM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> 
> > I have a pretty powerful desktop machine with 8 GB RAM, fast disks with
> > RAID-1 etc.
> 
> > Every 10 minutes or so, machine is really unresponsive, load jumps to 10 or
> > 20. Mouse pointer jumps, it's impossible to change between windows etc.
> 
> This is the type of hefty workstation many of the core developers
> have, running similar workloads, so I'm somewhat surprised that the
> default VM settings have this kind of issue.
> 
> > Do a "swapoff -a", and everything is snappy and responsive as it should,
> > there are no more lags.
> 
> Yes, that's my exact finding.
> 
> Is this weird IO storm happening for anyone else with plenty of memory
> (for their taskload?)

For me it happend on my laptop. 3gb RAM, and a 1gb VMWare Windows-XP 
instance running, plus the usual like firefox, thunderbird, kde4.

Without running vmware it did not happen. And since I have now disabled 
barriers on the xfs /home partition (on luks crypto lvm) it also does 
not happen anymore.

The machine is currently 300mb in swap, together with >2gb shown by free 
as cached - as I just copied 10gb around nothing I worry about.

For me when it happened it looked like when a big bunch of data is to 
be commited to disk xfs seeks between superblock/journal and data
and syncs/waits between each step - reducing the write speed of the
disk from the normal >20mb/s to less than 2mb/s and also delaying all 
other disk-accesses in the meantime.

c'ya
sven

ps: I know with disabling barriers I sacrifice some data safety, but 
    better a usable and fast system than everything ultra-safe and
    slow - for safety in suche rare case there is a backup.

-- 
The lights are fading out, once more...
