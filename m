Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbYJEJ5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbYJEJ5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 05:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYJEJ5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 05:57:11 -0400
Received: from msr3.hinet.net ([168.95.4.103]:61348 "EHLO msr3.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbYJEJ5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 05:57:09 -0400
X-Greylist: delayed 715 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Oct 2008 05:57:08 EDT
Date: Sun, 5 Oct 2008 17:41:09 +0800
From: D Bray <db1986@internetdog.org>
To: Tejun Heo <tj@kernel.org>
Cc: Nick Warne <nick@ukfsn.org>, linux-kernel@vger.kernel.org,
       Bodo Eggert <7eggert@gmx.de>, Jens Axboe <jens.axboe@oracle.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: New CD/DVD reports 'Can Play Audio    NO'
Message-ID: <20081005094109.GA30725@internetdog.org>
Reply-To: db1986@internetdog.org
References: <20081004103355.407fc303@sauron.linicks.net> <48E82FDB.6020009@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E82FDB.6020009@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tejun,

while my situation resembles that of Nick below, there seem still to
be some unexplained observations remaining. See below.


On Sun, Oct 05, 2008 at 12:09:15PM +0900, Tejun Heo wrote:
> (cc'ing linux-ide)
> 
> Nick Warne wrote:
> > Hi all,
> > 
> > Very strange issue.  I recently bought a new machine that came with a
> > CD/DVD burner.  All functions normally, except I cannot play audio CD.
> > 
> > Information:
> > 
> > Slackware 12.1 running latest stable kernel 2.6.26.5
> > 
> > The drive is:
> > 
> > Vendor                      : Optiarc 
> > Model                       : DVD RW AD-7200A 
> > Revision                    : 1.06
> > 
> > Now, I have another drive (I purchased last year) that could play audio
> > CD, so I installed that as master, and put the new drive as slave
> > (old->hda new->hdb).  The old(er) drive can and does play audio OK.
> > 
> > I see this in /proc/sys/dev/cdrom/info:
> > 
> > drive name:             hdb     hda
> > drive speed:            48      48
> > drive # of slots:       1       1
> > Can close tray:         1       1
> > Can open tray:          1       1
> > Can lock tray:          1       1
> > Can change speed:       1       1
> > Can select disk:        0       0
> > Can read multisession:  1       1
> > Can read MCN:           1       1
> > Reports media changed:  1       1
> > Can play audio:         0       1
> > Can write CD-R:         1       1
> > Can write CD-RW:        1       1
> > Can read DVD:           1       1
> > Can write DVD-R:        1       1
> > Can write DVD-RAM:      1       1
> > Can read MRW:           1       1
> > Can write MRW:          1       1
> > Can write RAM:          1       1
> > 
> > log/messages:
> > Oct  4 09:27:01 sauron kernel: hda: UDMA/66 mode selected
> > Oct  4 09:27:01 sauron kernel: hdb: UDMA/66 mode selected
> > Oct  4 09:27:01 sauron kernel: hda: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW
> > drive, 2048kB Cache
> > Oct  4 09:27:01 sauron kernel: Uniform CD-ROM
> > driver Revision: 3.20
> > Oct  4 09:27:01 sauron kernel: hdb: ATAPI 48X
> > DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
> > 
> > /log/syslog
> > Oct  4 09:27:01 sauron kernel: hda: TSSTcorp CDDVDW SH-S202J, ATAPI
> > CD/DVD-ROM drive
> > Oct  4 09:27:01 sauron kernel: hdb: Optiarc DVD RW
> > AD-7200A, ATAPI CD/DVD-ROM drive
> > 
> > 
> > I have investigated this, but can't find any information at all - there
> > are very few hits doing a search, but relevant pages I found are:
> > 
> > D. Bray filled a very verbose bug report of a similar issue:
> > http://lists.debian.org/debian-user/2008/09/msg01696.html

I'll summarise its pertinent crux here. In short, a year-old CD/DVD
drive used to play audio CDs as well as encrypted DVDs. A small
upgrade was performed on the box (including a kernel change), and then
these functions failed. The rest of the drive's functionality remained
unaffected. Subsequently, another (ie third) kernel was installed, and
the drive's full functionality was restored. 
Furthermore, the drive appears to report different capabilities to
the different kernels:

1. The debian Etch kernel (linux-image-2.6.18-5-686 2.6.18.dfsg.1-13)
played audio CDROMs and encrypted DVDs. (I do not have its
/proc/sys/dev/cdrom/info output.);

2. The debian security update to this kernel
(linux-image-2.6.18-5-686_2.6.18.dfsg.1-13etch6_i386.deb) did not play
audio CDROMs or encrypted DVDs, and reported no-audio in
/proc/sys/dev/cdrom/info;

3. 2.6.26.5, built locally to match the 2.6.18-5 configuration, plays
audio CDs & encrypted DVDs, and reports with-audio in /proc.

As my post to the debian-user list shows, numerous other possibilities
were explored before the kernel was focused on -- and even then, it
was focused on as a work-around, not necessarily as a culprit.





> > A Gentoo user with the same drive reports another issue, but his CDROM
> > info dump also reports this model cannot play audio CDs:
> > http://bugs.gentoo.org/show_bug.cgi?id=218413
> > 
> > A Ubuntu user with the same drive also rpeorts audio CDs cannot be
> > played:
> > http://ubuntuforums.org/showthread.php?t=675812
> > 
> > 
> > Myself and D. Bray had a discussion on this, and we both feel this
> > could be a kernel issue.

Nick believes his situation to have been different -- and it was
resolved by a patch from Bodo Eggert which had the ide-cd driver
ignore Nick's drive's misbehaviour. The latter is reported to have
been due to its firmware's poor implementation. (I & Nick use
different drives.)

But this leaves my situation in which the same drive appears to be
reporting different capabilities to different kernels.

Also, another symptom in my case was that unencrypted DVDs would play
(even with "Can read DVD: 0"), but not encrypted ones.

It seems to me that there is something going awry in the capabilities
query between the driver and the device, whether caused by the
device's f/w or by the driver. However, if someone has a dismissive
explanation of the above, I'll still be happy! :-)

Thanks everyone.

regards,
DB







> > 
> > I would be able to debug this issue if required.
> 
> Can you try libata driver and see whether anything is different?
> 
> -- 
> tejun
