Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbZD2JhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbZD2JhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbZD2Jgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:36:41 -0400
Received: from web32608.mail.mud.yahoo.com ([68.142.207.235]:49066 "HELO
	web32608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756308AbZD2Jgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:36:39 -0400
Message-ID: <313906.21818.qm@web32608.mail.mud.yahoo.com>
X-YMail-OSG: f6dwXPYVM1md7mfFB_p4vgoGWUst7pkep_23MpMJJN39tZUlETciBiV4E_cJqaFoGd8o0BKdMwO5Qwxo_NkAOLgqUvHTJa3smGJvuPjifixS8gOJ6MzalxPrwBsukAAPcwPRMUf6TYrl0GlvmvyE5pNlzwIjJ0SnCoJ5xqjQsFRKJ4sp6DAAo9xgmMJnQc.dWhZ60CtaF5xSWsdqLEvl2vvfE1JH_boRDak3PgbquZZXEjqBSdLD9c.cFyzkbmMPmpyh5CSRlwEgKcR3135Df1yO9XG4PlFWZRaHjWHQhhpztK8SblV.
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.35 YahooMailWebService/0.7.289.1
References: <409142.83316.qm@web32605.mail.mud.yahoo.com> <20090428182837.62c51f26.akpm@linux-foundation.org> <1240977096.5478.3.camel@marge.simson.net> <20090429011755.c141c599.akpm@linux-foundation.org>
Date: Wed, 29 Apr 2009 02:36:39 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
To: Andrew Morton <akpm@linux-foundation.org>, Mike Galbraith <efault@gmx.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       tigran aivazian <tigran@aivazian.fsnet.co.uk>,
       Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <20090429011755.c141c599.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




 ------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de



----- Original Message ----
> From: Andrew Morton <akpm@linux-foundation.org>
> To: Mike Galbraith <efault@gmx.de>
> Cc: Martin Knoblauch <knobi@knobisoft.de>; Rafael J. Wysocki <rjw@sisk.pl>; linux-kernel@vger.kernel.org; tigran aivazian <tigran@aivazian.fsnet.co.uk>; Al Viro <viro@zeniv.linux.org.uk>
> Sent: Wednesday, April 29, 2009 10:17:55 AM
> Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
> 
> On Wed, 29 Apr 2009 05:51:36 +0200 Mike Galbraith wrote:
> 
> > On Tue, 2009-04-28 at 18:28 -0700, Andrew Morton wrote: 
> > > On Fri, 24 Apr 2009 05:45:19 -0700 (PDT) Martin Knoblauch 
> wrote:
> > > 
> > > > 
> > > > 
> > > >  OK, I just found the reason for both intel-ucode and tg3 failures. 
> Apparently between 2.6.28 and 2.6.29 the mount of sysfs has subtely changed 
> from:
> > > > 
> > > > /sys /sys sysfs rw 0 0
> > > > 
> > > > to:
> > > > 
> > > > none /sys sysfs rw,relatime 0 0
> > > 
> > > I assume that you're referring to the contents of /proc/mounts?
> > > 
> > > >  The "none" breaks the RHEL-4 provided hotplug script "firmware.agent" 
> when it tries to parse the mount point for "/sys". As a result, the firmware 
> loading is never properly finished and the driver(s) just timeout on the value  
> in /sys/class/firmware/timeout. Bingo. Simple fix in user-pace possible - cool 
> down Martin :-)
> > > > 
> > > > Questions remains: was this intentional? It breaks existing userspace and 
> should therefore be considered a regression - right? On the other hand, it will 
> never be a problem for RHEL-4/5 kernels, unless the change in 2.6.29 gets 
> backported. Any ideas?
> > > 
> > > afaik that was unintentional and was probably a mistake.
> > > 
> > > I wonder how we did that.
> > 
> > 
> > > [hotplug]# grep sysfs /proc/mounts
> > > none /sys sysfs rw,relatime 0 0
> > > /sys /sys sysfs rw,relatime 0 0
> > 
> > ___(I wonder how the heck that is accomplished)
> > 
> 
> Beats me.  I'm not seeing likely changes in fs/proc/base.c or around
> show_mountinfo().  Maybe sysfs broke in an ingenious way.  (hopefully
> cc's viro).
> 
> Displaying relatime seems a bit pointless too.

 Actually, relatime is added in 2.6.30. In 2.6.29 I only see the duplicate lines.

Cheers
Martin

