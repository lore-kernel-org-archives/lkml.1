Return-Path: <linux-kernel-owner+w=401wt.eu-S1756954AbZEEWxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbZEEWxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 18:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbZEEWxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 18:53:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753402AbZEEWxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 18:53:13 -0400
Date: Tue, 5 May 2009 15:49:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Galbraith <efault@gmx.de>
Cc: viro@ZenIV.linux.org.uk, knobi@knobisoft.de, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, tigran@aivazian.fsnet.co.uk
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
Message-Id: <20090505154911.e0309a4f.akpm@linux-foundation.org>
In-Reply-To: <1241014725.15095.19.camel@marge.simson.net>
References: <409142.83316.qm@web32605.mail.mud.yahoo.com>
	<20090428182837.62c51f26.akpm@linux-foundation.org>
	<1240977096.5478.3.camel@marge.simson.net>
	<20090429011755.c141c599.akpm@linux-foundation.org>
	<20090429120827.GI8633@ZenIV.linux.org.uk>
	<1241014725.15095.19.camel@marge.simson.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 16:18:45 +0200
Mike Galbraith <efault@gmx.de> wrote:

> On Wed, 2009-04-29 at 13:08 +0100, Al Viro wrote:
> > On Wed, Apr 29, 2009 at 01:17:55AM -0700, Andrew Morton wrote:
> > 
> > > > > > Questions remains: was this intentional? It breaks existing userspace and should therefore be considered a regression - right? On the other hand, it will never be a problem for RHEL-4/5 kernels, unless the change in 2.6.29 gets backported. Any ideas?
> > > > > 
> > > > > afaik that was unintentional and was probably a mistake.
> > > > > 
> > > > > I wonder how we did that.
> > > > 
> > > > <paste>
> > > > > [hotplug]# grep sysfs /proc/mounts
> > > > > none /sys sysfs rw,relatime 0 0
> > > > > /sys /sys sysfs rw,relatime 0 0
> > > > 
> > > > ___(I wonder how the heck that is accomplished)
> > > 
> > > Beats me.  I'm not seeing likely changes in fs/proc/base.c or around
> > > show_mountinfo().  Maybe sysfs broke in an ingenious way.  (hopefully
> > > cc's viro).
> > 
> > Er...  Somebody mounting sysfs twice?  From some init script and from
> > /etc/fstab, perhaps?  That definitely looks like two mount(2) had to
> > have been done to cause that...
> 
> Yeah, but how does one go about doing that?
> 
> Using mount -f, I can convince mount to succeed, but I still have only
> one entry in /proc/mounts, despite what my mount binary imagines.
> 
> marge:..sys/vm # grep sysfs /proc/mounts
> sysfs /sys sysfs rw,relatime 0 0
> 
> marge:..sys/vm # mount|grep sysfs
> sysfs on /sys type sysfs (rw)
> sys on /sys type sysfs (rw)
> /sys on /sys type sysfs (rw)
> 

So /proc/mounts is OK and /etc/mtab is wrong?

Obvious next step is to strace `mount -f', see what's happening around
sys_mount(), please.

