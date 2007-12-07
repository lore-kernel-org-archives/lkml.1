Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbXLGUum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbXLGUum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 15:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbXLGUud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 15:50:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:53279 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbXLGUud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 15:50:33 -0500
Subject: Re: [dm-devel] Re: 2.6.24-rc4-mm1
From: Kay Sievers <kay.sievers@vrfy.org>
To: Valdis.Kletnieks@vt.edu
Cc: device-mapper development <dm-devel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
In-Reply-To: <4192.1197059303@turing-police.cc.vt.edu>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	 <3941.1196941764@turing-police.cc.vt.edu>
	 <20071206040420.6c89c675.akpm@linux-foundation.org>
	 <4374.1196968688@turing-police.cc.vt.edu>
	 <20071206193843.GA25125@kroah.com>
	 <3ae72650712061404w170fc434nb1172e048216e139@mail.gmail.com>
	 <2955.1196982750@turing-police.cc.vt.edu>
	 <1196983444.2829.38.camel@lov.site>
	 <6593.1197051630@turing-police.cc.vt.edu>
	 <1197053069.5483.8.camel@lov.site>
	 <4192.1197059303@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Fri, 07 Dec 2007 21:49:41 +0100
Message-Id: <1197060581.5483.35.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18x0rfo3AGiQ1IAlWgIuwycPsP9DR9Hzp5uSDP
 uWuGNl9pEDcIu1UQ6tK8NlNhIF2rox+9y/Aj+aeyN68XryBXvO
 yulhC/MyzGBVVXGpCL9MTMVF4t414V1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-12-07 at 15:28 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 07 Dec 2007 19:44:29 +0100, Kay Sievers said:
> 
> > > Anybody got any brilliant ideas? :)
> > 
> > I guess it's nash again, which version is it?
> 
> Confirmed - nash again.  6.0.9 does not work, upgrading to 6.0.19 works.

Oh, cool!

I expected 6.0.9 to contain the fix though:
  http://lkml.org/lkml/2007/6/7/209

> init/Kconfig says this for SYSFS_DEPRECATED (which is where I got lead astray,
> as most of my laptop is Fedora Rawhide and therefor "released this week"):
> 
>           If you are using a distro that was released in 2006 or later,
>           it should be safe to say N here.
> 
> nash 6.0.9 came out in April 2007, and I suspect, but can't prove, that the
> relevant change was this one:
> 
> * Mon Aug 27 2007 Peter Jones <pjones@redhat.com> - 6.0.12-2
> - Fix segfault in scsi vpd probe code
> - Fix block device creation
> 
> That was just over 3 months ago.

Yeah right, even if it is fixed earlier, it's at least 6 months.

>  We probably need to fix that help text,
> but I admit not being sure what guidance we should give now....

Right, the help text needs to be changed. There are distros like Red Hat
which don't support !DEPRECATED at all today, so we should probably just
remove the date and add that to the help text.

On the other hand, we are currently considering making the DEPRECATED
behavior a boot-time option, so it can be changed on the kernel command
line instead of a compile option. There would only be a compile-time
default to set.
We will get to that after the current kobject work (~100 patches) in
Greg's tree is finished.

Thanks for your help and patience,
Kay

