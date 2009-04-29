Return-Path: <linux-kernel-owner+w=401wt.eu-S1757008AbZD2MJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008AbZD2MJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZD2MJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:09:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46457 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbZD2MJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:09:00 -0400
Date: Wed, 29 Apr 2009 13:08:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, Martin Knoblauch <knobi@knobisoft.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       tigran aivazian <tigran@aivazian.fsnet.co.uk>
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
Message-ID: <20090429120827.GI8633@ZenIV.linux.org.uk>
References: <409142.83316.qm@web32605.mail.mud.yahoo.com> <20090428182837.62c51f26.akpm@linux-foundation.org> <1240977096.5478.3.camel@marge.simson.net> <20090429011755.c141c599.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429011755.c141c599.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 01:17:55AM -0700, Andrew Morton wrote:

> > > > Questions remains: was this intentional? It breaks existing userspace and should therefore be considered a regression - right? On the other hand, it will never be a problem for RHEL-4/5 kernels, unless the change in 2.6.29 gets backported. Any ideas?
> > > 
> > > afaik that was unintentional and was probably a mistake.
> > > 
> > > I wonder how we did that.
> > 
> > <paste>
> > > [hotplug]# grep sysfs /proc/mounts
> > > none /sys sysfs rw,relatime 0 0
> > > /sys /sys sysfs rw,relatime 0 0
> > 
> > ___(I wonder how the heck that is accomplished)
> 
> Beats me.  I'm not seeing likely changes in fs/proc/base.c or around
> show_mountinfo().  Maybe sysfs broke in an ingenious way.  (hopefully
> cc's viro).

Er...  Somebody mounting sysfs twice?  From some init script and from
/etc/fstab, perhaps?  That definitely looks like two mount(2) had to
have been done to cause that...
