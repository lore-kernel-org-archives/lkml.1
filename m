Return-Path: <linux-kernel-owner+w=401wt.eu-S935500AbYBUXG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935500AbYBUXG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbYBUXGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:06:49 -0500
Received: from smtp-out113.alice.it ([85.37.17.113]:4882 "EHLO
	smtp-out113.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbYBUXGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:06:48 -0500
X-Greylist: delayed 976 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2008 18:06:47 EST
Date: Thu, 21 Feb 2008 23:50:49 +0000
From: Giuliano Pochini <pochini@shiny.it>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       zdenek.kabelac@gmail.com
Subject: Re: Disk schedulers
Message-Id: <20080221235049.3742484f.pochini@shiny.it>
In-Reply-To: <20080220184842.GA4867@ics.muni.cz>
References: <20080214162104.GA5347@ics.muni.cz>
	<20080216172048.GB3979@ucw.cz>
	<20080220184842.GA4867@ics.muni.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; powerpc-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Feb 2008 22:49:23.0593 (UTC) FILETIME=[00D95790:01C874DC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 19:48:42 +0100
Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:

> On Sat, Feb 16, 2008 at 05:20:49PM +0000, Pavel Machek wrote:
> > Is cat /dev/zero > file enough to reproduce this?
> 
> yes.
> 
> 
> > ext3 filesystem?
> 
> yes.
>  
> > Will cat /etc/passwd work while machine is unresponsive?
> 
> yes.
> 
> while find does not work:
> time find /
> /
> /etc
> /etc/manpath.config
> /etc/update-manager
> /etc/update-manager/release-upgrades
> /etc/gshadow-
> /etc/inputrc
> /etc/openalrc
> /etc/bonobo-activation
> /etc/bonobo-activation/bonobo-activation-config.xml
> /etc/gnome-vfs-2.0
> /etc/gnome-vfs-2.0/modules
> /etc/gnome-vfs-2.0/modules/obex-module.conf
> /etc/gnome-vfs-2.0/modules/extra-modules.conf
> /etc/gnome-vfs-2.0/modules/theme-method.conf
> /etc/gnome-vfs-2.0/modules/font-method.conf
> /etc/gnome-vfs-2.0/modules/default-modules.conf
> ^C
> 
> real	0m7.982s
> user	0m0.003s
> sys	0m0.000s
> 
> 
> i.e., it took 8 seconds to list just 17 dir entries.

It also happens when I'm writing to a slow external disk.
Documentation/block/biodoc.txt says:

"Per-queue granularity unplugging (still a Todo) may help reduce some of
the concerns with just a single tq_disk flush approach. Something like
blk_kick_queue() to unplug a specific queue (right away ?) or optionally,
all queues, is in the plan."

If I understand correctly, there is only one "plug" in common for all
devices. It may explain why when a queue is full, access to other devices
is also blocked.



--
Giuliano.
