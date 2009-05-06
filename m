Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbZEFHzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbZEFHzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 03:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbZEFHzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 03:55:35 -0400
Received: from web32605.mail.mud.yahoo.com ([68.142.207.232]:24773 "HELO
	web32605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753512AbZEFHze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 03:55:34 -0400
Message-ID: <957194.27869.qm@web32605.mail.mud.yahoo.com>
X-YMail-OSG: L2G7pPkVM1nFo5k8wdtFGlzWUIR2SFEK.SZcnuExXWdJ_nREKh5P.6WOoGpLJlU0gSTfYrXs_imEIIVvki4XmBTh4Z513p3UcZHAymqTIGXJY_VbfwqLvq5fE9mMk3pIcUcRJ3AmzUvXqvOuLMcynbWlF2rLFmrswQLejZpX3HjbbcTUA1w3Kgs7oVVAVsvFu15.1FBE3.y1DNKHUM1v6cbw5Vu0dKkLSUEbcED70ZmHnnnvk594oglVJIuMfNSyq8z7QSKd5gdg0nrl25zXgh5ruRPp32Hn9jMdjCFE81LqNOUnv8Kl3AxIYALn6EhGbZaTzqwFNPWTxcsn_QMUl3VP
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.35 YahooMailWebService/0.7.289.1
References: <409142.83316.qm@web32605.mail.mud.yahoo.com>  <20090428182837.62c51f26.akpm@linux-foundation.org>  <1240977096.5478.3.camel@marge.simson.net>  <20090429011755.c141c599.akpm@linux-foundation.org>  <20090429120827.GI8633@ZenIV.linux.org.uk>  <1241014725.15095.19.camel@marge.simson.net>  <20090505154911.e0309a4f.akpm@linux-foundation.org> <1241585140.5196.28.camel@marge.simson.net>
Date: Wed, 6 May 2009 00:55:34 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
To: Mike Galbraith <efault@gmx.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: viro@ZenIV.linux.org.uk, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       tigran@aivazian.fsnet.co.uk
In-Reply-To: <1241585140.5196.28.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: Mike Galbraith <efault@gmx.de>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: viro@ZenIV.linux.org.uk; knobi@knobisoft.de; rjw@sisk.pl; linux-kernel@vger.kernel.org; tigran@aivazian.fsnet.co.uk
> Sent: Wednesday, May 6, 2009 6:45:40 AM
> Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
> 
> On Tue, 2009-05-05 at 15:49 -0700, Andrew Morton wrote:
> > On Wed, 29 Apr 2009 16:18:45 +0200
> > Mike Galbraith wrote:
> > 
> > > On Wed, 2009-04-29 at 13:08 +0100, Al Viro wrote:
> > > > On Wed, Apr 29, 2009 at 01:17:55AM -0700, Andrew Morton wrote:
> > > > 
> > > > > > > > Questions remains: was this intentional? It breaks existing 
> userspace and should therefore be considered a regression - right? On the other 
> hand, it will never be a problem for RHEL-4/5 kernels, unless the change in 
> 2.6.29 gets backported. Any ideas?
> > > > > > > 
> > > > > > > afaik that was unintentional and was probably a mistake.
> > > > > > > 
> > > > > > > I wonder how we did that.
> > > > > > 
> > > > > > 
> > > > > > > [hotplug]# grep sysfs /proc/mounts
> > > > > > > none /sys sysfs rw,relatime 0 0
> > > > > > > /sys /sys sysfs rw,relatime 0 0
> > > > > > 
> > > > > > ___(I wonder how the heck that is accomplished)
> > > > > 
> > > > > Beats me.  I'm not seeing likely changes in fs/proc/base.c or around
> > > > > show_mountinfo().  Maybe sysfs broke in an ingenious way.  (hopefully
> > > > > cc's viro).
> > > > 
> > > > Er...  Somebody mounting sysfs twice?  From some init script and from
> > > > /etc/fstab, perhaps?  That definitely looks like two mount(2) had to
> > > > have been done to cause that...
> > > 
> > > Yeah, but how does one go about doing that?
> > > 
> > > Using mount -f, I can convince mount to succeed, but I still have only
> > > one entry in /proc/mounts, despite what my mount binary imagines.
> > > 
> > > marge:..sys/vm # grep sysfs /proc/mounts
> > > sysfs /sys sysfs rw,relatime 0 0
> > > 
> > > marge:..sys/vm # mount|grep sysfs
> > > sysfs on /sys type sysfs (rw)
> > > sys on /sys type sysfs (rw)
> > > /sys on /sys type sysfs (rw)
> > > 
> > 
> > So /proc/mounts is OK and /etc/mtab is wrong?
> > 
> > Obvious next step is to strace `mount -f', see what's happening around
> > sys_mount(), please.
> 
> Well, there is no syscall with -f.
> 
> I was trying various mount options to see if I could find a way to
> create bogons that could confuse scripts.  I could create bogons
> in /etc/mtab with -f, or bogons in /proc/mounts by using --move.  I
> could re-create the exact reported data with a combination of mount -n
> and mount --move.  I could not get a double /proc/mounts entry without
> --move, and that seems unlikely to appear in boot scripts.  So I still
> wonder how the heck it was accomplished.
> 
> I also now wonder why you can --move mounts on top of one another, but
> beck with it, ignorance conserves braincells I may some day need :)
> 

 just to bring this back to my problem :-) Last week I reported that the "new" sysfs entry in /proc/mounts already comes out of initrd. Does this ring a bell?

http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/03048.html

Cheers
Martin

