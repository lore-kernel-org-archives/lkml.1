Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbZD1WCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbZD1WCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 18:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbZD1WCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 18:02:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33778 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbZD1WCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 18:02:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: [Bug #13178] Booting very slow
Date: Wed, 29 Apr 2009 00:01:47 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <209795.21710.qm@web32607.mail.mud.yahoo.com>
In-Reply-To: <209795.21710.qm@web32607.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904290001.47757.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 April 2009, Martin Knoblauch wrote:
> 
> ----- Original Message ----
> 
> > From: Martin Knoblauch <spamtrap@knobisoft.de>
> > To: Rafael J. Wysocki <rjw@sisk.pl>; Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> > Cc: Kernel Testers List <kernel-testers@vger.kernel.org>
> > Sent: Monday, April 27, 2009 9:18:53 AM
> > Subject: Re: [Bug #13178] Booting very slow
> > 
> > ----- Original Message ----
> > 
> > > From: Rafael J. Wysocki 
> > > To: Linux Kernel Mailing List 
> > > Cc: Kernel Testers List ; Martin Knoblauch 
> > 
> > > Sent: Sunday, April 26, 2009 11:46:31 AM
> > > Subject: [Bug #13178] Booting very slow
> > > 
> > > This message has been generated automatically as a part of a report
> > > of regressions introduced between 2.6.28 and 2.6.29.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> > > be listed and let me know (either way).
> > > 
> > > 
> > > Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=13178
> > > Subject        : Booting very slow
> > > Submitter    : Martin Knoblauch 
> > > Date        : 2009-04-24 12:45 (3 days old)
> > > References    : http://marc.info/?l=linux-kernel&m=124057716231773&w=4
> > 
> > Not really sure whether this is a real regression. Between 2.6.28 and 2.6.29 the 
> > content of /proc/mounts for sysfs changed from
> > 
> > /sys /sys sysfs rw 0 0
> > 
> > to
> > 
> > none /sys sysfs rw 0 0
> > 
> > 
> > This breaks RHEL-4.3 userland which parses /proc/mounts in the firmware hotplug 
> > agent to find the mount-point for sysfs. As a result firmware loading started to 
> > fail in 2.6.29. There is a simple fix in the /etc/hotplug/firmware.agent script 
> > (just assume /sys as it is done elsewhere).
> > 
> > Your call.
> > 
> > Cheers
> > Martin
> 
>  Actually I have to correct myself. The reason for the failure to parse /proc/mounts for "sysfs" is that there are two lines:
> 
> [hotplug]# uname -a
> Linux lpsdm52 2.6.30-rc3-git2-nfs_ra #3 SMP Mon Apr 27 10:21:31 CEST 2009 x86_64 x86_64 x86_64 GNU/Linux
> [hotplug]# grep sysfs /proc/mounts
> none /sys sysfs rw,relatime 0 0
> /sys /sys sysfs rw,relatime 0 0
> 
>  This breaks the "firmware.agent" /sys-parsing code. There still exists the simple fix to userspace, but I now think that this is a real regression that should be fixed.

Thanks for the update.

Rafael
