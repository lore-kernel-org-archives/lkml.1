Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZD2OTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZD2OTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 10:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZD2OSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 10:18:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:34370 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752239AbZD2OSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 10:18:50 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18YeshTRyoYGtKcNksUYnfAVzwOnv+tf9hn5gGkRB
	r1jH4remXTlAm6
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
From: Mike Galbraith <efault@gmx.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Martin Knoblauch <knobi@knobisoft.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       tigran aivazian <tigran@aivazian.fsnet.co.uk>
In-Reply-To: <20090429120827.GI8633@ZenIV.linux.org.uk>
References: <409142.83316.qm@web32605.mail.mud.yahoo.com>
	 <20090428182837.62c51f26.akpm@linux-foundation.org>
	 <1240977096.5478.3.camel@marge.simson.net>
	 <20090429011755.c141c599.akpm@linux-foundation.org>
	 <20090429120827.GI8633@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 16:18:45 +0200
Message-Id: <1241014725.15095.19.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-29 at 13:08 +0100, Al Viro wrote:
> On Wed, Apr 29, 2009 at 01:17:55AM -0700, Andrew Morton wrote:
> 
> > > > > Questions remains: was this intentional? It breaks existing userspace and should therefore be considered a regression - right? On the other hand, it will never be a problem for RHEL-4/5 kernels, unless the change in 2.6.29 gets backported. Any ideas?
> > > > 
> > > > afaik that was unintentional and was probably a mistake.
> > > > 
> > > > I wonder how we did that.
> > > 
> > > <paste>
> > > > [hotplug]# grep sysfs /proc/mounts
> > > > none /sys sysfs rw,relatime 0 0
> > > > /sys /sys sysfs rw,relatime 0 0
> > > 
> > > ___(I wonder how the heck that is accomplished)
> > 
> > Beats me.  I'm not seeing likely changes in fs/proc/base.c or around
> > show_mountinfo().  Maybe sysfs broke in an ingenious way.  (hopefully
> > cc's viro).
> 
> Er...  Somebody mounting sysfs twice?  From some init script and from
> /etc/fstab, perhaps?  That definitely looks like two mount(2) had to
> have been done to cause that...

Yeah, but how does one go about doing that?

Using mount -f, I can convince mount to succeed, but I still have only
one entry in /proc/mounts, despite what my mount binary imagines.

marge:..sys/vm # grep sysfs /proc/mounts
sysfs /sys sysfs rw,relatime 0 0

marge:..sys/vm # mount|grep sysfs
sysfs on /sys type sysfs (rw)
sys on /sys type sysfs (rw)
/sys on /sys type sysfs (rw)

	-Mike

