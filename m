Return-Path: <linux-kernel-owner+w=401wt.eu-S1761552AbZE1JOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761552AbZE1JOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 05:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbZE1JOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 05:14:45 -0400
Received: from web32604.mail.mud.yahoo.com ([68.142.207.231]:23478 "HELO
	web32604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755220AbZE1JOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 05:14:44 -0400
Message-ID: <170150.72851.qm@web32604.mail.mud.yahoo.com>
X-YMail-OSG: ZuVRYtoVM1kxlgJAXzz4KMnQNTbOUcRVgHQ2.HgCHE95R.2FoLW9118SCta.3_UjJXbz7g3L_UgCcse5pYY7YpI5iC2akQbTJBbqDDEx8VPg0U7cXl89tRcOpj3SAwrOsL9ifXpFJ4CeVM1qgBJMA6rKMCIg3suzuS9hq1YSXTOhARKh19QZCn3Eowuqc1NyGEY3oHKAm58IznISWlxqyn0psmR8oYV1cKTi03Os5KJ_IOa1TLnynw1FLzaYo1o2YZjWhu20_hDuhPEVHuh7W6jy9JheVZox2znwPd.Y0k1PPA--
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.43 YahooMailWebService/0.7.289.10
References: <488605.71443.qm@web32605.mail.mud.yahoo.com> <20090527133125.c36381b5.akpm@linux-foundation.org> <ac3eb2510905271356n1b01f273jca1f7aa8fc65c78b@mail.gmail.com>
Date: Thu, 28 May 2009 02:14:46 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
To: Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: efault@gmx.de, viro@zeniv.linux.org.uk, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, shemminger@vyatta.com,
       jbarnes@virtuousgeek.org, matthew@wil.cx, mike.miller@hp.com
In-Reply-To: <ac3eb2510905271356n1b01f273jca1f7aa8fc65c78b@mail.gmail.com>
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
> From: Kay Sievers <kay.sievers@vrfy.org>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: Martin Knoblauch <knobi@knobisoft.de>; efault@gmx.de; viro@zeniv.linux.org.uk; rjw@sisk.pl; linux-kernel@vger.kernel.org; shemminger@vyatta.com; jbarnes@virtuousgeek.org; matthew@wil.cx; mike.miller@hp.com
> Sent: Wednesday, May 27, 2009 10:56:45 PM
> Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
> 
> On Wed, May 27, 2009 at 22:31, Andrew Morton wrote:
> > On Wed, 27 May 2009 04:25:57 -0700 (PDT)
> > Martin Knoblauch wrote:
> >
> >>  FWIW, I compiled the CCISS driver into the kernel. This makes the second 
> "/sys" line in /proc/mounts go away, dmesg attached. But does it prove anything? 
> The initialization of the CCISS hardware now happens about 2 seconds earlier in 
> the bootup sequence. Does this hint to a problem with CCISS, or just confirms 
> that the whole issue is really timing dependent? Anyway, I add Mike to CC.
> >>
> >
> > It seems that the PCI change caused timing changes which triggered a
> > udev/sysfs/whatever problem, which manifests as the duplicated
> > /proc/mounts entry to turn up.
> >
> > What we don't know (afaik) is why the kernel permitted two entries in
> > /proc/mounts.  That might be a bug.
> >
> > It could be that if dual /proc/mounts problem gets fixed, everything
> > works OK - by intent or by accident, the userspace startup scripts may
> > then work acceptably.
> >
> > I think Al asked you a few questions around the behaviour of mount(8)
> > and the mount syscall, so we could delve further into why /proc/mounts
> > is getting mucked up.  Did you end up running those tests?
> 

 I do not recall any questions from Al. If he asked, I am pretty sure I answered :-)

> I expect the duplicate comes from a left-over mount in initramfs which
> isn't a duplicate in the sense of a bug in vfs or mount or anything. I
> guess, it is just still mounted in the initial kernel rootfs, below
> the root from the disk. It could be that a umount from initramfs did
> go wrong because of a changed timing.
> 

 This is what I suspect as well. I know for sure that the first sysfs-line in /proc/mounts

| none /sys sysfs rw 0 0

is already there (2.6.29-rc1 and up) when entering startup-skripts. It is supposed to be unmounted before, but something seems to prevent it. I have idea how to capture debug output from the initrd/init script :-(

Cheers
Martin

