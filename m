Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbYJEDL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbYJEDL2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 23:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYJEDLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 23:11:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:46625 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbYJEDLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 23:11:18 -0400
Message-ID: <48E82FDB.6020009@kernel.org>
Date: Sun, 05 Oct 2008 12:09:15 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Nick Warne <nick@ukfsn.org>
CC: linux-kernel@vger.kernel.org, D Bray <db1986@internetdog.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: New CD/DVD reports 'Can Play Audio    NO'
References: <20081004103355.407fc303@sauron.linicks.net>
In-Reply-To: <20081004103355.407fc303@sauron.linicks.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 05 Oct 2008 03:10:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing linux-ide)

Nick Warne wrote:
> Hi all,
> 
> Very strange issue.  I recently bought a new machine that came with a
> CD/DVD burner.  All functions normally, except I cannot play audio CD.
> 
> Information:
> 
> Slackware 12.1 running latest stable kernel 2.6.26.5
> 
> The drive is:
> 
> Vendor                      : Optiarc 
> Model                       : DVD RW AD-7200A 
> Revision                    : 1.06
> 
> Now, I have another drive (I purchased last year) that could play audio
> CD, so I installed that as master, and put the new drive as slave
> (old->hda new->hdb).  The old(er) drive can and does play audio OK.
> 
> I see this in /proc/sys/dev/cdrom/info:
> 
> drive name:             hdb     hda
> drive speed:            48      48
> drive # of slots:       1       1
> Can close tray:         1       1
> Can open tray:          1       1
> Can lock tray:          1       1
> Can change speed:       1       1
> Can select disk:        0       0
> Can read multisession:  1       1
> Can read MCN:           1       1
> Reports media changed:  1       1
> Can play audio:         0       1
> Can write CD-R:         1       1
> Can write CD-RW:        1       1
> Can read DVD:           1       1
> Can write DVD-R:        1       1
> Can write DVD-RAM:      1       1
> Can read MRW:           1       1
> Can write MRW:          1       1
> Can write RAM:          1       1
> 
> log/messages:
> Oct  4 09:27:01 sauron kernel: hda: UDMA/66 mode selected
> Oct  4 09:27:01 sauron kernel: hdb: UDMA/66 mode selected
> Oct  4 09:27:01 sauron kernel: hda: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW
> drive, 2048kB Cache
> Oct  4 09:27:01 sauron kernel: Uniform CD-ROM
> driver Revision: 3.20
> Oct  4 09:27:01 sauron kernel: hdb: ATAPI 48X
> DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
> 
> /log/syslog
> Oct  4 09:27:01 sauron kernel: hda: TSSTcorp CDDVDW SH-S202J, ATAPI
> CD/DVD-ROM drive
> Oct  4 09:27:01 sauron kernel: hdb: Optiarc DVD RW
> AD-7200A, ATAPI CD/DVD-ROM drive
> 
> 
> I have investigated this, but can't find any information at all - there
> are very few hits doing a search, but relevant pages I found are:
> 
> D. Bray filled a very verbose bug report of a similar issue:
> http://lists.debian.org/debian-user/2008/09/msg01696.html
> 
> A Gentoo user with the same drive reports another issue, but his CDROM
> info dump also reports this model cannot play audio CDs:
> http://bugs.gentoo.org/show_bug.cgi?id=218413
> 
> A Ubuntu user with the same drive also rpeorts audio CDs cannot be
> played:
> http://ubuntuforums.org/showthread.php?t=675812
> 
> 
> Myself and D. Bray had a discussion on this, and we both feel this
> could be a kernel issue.
> 
> I would be able to debug this issue if required.

Can you try libata driver and see whether anything is different?

-- 
tejun
