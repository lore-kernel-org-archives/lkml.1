Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbZITReH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbZITReH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 13:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923AbZITReF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 13:34:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38214 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054AbZITRdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 13:33:55 -0400
Date: Sun, 20 Sep 2009 19:33:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied
	(Was: Re: [PATCH] Remove broken by design and by implementation
	devtmpfs maintenance disaster)
Message-ID: <20090920173319.GA18675@elte.hu>
References: <ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com> <alpine.LFD.2.01.0909171709410.4950@localhost.localdomain> <1253238637.4071.10.camel@yio.site> <20090918060210.GC7104@kroah.com> <alpine.LFD.2.01.0909180717380.4950@localhost.localdomain> <20090918150541.GB9307@kroah.com> <ac3eb2510909180837p195704e4y907e6f564acf6efd@mail.gmail.com> <ac3eb2510909181235m33846928sa8c790758c66233@mail.gmail.com> <20090918195005.GA11726@elte.hu> <21d7e9970909191843l6fbb835bme509c18cedfd728c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970909191843l6fbb835bme509c18cedfd728c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1073]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Airlie <airlied@gmail.com> wrote:

> > Self-contained /dev is great, udev is a total PITA on older distros 
> > (on this box it sometimes takes 3 minutes for udev to boot ...) so 
> > turning on devtmpfs and getting something functional in exchange is 
> > a big selling point IMO.
> 
> udev taking 3 minutes usually means you have a kernel driver bug, udev 
> doesn't have a sleep for 3 minutes, it loads drivers and usually waits 
> for them to finish. Since someone decided to merge a stupid floppy PNP 
> match I've seen a lot of floppyless machines hit a 30sec udev delay. 
> so many that we disabled the pnp floppy on Fedora.

i have an old distro with old udev on this testbox, and it's absolutely 
unfeasible to upgrade udev on that distro, so deeply is it entrenched in 
various user-space package dependencies.

And that's the basic problem that is solved so well via devtmpfs: kernel 
and device enumeration should go hand in hand. Practice has shown us 
that in reality it's not possible to upgrade udev on an old distro, and 
if i boot a new kernel on it then old udev throws a hissy fit like this:

[ please scroll down to the bottom of this mail - my comments continue 
  there: ]

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INIT: version 2.86 booting
		Welcome to Fedora 
		Press 'I' to enter interactive startup.
Setting clock  (localtime): Sun Sep 20 13:00:41 CEST 2009 [  OK  ]
Starting udev: [   33.864015] fgrep used greatest stack depth: 3000 bytes left
mount: wrong fs type, bad option, bad superblock on none,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

mkdir: cannot create directory `/dev/pts': File exists
mkdir: cannot create directory `/dev/shm': File exists
ln: cannot remove `/dev/fd': Read-only file system
ln: cannot remove `/dev/stdin': Read-only file system
ln: cannot remove `/dev/stdout': Read-only file system
ln: cannot remove `/dev/stderr': Read-only file system
ln: cannot remove `/dev/core': Read-only file system
MAKEDEV: error making /dev/fuse: Read-only file system
MAKEDEV: error making /dev/tty1: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
scsi_id[2315]: scsi_id: unable to access parent device of '/bus/usb/drivers/st5481_usb'
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2376]: udev_node_mknod: mknod(/dev/.tmp-7-0.udev-tmp, 060600, 7, 0) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2380]: udev_node_mknod: mknod(/dev/.tmp-7-1.udev-tmp, 060600, 7, 1) failed: Read-only file system
udevd-event[2380]: unlink_secure: chown(/dev/.tmp-7-1, 0, 0) failed: No such file or directory
udevd-event[2380]: unlink_secure: chmod(/dev/.tmp-7-1, 0000) failed: No such file or directory
udevd-event[2380]: unlink_secure: unlink(/dev/.tmp-7-1) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2376]: unlink_secure: chown(/dev/.tmp-7-0, 0, 0) failed: No such file or directory
udevd-event[2376]: unlink_secure: chmod(/dev/.tmp-7-0, 0000) failed: No such file or directory
udevd-event[2376]: unlink_secure: unlink(/dev/.tmp-7-0) failed: Read-only file system
udevd-event[2385]: udev_node_mknod: mknod(/dev/.tmp-7-2.udev-tmp, 060600, 7, 2) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2388]: udev_node_mknod: mknod(/dev/.tmp-7-3.udev-tmp, 060600, 7, 3) failed: Read-only file system
udevd-event[2385]: unlink_secure: chown(/dev/.tmp-7-2, 0, 0) failed: No such file or directory
udevd-event[2385]: unlink_secure: chmod(/dev/.tmp-7-2, 0000) failed: No such file or directory
udevd-event[2385]: unlink_secure: unlink(/dev/.tmp-7-2) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2388]: unlink_secure: chown(/dev/.tmp-7-3, 0, 0) failed: No such file or directory
udevd-event[2388]: unlink_secure: chmod(/dev/.tmp-7-3, 0000) failed: No such file or directory
udevd-event[2388]: unlink_secure: unlink(/dev/.tmp-7-3) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2397]: udev_node_mknod: mknod(/dev/.tmp-7-5.udev-tmp, 060600, 7, 5) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2397]: unlink_secure: chown(/dev/.tmp-7-5, 0, 0) failed: No such file or directory
udevd-event[2397]: unlink_secure: chmod(/dev/.tmp-7-5, 0000) failed: No such file or directory
udevd-event[2397]: unlink_secure: unlink(/dev/.tmp-7-5) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2395]: udev_node_mknod: mknod(/dev/.tmp-7-4.udev-tmp, 060600, 7, 4) failed: Read-only file system
udevd-event[2402]: udev_node_mknod: mknod(/dev/.tmp-7-6.udev-tmp, 060600, 7, 6) failed: Read-only file system
udevd-event[2409]: udev_node_mknod: mknod(/dev/.tmp-43-0.udev-tmp, 060600, 43, 0) failed: Read-only file system
udevd-event[2405]: udev_node_mknod: mknod(/dev/.tmp-7-7.udev-tmp, 060600, 7, 7) failed: Read-only file system
udevd-event[2419]: udev_node_mknod: mknod(/dev/.tmp-43-10.udev-tmp, 060600, 43, 10) failed: Read-only file system
udevd-event[2380]: delete_path: rmdir(/dev/.udev/names/loop1) failed: Read-only file system
udevd-event[2380]: udev_node_mknod: chmod(/dev/loop1, 060640) failed: Read-only file system
udevd-event[2380]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2floop1': File exists
udevd-event[2405]: unlink_secure: chown(/dev/.tmp-7-7, 0, 0) failed: No such file or directory
udevd-event[2405]: unlink_secure: chmod(/dev/.tmp-7-7, 0000) failed: No such file or directory
udevd-event[2405]: unlink_secure: unlink(/dev/.tmp-7-7) failed: Read-only file system
udevd-event[2402]: unlink_secure: chown(/dev/.tmp-7-6, 0, 0) failed: No such file or directory
udevd-event[2402]: unlink_secure: chmod(/dev/.tmp-7-6, 0000) failed: No such file or directory
udevd-event[2402]: unlink_secure: unlink(/dev/.tmp-7-6) failed: Read-only file system
udevd-event[2395]: unlink_secure: chown(/dev/.tmp-7-4, 0, 0) failed: No such file or directory
udevd-event[2409]: unlink_secure: chown(/dev/.tmp-43-0, 0, 0) failed: No such file or directory
udevd-event[2395]: unlink_secure: chmod(/dev/.tmp-7-4, 0000) failed: No such file or directory
udevd-event[2409]: unlink_secure: chmod(/dev/.tmp-43-0, 0000) failed: No such file or directory
udevd-event[2395]: unlink_secure: unlink(/dev/.tmp-7-4) failed: Read-only file system
udevd-event[2409]: unlink_secure: unlink(/dev/.tmp-43-0) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2414]: udev_node_mknod: mknod(/dev/.tmp-43-1.udev-tmp, 060600, 43, 1) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2419]: unlink_secure: chown(/dev/.tmp-43-10, 0, 0) failed: No such file or directory
udevd-event[2419]: unlink_secure: chmod(/dev/.tmp-43-10, 0000) failed: No such file or directory
udevd-event[2419]: unlink_secure: unlink(/dev/.tmp-43-10) failed: Read-only file system
udevd-event[2376]: delete_path: rmdir(/dev/.udev/names/loop0) failed: Read-only file system
udevd-event[2376]: udev_node_mknod: chmod(/dev/loop0, 060640) failed: Read-only file system
udevd-event[2414]: unlink_secure: chown(/dev/.tmp-43-1, 0, 0) failed: No such file or directory
udevd-event[2414]: unlink_secure: chmod(/dev/.tmp-43-1, 0000) failed: No such file or directory
udevd-event[2414]: unlink_secure: unlink(/dev/.tmp-43-1) failed: Read-only file system
udevd-event[2423]: udev_node_mknod: mknod(/dev/.tmp-43-11.udev-tmp, 060600, 43, 11) failed: Read-only file system
udevd-event[2376]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2floop0': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2423]: unlink_secure: chown(/dev/.tmp-43-11, 0, 0) failed: No such file or directory
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2423]: unlink_secure: chmod(/dev/.tmp-43-11, 0000) failed: No such file or directory
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2423]: unlink_secure: unlink(/dev/.tmp-43-11) failed: Read-only file system
udevd-event[2432]: udev_node_mknod: mknod(/dev/.tmp-43-12.udev-tmp, 060600, 43, 12) failed: Read-only file system
udevd-event[2388]: delete_path: rmdir(/dev/.udev/names/loop3) failed: Read-only file system
udevd-event[2388]: udev_node_mknod: chmod(/dev/loop3, 060640) failed: Read-only file system
udevd-event[2385]: delete_path: rmdir(/dev/.udev/names/loop2) failed: Read-only file system
udevd-event[2402]: delete_path: rmdir(/dev/.udev/names/loop6) failed: Read-only file system
udevd-event[2395]: delete_path: rmdir(/dev/.udev/names/loop4) failed: Read-only file system
udevd-event[2397]: delete_path: rmdir(/dev/.udev/names/loop5) failed: Read-only file system
udevd-event[2405]: delete_path: rmdir(/dev/.udev/names/loop7) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2432]: unlink_secure: chown(/dev/.tmp-43-12, 0, 0) failed: No such file or directory
udevd-event[2432]: unlink_secure: chmod(/dev/.tmp-43-12, 0000) failed: No such file or directory
udevd-event[2409]: delete_path: rmdir(/dev/.udev/names/nbd0) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2419]: delete_path: rmdir(/dev/.udev/names/nbd10) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2414]: delete_path: rmdir(/dev/.udev/names/nbd1) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2385]: udev_node_mknod: chmod(/dev/loop2, 060640) failed: Read-only file system
udevd-event[2402]: udev_node_mknod: chmod(/dev/loop6, 060640) failed: Read-only file system
udevd-event[2395]: udev_node_mknod: chmod(/dev/loop4, 060640) failed: Read-only file system
udevd-event[2397]: udev_node_mknod: chmod(/dev/loop5, 060640) failed: Read-only file system
udevd-event[2405]: udev_node_mknod: chmod(/dev/loop7, 060640) failed: Read-only file system
udevd-event[2440]: udev_node_mknod: mknod(/dev/.tmp-43-13.udev-tmp, 060600, 43, 13) failed: Read-only file system
udevd-event[2432]: unlink_secure: unlink(/dev/.tmp-43-12) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2440]: unlink_secure: chown(/dev/.tmp-43-13, 0, 0) failed: No such file or directory
udevd-event[2440]: unlink_secure: chmod(/dev/.tmp-43-13, 0000) failed: No such file or directory
udevd-event[2440]: unlink_secure: unlink(/dev/.tmp-43-13) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2409]: udev_node_mknod: chmod(/dev/nbd0, 060640) failed: Read-only file system
udevd-event[2449]: udev_node_mknod: mknod(/dev/.tmp-43-15.udev-tmp, 060600, 43, 15) failed: Read-only file system
udevd-event[2474]: udev_node_mknod: mknod(/dev/.tmp-43-7.udev-tmp, 060600, 43, 7) failed: Read-only file system
udevd-event[2445]: udev_node_mknod: mknod(/dev/.tmp-43-14.udev-tmp, 060600, 43, 14) failed: Read-only file system
udevd-event[2388]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2floop3': File exists
udevd-event[2385]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2floop2': File exists
udevd-event[2402]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2floop6': File exists
udevd-event[2397]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2floop5': File exists
udevd-event[2419]: udev_node_mknod: chmod(/dev/nbd10, 060640) failed: Read-only file system
udevd-event[2453]: udev_node_mknod: mknod(/dev/.tmp-43-2.udev-tmp, 060600, 43, 2) failed: Read-only file system
udevd-event[2414]: udev_node_mknod: chmod(/dev/nbd1, 060640) failed: Read-only file system
udevd-event[2459]: udev_node_mknod: mknod(/dev/.tmp-43-4.udev-tmp, 060600, 43, 4) failed: Read-only file system
udevd-event[2455]: udev_node_mknod: mknod(/dev/.tmp-43-3.udev-tmp, 060600, 43, 3) failed: Read-only file system
udevd-event[2465]: udev_node_mknod: mknod(/dev/.tmp-43-5.udev-tmp, 060600, 43, 5) failed: Read-only file system
udevd-event[2467]: udev_node_mknod: mknod(/dev/.tmp-43-6.udev-tmp, 060600, 43, 6) failed: Read-only file system
udevd-event[2423]: delete_path: rmdir(/dev/.udev/names/nbd11) failed: Read-only file system
udevd-event[2423]: udev_node_mknod: chmod(/dev/nbd11, 060640) failed: Read-only file system
udevd-event[2395]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2floop4': File exists
udevd-event[2405]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2floop7': File exists
udevd-event[2409]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fnbd0': File exists
udevd-event[2419]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fnbd10': File exists
udevd-event[2414]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fnbd1': File exists
udevd-event[2423]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fnbd11': File exists
udevd-event[2432]: delete_path: rmdir(/dev/.udev/names/nbd12) failed: Read-only file system
udevd-event[2432]: udev_node_mknod: chmod(/dev/nbd12, 060640) failed: Read-only file system
udevd-event[2432]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fnbd12': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2453]: unlink_secure: chown(/dev/.tmp-43-2, 0, 0) failed: No such file or directory
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2453]: unlink_secure: chmod(/dev/.tmp-43-2, 0000) failed: No such file or directory
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2453]: unlink_secure: unlink(/dev/.tmp-43-2) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2459]: unlink_secure: chown(/dev/.tmp-43-4, 0, 0) failed: No such file or directory
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2459]: unlink_secure: chmod(/dev/.tmp-43-4, 0000) failed: No such file or directory
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2459]: unlink_secure: unlink(/dev/.tmp-43-4) failed: Read-only file system
udevd-event[2445]: unlink_secure: chown(/dev/.tmp-43-14, 0, 0) failed: No such file or directory
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2445]: unlink_secure: chmod(/dev/.tmp-43-14, 0000) failed: No such file or directory
udevd-event[2445]: unlink_secure: unlink(/dev/.tmp-43-14) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2449]: unlink_secure: chown(/dev/.tmp-43-15, 0, 0) failed: No such file or directory
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2449]: unlink_secure: chmod(/dev/.tmp-43-15, 0000) failed: No such file or directory
udevd-event[2465]: unlink_secure: chown(/dev/.tmp-43-5, 0, 0) failed: No such file or directory
udevd-event[2449]: unlink_secure: unlink(/dev/.tmp-43-15) failed: Read-only file system
udevd-event[2465]: unlink_secure: chmod(/dev/.tmp-43-5, 0000) failed: No such file or directory
udevd-event[2465]: unlink_secure: unlink(/dev/.tmp-43-5) failed: Read-only file system
udevd-event[2467]: unlink_secure: chown(/dev/.tmp-43-6, 0, 0) failed: No such file or directory
udevd-event[2440]: delete_path: rmdir(/dev/.udev/names/nbd13) failed: Read-only file system
udevd-event[2455]: unlink_secure: chown(/dev/.tmp-43-3, 0, 0) failed: No such file or directory
udevd-event[2455]: unlink_secure: chmod(/dev/.tmp-43-3, 0000) failed: No such file or directory
udevd-event[2467]: unlink_secure: chmod(/dev/.tmp-43-6, 0000) failed: No such file or directory
udevd-event[2474]: unlink_secure: chown(/dev/.tmp-43-7, 0, 0) failed: No such file or directory
udevd-event[2486]: udev_node_mknod: mknod(/dev/.tmp-43-8.udev-tmp, 060600, 43, 8) failed: Read-only file system
udevd-event[2474]: unlink_secure: chmod(/dev/.tmp-43-7, 0000) failed: No such file or directory
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2486]: unlink_secure: chown(/dev/.tmp-43-8, 0, 0) failed: No such file or directory
udevd-event[2486]: unlink_secure: chmod(/dev/.tmp-43-8, 0000) failed: No such file or directory
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2440]: udev_node_mknod: chmod(/dev/nbd13, 060640) failed: Read-only file system
udevd-event[2440]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fnbd13': File exists
udevd-event[2455]: unlink_secure: unlink(/dev/.tmp-43-3) failed: Read-only file system
udevd-event[2467]: unlink_secure: unlink(/dev/.tmp-43-6) failed: Read-only file system
udevd-event[2474]: unlink_secure: unlink(/dev/.tmp-43-7) failed: Read-only file system
udevd-event[2486]: unlink_secure: unlink(/dev/.tmp-43-8) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2491]: udev_node_mknod: mknod(/dev/.tmp-43-9.udev-tmp, 060600, 43, 9) failed: Read-only file system
udevd-event[2453]: delete_path: rmdir(/dev/.udev/names/nbd2) failed: Read-only file system
udevd-event[2493]: udev_node_mknod: mknod(/dev/.tmp-1-0.udev-tmp, 060600, 1, 0) failed: Read-only file system
udevd-event[2453]: udev_node_mknod: chmod(/dev/nbd2, 060640) failed: Read-only file system
udevd-event[2453]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fnbd2': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2486]: delete_path: rmdir(/dev/.udev/names/nbd8) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2459]: delete_path: rmdir(/dev/.udev/names/nbd4) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2486]: udev_node_mknod: chmod(/dev/nbd8, 060640) failed: Read-only file system
udevd-event[2486]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fnbd8': File exists
udevd-event[2465]: delete_path: rmdir(/dev/.udev/names/nbd5) failed: Read-only file system
udevd-event[2445]: delete_path: rmdir(/dev/.udev/names/nbd14) failed: Read-only file system
udevd-event[2449]: delete_path: rmdir(/dev/.udev/names/nbd15) failed: Read-only file system
udevd-event[2474]: delete_path: rmdir(/dev/.udev/names/nbd7) failed: Read-only file system
udevd-event[2455]: delete_path: rmdir(/dev/.udev/names/nbd3) failed: Read-only file system
udevd-event[2467]: delete_path: rmdir(/dev/.udev/names/nbd6) failed: Read-only file system
udevd-event[2459]: udev_node_mknod: chmod(/dev/nbd4, 060640) failed: Read-only file system
udevd-event[2459]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fnbd4': File exists
udevd-event[2465]: udev_node_mknod: chmod(/dev/nbd5, 060640) failed: Read-only file system
udevd-event[2465]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fnbd5': File exists
udevd-event[2445]: udev_node_mknod: chmod(/dev/nbd14, 060640) failed: Read-only file system
udevd-event[2445]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fnbd14': File exists
udevd-event[2449]: udev_node_mknod: chmod(/dev/nbd15, 060640) failed: Read-only file system
udevd-event[2449]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fnbd15': File exists
udevd-event[2474]: udev_node_mknod: chmod(/dev/nbd7, 060640) failed: Read-only file system
udevd-event[2474]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fnbd7': File exists
udevd-event[2455]: udev_node_mknod: chmod(/dev/nbd3, 060640) failed: Read-only file system
udevd-event[2455]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fnbd3': File exists
udevd-event[2467]: udev_node_mknod: chmod(/dev/nbd6, 060640) failed: Read-only file system
udevd-event[2467]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fnbd6': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2491]: unlink_secure: chown(/dev/.tmp-43-9, 0, 0) failed: No such file or directory
udevd-event[2491]: unlink_secure: chmod(/dev/.tmp-43-9, 0000) failed: No such file or directory
udevd-event[2491]: unlink_secure: unlink(/dev/.tmp-43-9) failed: Read-only file system
udevd-event[2493]: unlink_secure: chown(/dev/.tmp-1-0, 0, 0) failed: No such file or directory
udevd-event[2493]: unlink_secure: chmod(/dev/.tmp-1-0, 0000) failed: No such file or directory
udevd-event[2493]: unlink_secure: unlink(/dev/.tmp-1-0) failed: Read-only file system
udevd-event[2501]: udev_node_mknod: mknod(/dev/.tmp-1-1.udev-tmp, 060600, 1, 1) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2501]: unlink_secure: chown(/dev/.tmp-1-1, 0, 0) failed: No such file or directory
udevd-event[2501]: unlink_secure: chmod(/dev/.tmp-1-1, 0000) failed: No such file or directory
udevd-event[2501]: unlink_secure: unlink(/dev/.tmp-1-1) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2506]: udev_node_mknod: mknod(/dev/.tmp-1-10.udev-tmp, 060600, 1, 10) failed: Read-only file system
udevd-event[2506]: unlink_secure: chown(/dev/.tmp-1-10, 0, 0) failed: No such file or directory
udevd-event[2506]: unlink_secure: chmod(/dev/.tmp-1-10, 0000) failed: No such file or directory
udevd-event[2506]: unlink_secure: unlink(/dev/.tmp-1-10) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2513]: udev_node_mknod: mknod(/dev/.tmp-1-12.udev-tmp, 060600, 1, 12) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2510]: udev_node_mknod: mknod(/dev/.tmp-1-11.udev-tmp, 060600, 1, 11) failed: Read-only file system
udevd-event[2491]: delete_path: rmdir(/dev/.udev/names/nbd9) failed: Read-only file system
udevd-event[2491]: udev_node_mknod: chmod(/dev/nbd9, 060640) failed: Read-only file system
udevd-event[2491]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fnbd9': File exists
udevd-event[2513]: unlink_secure: chown(/dev/.tmp-1-12, 0, 0) failed: No such file or directory
udevd-event[2513]: unlink_secure: chmod(/dev/.tmp-1-12, 0000) failed: No such file or directory
udevd-event[2513]: unlink_secure: unlink(/dev/.tmp-1-12) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2517]: udev_node_mknod: mknod(/dev/.tmp-1-13.udev-tmp, 060600, 1, 13) failed: Read-only file system
udevd-event[2510]: unlink_secure: chown(/dev/.tmp-1-11, 0, 0) failed: No such file or directory
udevd-event[2510]: unlink_secure: chmod(/dev/.tmp-1-11, 0000) failed: No such file or directory
udevd-event[2510]: unlink_secure: unlink(/dev/.tmp-1-11) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2517]: unlink_secure: chown(/dev/.tmp-1-13, 0, 0) failed: No such file or directory
udevd-event[2517]: unlink_secure: chmod(/dev/.tmp-1-13, 0000) failed: No such file or directory
udevd-event[2517]: unlink_secure: unlink(/dev/.tmp-1-13) failed: Read-only file system
udevd-event[2493]: delete_path: rmdir(/dev/.udev/names/ram0) failed: Read-only file system
udevd-event[2506]: delete_path: rmdir(/dev/.udev/names/ram10) failed: Read-only file system
udevd-event[2501]: delete_path: rmdir(/dev/.udev/names/ram1) failed: Read-only file system
udevd-event[2513]: delete_path: rmdir(/dev/.udev/names/ram12) failed: Read-only file system
udevd-event[2522]: udev_node_mknod: mknod(/dev/.tmp-1-14.udev-tmp, 060600, 1, 14) failed: Read-only file system
udevd-event[2513]: udev_node_mknod: chmod(/dev/ram12, 060640) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2522]: unlink_secure: chown(/dev/.tmp-1-14, 0, 0) failed: No such file or directory
udevd-event[2522]: unlink_secure: chmod(/dev/.tmp-1-14, 0000) failed: No such file or directory
udevd-event[2522]: unlink_secure: unlink(/dev/.tmp-1-14) failed: Read-only file system
udevd-event[2510]: delete_path: rmdir(/dev/.udev/names/ram11) failed: Read-only file system
udevd-event[2510]: udev_node_mknod: chmod(/dev/ram11, 060640) failed: Read-only file system
udevd-event[2527]: udev_node_mknod: mknod(/dev/.tmp-1-15.udev-tmp, 060600, 1, 15) failed: Read-only file system
udevd-event[2534]: udev_node_mknod: mknod(/dev/.tmp-1-3.udev-tmp, 060600, 1, 3) failed: Read-only file system
udevd-event[2532]: udev_node_mknod: mknod(/dev/.tmp-1-2.udev-tmp, 060600, 1, 2) failed: Read-only file system
udevd-event[2506]: udev_node_mknod: chmod(/dev/ram10, 060640) failed: Read-only file system
udevd-event[2534]: unlink_secure: chown(/dev/.tmp-1-3, 0, 0) failed: No such file or directory
udevd-event[2534]: unlink_secure: chmod(/dev/.tmp-1-3, 0000) failed: No such file or directory
udevd-event[2534]: unlink_secure: unlink(/dev/.tmp-1-3) failed: Read-only file system
udevd-event[2501]: delete_path: rmdir(/dev/.udev/names/ram) failed: Read-only file system
udevd-event[2493]: delete_path: rmdir(/dev/.udev/names/ramdisk) failed: Read-only file system
udevd-event[2501]: udev_node_mknod: chmod(/dev/ram1, 060640) failed: Read-only file system
udevd-event[2493]: udev_node_mknod: chmod(/dev/ram0, 060640) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2513]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fram12': File exists
udevd-event[2527]: unlink_secure: chown(/dev/.tmp-1-15, 0, 0) failed: No such file or directory
udevd-event[2527]: unlink_secure: chmod(/dev/.tmp-1-15, 0000) failed: No such file or directory
udevd-event[2527]: unlink_secure: unlink(/dev/.tmp-1-15) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2510]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fram11': File exists
udevd-event[2506]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fram10': File exists
udevd-event[2534]: delete_path: rmdir(/dev/.udev/names/ram3) failed: Read-only file system
udevd-event[2534]: udev_node_mknod: chmod(/dev/ram3, 060640) failed: Read-only file system
udevd-event[2534]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fram3': File exists
udevd-event[2501]: udev_db_add_device: unable to create db file '/dev/.udev/db/\x2fblock\x2fram1': Read-only file system
udevd-event[2546]: udev_node_mknod: mknod(/dev/.tmp-1-4.udev-tmp, 060600, 1, 4) failed: Read-only file system
udevd-event[2493]: udev_db_add_device: unable to create db file '/dev/.udev/db/\x2fblock\x2fram0': Read-only file system
udevd-event[2532]: unlink_secure: chown(/dev/.tmp-1-2, 0, 0) failed: No such file or directory
udevd-event[2532]: unlink_secure: chmod(/dev/.tmp-1-2, 0000) failed: No such file or directory
udevd-event[2532]: unlink_secure: unlink(/dev/.tmp-1-2) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2546]: unlink_secure: chown(/dev/.tmp-1-4, 0, 0) failed: No such file or directory
udevd-event[2546]: unlink_secure: chmod(/dev/.tmp-1-4, 0000) failed: No such file or directory
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2546]: unlink_secure: unlink(/dev/.tmp-1-4) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2553]: udev_node_mknod: mknod(/dev/.tmp-1-6.udev-tmp, 060600, 1, 6) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2553]: unlink_secure: chown(/dev/.tmp-1-6, 0, 0) failed: No such file or directory
udevd-event[2553]: unlink_secure: chmod(/dev/.tmp-1-6, 0000) failed: No such file or directory
udevd-event[2553]: unlink_secure: unlink(/dev/.tmp-1-6) failed: Read-only file system
udevd-event[2550]: udev_node_mknod: mknod(/dev/.tmp-1-5.udev-tmp, 060600, 1, 5) failed: Read-only file system
udevd-event[2522]: delete_path: rmdir(/dev/.udev/names/ram14) failed: Read-only file system
udevd-event[2522]: udev_node_mknod: chmod(/dev/ram14, 060640) failed: Read-only file system
udevd-event[2517]: delete_path: rmdir(/dev/.udev/names/ram13) failed: Read-only file system
udevd-event[2517]: udev_node_mknod: chmod(/dev/ram13, 060640) failed: Read-only file system
udevd-event[2527]: delete_path: rmdir(/dev/.udev/names/ram15) failed: Read-only file system
udevd-event[2527]: udev_node_mknod: chmod(/dev/ram15, 060640) failed: Read-only file system
udevd-event[2550]: unlink_secure: chown(/dev/.tmp-1-5, 0, 0) failed: No such file or directory
udevd-event[2550]: unlink_secure: chmod(/dev/.tmp-1-5, 0000) failed: No such file or directory
udevd-event[2550]: unlink_secure: unlink(/dev/.tmp-1-5) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2561]: udev_node_mknod: mknod(/dev/.tmp-1-7.udev-tmp, 060600, 1, 7) failed: Read-only file system
udevd-event[2522]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fram14': File exists
udevd-event[2517]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fram13': File exists
udevd-event[2527]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fram15': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2546]: delete_path: rmdir(/dev/.udev/names/ram4) failed: Read-only file system
udevd-event[2546]: udev_node_mknod: chmod(/dev/ram4, 060640) failed: Read-only file system
udevd-event[2546]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fram4': File exists
udevd-event[2532]: delete_path: rmdir(/dev/.udev/names/ram2) failed: Read-only file system
udevd-event[2532]: udev_node_mknod: chmod(/dev/ram2, 060640) failed: Read-only file system
udevd-event[2532]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fram2': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2550]: delete_path: rmdir(/dev/.udev/names/ram5) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2550]: udev_node_mknod: chmod(/dev/ram5, 060640) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2550]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fram5': File exists
udevd-event[2553]: delete_path: rmdir(/dev/.udev/names/ram6) failed: Read-only file system
udevd-event[2553]: udev_node_mknod: chmod(/dev/ram6, 060640) failed: Read-only file system
udevd-event[2553]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fram6': File exists
udevd-event[2565]: udev_node_mknod: mknod(/dev/.tmp-1-8.udev-tmp, 060600, 1, 8) failed: Read-only file system
udevd-event[2561]: unlink_secure: chown(/dev/.tmp-1-7, 0, 0) failed: No such file or directory
udevd-event[2561]: unlink_secure: chmod(/dev/.tmp-1-7, 0000) failed: No such file or directory
udevd-event[2561]: unlink_secure: unlink(/dev/.tmp-1-7) failed: Read-only file system
udevd-event[2569]: udev_node_mknod: mknod(/dev/.tmp-1-9.udev-tmp, 060600, 1, 9) failed: Read-only file system
udevd-event[2574]: udev_node_mknod: mknod(/dev/.tmp-8-0.udev-tmp, 060600, 8, 0) failed: Read-only file system
udevd-event[2561]: delete_path: rmdir(/dev/.udev/names/ram7) failed: Read-only file system
udevd-event[2561]: udev_node_mknod: chmod(/dev/ram7, 060640) failed: Read-only file system
udevd-event[2561]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fram7': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2569]: unlink_secure: chown(/dev/.tmp-1-9, 0, 0) failed: No such file or directory
udevd-event[2569]: unlink_secure: chmod(/dev/.tmp-1-9, 0000) failed: No such file or directory
udevd-event[2569]: unlink_secure: unlink(/dev/.tmp-1-9) failed: Read-only file system
udevd-event[2565]: unlink_secure: chown(/dev/.tmp-1-8, 0, 0) failed: No such file or directory
udevd-event[2565]: unlink_secure: chmod(/dev/.tmp-1-8, 0000) failed: No such file or directory
udevd-event[2565]: unlink_secure: unlink(/dev/.tmp-1-8) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
ata_id[2581]: main: unable to open '/dev/.tmp-8-0'
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2569]: delete_path: rmdir(/dev/.udev/names/ram9) failed: Read-only file system
udevd-event[2569]: udev_node_mknod: chmod(/dev/ram9, 060640) failed: Read-only file system
udevd-event[2569]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fram9': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2565]: delete_path: rmdir(/dev/.udev/names/ram8) failed: Read-only file system
udevd-event[2574]: unlink_secure: chown(/dev/.tmp-8-0, 0, 0) failed: No such file or directory
udevd-event[2574]: unlink_secure: chmod(/dev/.tmp-8-0, 0000) failed: No such file or directory
udevd-event[2565]: udev_node_mknod: chmod(/dev/ram8, 060640) failed: Read-only file system
udevd-event[2574]: unlink_secure: unlink(/dev/.tmp-8-0) failed: Read-only file system
udevd-event[2565]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fblock\x2fram8': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2574]: delete_path: rmdir(/dev/.udev/names/sda) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2574]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fscsi-SATA_HDS722525VLAT80_VNR93EC6CBTY1M) failed: Read-only file system
udevd-event[2574]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fata-HDS722525VLAT80_VNR93EC6CBTY1M) failed: Read-only file system
udevd-event[2574]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-path\x2fpci-0000:00:06.0-scsi-0:0:0:0) failed: Read-only file system
udevd-event[2574]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fedd-int13_dev80) failed: Read-only file system
udevd-event[2574]: udev_node_mknod: chmod(/dev/sda, 060640) failed: Read-only file system
udevd-event[2574]: udev_db_add_device: unable to create db file '/dev/.udev/db/\x2fblock\x2fsda': Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2587]: udev_node_mknod: mknod(/dev/.tmp-11-0.udev-tmp, 060600, 11, 0) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2600]: udev_node_mknod: mknod(/dev/.tmp-8-8.udev-tmp, 060600, 8, 8) failed: Read-only file system
udevd-event[2595]: udev_node_mknod: mknod(/dev/.tmp-8-2.udev-tmp, 060600, 8, 2) failed: Read-only file system
udevd-event[2598]: udev_node_mknod: mknod(/dev/.tmp-8-6.udev-tmp, 060600, 8, 6) failed: Read-only file system
udevd-event[2597]: udev_node_mknod: mknod(/dev/.tmp-8-5.udev-tmp, 060600, 8, 5) failed: Read-only file system
udevd-event[2599]: udev_node_mknod: mknod(/dev/.tmp-8-7.udev-tmp, 060600, 8, 7) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2596]: udev_node_mknod: mknod(/dev/.tmp-8-3.udev-tmp, 060600, 8, 3) failed: Read-only file system
udevd-event[2593]: udev_node_mknod: mknod(/dev/.tmp-8-1.udev-tmp, 060600, 8, 1) failed: Read-only file system
udevd-event[2594]: udev_node_mknod: mknod(/dev/.tmp-8-10.udev-tmp, 060600, 8, 10) failed: Read-only file system
udevd-event[2601]: udev_node_mknod: mknod(/dev/.tmp-8-9.udev-tmp, 060600, 8, 9) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2598]: unlink_secure: chown(/dev/.tmp-8-6, 0, 0) failed: No such file or directory
udevd-event[2598]: unlink_secure: chmod(/dev/.tmp-8-6, 0000) failed: No such file or directory
udevd-event[2598]: unlink_secure: unlink(/dev/.tmp-8-6) failed: Read-only file system
udevd-event[2600]: unlink_secure: chown(/dev/.tmp-8-8, 0, 0) failed: No such file or directory
udevd-event[2600]: unlink_secure: chmod(/dev/.tmp-8-8, 0000) failed: No such file or directory
udevd-event[2600]: unlink_secure: unlink(/dev/.tmp-8-8) failed: Read-only file system
udevd-event[2599]: unlink_secure: chown(/dev/.tmp-8-7, 0, 0) failed: No such file or directory
udevd-event[2599]: unlink_secure: chmod(/dev/.tmp-8-7, 0000) failed: No such file or directory
udevd-event[2599]: unlink_secure: unlink(/dev/.tmp-8-7) failed: Read-only file system
udevd-event[2595]: unlink_secure: chown(/dev/.tmp-8-2, 0, 0) failed: No such file or directory
udevd-event[2594]: unlink_secure: chown(/dev/.tmp-8-10, 0, 0) failed: No such file or directory
udevd-event[2595]: unlink_secure: chmod(/dev/.tmp-8-2, 0000) failed: No such file or directory
udevd-event[2594]: unlink_secure: chmod(/dev/.tmp-8-10, 0000) failed: No such file or directory
udevd-event[2595]: unlink_secure: unlink(/dev/.tmp-8-2) failed: Read-only file system
udevd-event[2594]: unlink_secure: unlink(/dev/.tmp-8-10) failed: Read-only file system
udevd-event[2596]: unlink_secure: chown(/dev/.tmp-8-3, 0, 0) failed: No such file or directory
udevd-event[2593]: unlink_secure: chown(/dev/.tmp-8-1, 0, 0) failed: No such file or directory
udevd-event[2596]: unlink_secure: chmod(/dev/.tmp-8-3, 0000) failed: No such file or directory
udevd-event[2593]: unlink_secure: chmod(/dev/.tmp-8-1, 0000) failed: No such file or directory
udevd-event[2596]: unlink_secure: unlink(/dev/.tmp-8-3) failed: Read-only file system
udevd-event[2593]: unlink_secure: unlink(/dev/.tmp-8-1) failed: Read-only file system
udevd-event[2597]: unlink_secure: chown(/dev/.tmp-8-5, 0, 0) failed: No such file or directory
udevd-event[2587]: unlink_secure: chown(/dev/.tmp-11-0, 0, 0) failed: No such file or directory
udevd-event[2597]: unlink_secure: chmod(/dev/.tmp-8-5, 0000) failed: No such file or directory
udevd-event[2587]: unlink_secure: chmod(/dev/.tmp-11-0, 0000) failed: No such file or directory
udevd-event[2597]: unlink_secure: unlink(/dev/.tmp-8-5) failed: Read-only file system
udevd-event[2587]: unlink_secure: unlink(/dev/.tmp-11-0) failed: Read-only file system
udevd-event[2601]: unlink_secure: chown(/dev/.tmp-8-9, 0, 0) failed: No such file or directory
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2598]: delete_path: rmdir(/dev/.udev/names/sda6) failed: Read-only file system
udevd-event[2601]: unlink_secure: chmod(/dev/.tmp-8-9, 0000) failed: No such file or directory
udevd-event[2600]: delete_path: rmdir(/dev/.udev/names/sda8) failed: Read-only file system
udevd-event[2601]: unlink_secure: unlink(/dev/.tmp-8-9) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2598]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fscsi-SATA_HDS722525VLAT80_VNR93EC6CBTY1M-part6) failed: Read-only file system
udevd-event[2600]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fscsi-SATA_HDS722525VLAT80_VNR93EC6CBTY1M-part8) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2598]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fata-HDS722525VLAT80_VNR93EC6CBTY1M-part6) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2600]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fata-HDS722525VLAT80_VNR93EC6CBTY1M-part8) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2598]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-path\x2fpci-0000:00:06.0-scsi-0:0:0:0-part6) failed: Read-only file system
udevd-event[2600]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-path\x2fpci-0000:00:06.0-scsi-0:0:0:0-part8) failed: Read-only file system
udevd-event[2599]: delete_path: rmdir(/dev/.udev/names/sda7) failed: Read-only file system
udevd-event[2593]: delete_path: rmdir(/dev/.udev/names/sda1) failed: Read-only file system
udevd-event[2594]: delete_path: rmdir(/dev/.udev/names/sda10) failed: Read-only file system
udevd-event[2595]: delete_path: rmdir(/dev/.udev/names/sda2) failed: Read-only file system
udevd-event[2596]: delete_path: rmdir(/dev/.udev/names/sda3) failed: Read-only file system
udevd-event[2601]: delete_path: rmdir(/dev/.udev/names/sda9) failed: Read-only file system
udevd-event[2587]: delete_path: rmdir(/dev/.udev/names/sr0) failed: Read-only file system
udevd-event[2597]: delete_path: rmdir(/dev/.udev/names/sda5) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2599]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fscsi-SATA_HDS722525VLAT80_VNR93EC6CBTY1M-part7) failed: Read-only file system
udevd-event[2598]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fedd-int13_dev80-part6) failed: Read-only file system
udevd-event[2598]: udev_node_mknod: chmod(/dev/sda6, 060640) failed: Read-only file system
udevd-event[2598]: udev_db_add_device: unable to create db file '/dev/.udev/db/\x2fblock\x2fsda\x2fsda6': Read-only file system
udevd-event[2600]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fedd-int13_dev80-part8) failed: Read-only file system
udevd-event[2600]: udev_node_mknod: chmod(/dev/sda8, 060640) failed: Read-only file system
udevd-event[2600]: udev_db_add_device: unable to create db file '/dev/.udev/db/\x2fblock\x2fsda\x2fsda8': Read-only file system
udevd-event[2595]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fscsi-SATA_HDS722525VLAT80_VNR93EC6CBTY1M-part2) failed: Read-only file system
udevd-event[2593]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fscsi-SATA_HDS722525VLAT80_VNR93EC6CBTY1M-part1) failed: Read-only file system
udevd-event[2594]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fscsi-SATA_HDS722525VLAT80_VNR93EC6CBTY1M-part10) failed: Read-only file system
udevd-event[2596]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fscsi-SATA_HDS722525VLAT80_VNR93EC6CBTY1M-part3) failed: Read-only file system
udevd-event[2597]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fscsi-SATA_HDS722525VLAT80_VNR93EC6CBTY1M-part5) failed: Read-only file system
udevd-event[2587]: delete_path: rmdir(/dev/.udev/names/scd0) failed: Read-only file system
udevd-event[2593]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fata-HDS722525VLAT80_VNR93EC6CBTY1M-part1) failed: Read-only file system
udevd-event[2595]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fata-HDS722525VLAT80_VNR93EC6CBTY1M-part2) failed: Read-only file system
udevd-event[2594]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fata-HDS722525VLAT80_VNR93EC6CBTY1M-part10) failed: Read-only file system
udevd-event[2601]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fscsi-SATA_HDS722525VLAT80_VNR93EC6CBTY1M-part9) failed: Read-only file system
udevd-event[2599]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fata-HDS722525VLAT80_VNR93EC6CBTY1M-part7) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2597]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fata-HDS722525VLAT80_VNR93EC6CBTY1M-part5) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2587]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-path\x2fpci-0000:00:06.0-scsi-1:0:1:0) failed: Read-only file system
udevd-event[2596]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fata-HDS722525VLAT80_VNR93EC6CBTY1M-part3) failed: Read-only file system
udevd-event[2601]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fata-HDS722525VLAT80_VNR93EC6CBTY1M-part9) failed: Read-only file system
udevd-event[2599]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-path\x2fpci-0000:00:06.0-scsi-0:0:0:0-part7) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2593]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-path\x2fpci-0000:00:06.0-scsi-0:0:0:0-part1) failed: Read-only file system
udevd-event[2595]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-path\x2fpci-0000:00:06.0-scsi-0:0:0:0-part2) failed: Read-only file system
udevd-event[2594]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-path\x2fpci-0000:00:06.0-scsi-0:0:0:0-part10) failed: Read-only file system
udevd-event[2597]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-path\x2fpci-0000:00:06.0-scsi-0:0:0:0-part5) failed: Read-only file system
udevd-event[2596]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-path\x2fpci-0000:00:06.0-scsi-0:0:0:0-part3) failed: Read-only file system
udevd-event[2599]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fedd-int13_dev80-part7) failed: Read-only file system
udevd-event[2599]: udev_node_mknod: chmod(/dev/sda7, 060640) failed: Read-only file system
udevd-event[2599]: udev_db_add_device: unable to create db file '/dev/.udev/db/\x2fblock\x2fsda\x2fsda7': Read-only file system
udevd-event[2587]: delete_path: rmdir(/dev/.udev/names/cdrom) failed: Read-only file system
udevd-event[2593]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fedd-int13_dev80-part1) failed: Read-only file system
udevd-event[2593]: udev_node_mknod: chmod(/dev/sda1, 060640) failed: Read-only file system
udevd-event[2593]: udev_db_add_device: unable to create db file '/dev/.udev/db/\x2fblock\x2fsda\x2fsda1': Read-only file system
udevd-event[2594]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fedd-int13_dev80-part10) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2594]: udev_node_mknod: chmod(/dev/sda10, 060640) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2594]: udev_db_add_device: unable to create db file '/dev/.udev/db/\x2fblock\x2fsda\x2fsda10': Read-only file system
udevd-event[2595]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-uuid\x2ff9d5f5d7-3f59-41f8-95a5-7ec7eec08d46) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2601]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-path\x2fpci-0000:00:06.0-scsi-0:0:0:0-part9) failed: Read-only file system
udevd-event[2596]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fedd-int13_dev80-part3) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2596]: udev_node_mknod: chmod(/dev/sda3, 060640) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2596]: udev_db_add_device: unable to create db file '/dev/.udev/db/\x2fblock\x2fsda\x2fsda3': Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2597]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fedd-int13_dev80-part5) failed: Read-only file system
udevd-event[2597]: udev_node_mknod: chmod(/dev/sda5, 060640) failed: Read-only file system
udevd-event[2597]: udev_db_add_device: unable to create db file '/dev/.udev/db/\x2fblock\x2fsda\x2fsda5': Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2587]: delete_path: rmdir(/dev/.udev/names/cdrw) failed: Read-only file system
udevd-event[2595]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-label\x2fSWAP-sda2) failed: Read-only file system
udevd-event[2601]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fedd-int13_dev80-part9) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2601]: udev_node_mknod: chmod(/dev/sda9, 060640) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2601]: udev_db_add_device: unable to create db file '/dev/.udev/db/\x2fblock\x2fsda\x2fsda9': Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2587]: delete_path: rmdir(/dev/.udev/names/dvd) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2595]: delete_path: rmdir(/dev/.udev/names/disk\x2fby-id\x2fedd-int13_dev80-part2) failed: Read-only file system
udevd-event[2595]: udev_node_mknod: chmod(/dev/sda2, 060640) failed: Read-only file system
udevd-event[2595]: udev_db_add_device: unable to create db file '/dev/.udev/db/\x2fblock\x2fsda\x2fsda2': Read-only file system
udevd-event[2587]: delete_path: rmdir(/dev/.udev/names/dvdrw) failed: Read-only file system
udevd-event[2587]: udev_node_mknod: chmod(/dev/sr0, 060640) failed: Read-only file system
udevd-event[2587]: udev_db_add_device: unable to create db file '/dev/.udev/db/\x2fblock\x2fsr0': Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2688]: delete_path: rmdir(/dev/.udev/names/bsg\x2f0:0:0:0) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2688]: udev_node_mknod: mknod(/dev/bsg/0:0:0:0.udev-tmp, 020660, 252, 0) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2689]: delete_path: rmdir(/dev/.udev/names/bsg\x2f1:0:1:0) failed: Read-only file system
udevd-event[2689]: udev_node_mknod: mknod(/dev/bsg/1:0:1:0.udev-tmp, 020660, 252, 1) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2690]: delete_path: rmdir(/dev/.udev/names/capi) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2690]: udev_node_mknod: chmod(/dev/capi, 020660) failed: Read-only file system
udevd-event[2690]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fcapi\x2fcapi': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2691]: delete_path: rmdir(/dev/.udev/names/cfs0) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2691]: udev_node_mknod: chmod(/dev/cfs0, 020660) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2691]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fcoda\x2fcfs0': File exists
udevd-event[2695]: delete_path: rmdir(/dev/.udev/names/cfs3) failed: Read-only file system
udevd-event[2695]: udev_node_mknod: chmod(/dev/cfs3, 020660) failed: Read-only file system
udevd-event[2695]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fcoda\x2fcfs3': File exists
udevd-event[2692]: delete_path: rmdir(/dev/.udev/names/cfs1) failed: Read-only file system
udevd-event[2692]: udev_node_mknod: chmod(/dev/cfs1, 020660) failed: Read-only file system
udevd-event[2692]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fcoda\x2fcfs1': File exists
udevd-event[2694]: delete_path: rmdir(/dev/.udev/names/cfs2) failed: Read-only file system
udevd-event[2694]: udev_node_mknod: chmod(/dev/cfs2, 020660) failed: Read-only file system
udevd-event[2694]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fcoda\x2fcfs2': File exists
udevd-event[2696]: delete_path: rmdir(/dev/.udev/names/cfs4) failed: Read-only file system
udevd-event[2696]: udev_node_mknod: chmod(/dev/cfs4, 020660) failed: Read-only file system
udevd-event[2696]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fcoda\x2fcfs4': File exists
udevd-event[2697]: delete_path: rmdir(/dev/.udev/names/dri\x2fcard0) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2697]: udev_node_mknod: chmod(/dev/dri/card0, 020666) failed: Read-only file system
udevd-event[2697]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fdrm\x2fcard0': File exists
udevd-event[2701]: delete_path: rmdir(/dev/.udev/names/i2c-0) failed: Read-only file system
udevd-event[2701]: udev_node_mknod: chmod(/dev/i2c-0, 020660) failed: Read-only file system
udevd-event[2701]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fi2c-dev\x2fi2c-0': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2702]: delete_path: rmdir(/dev/.udev/names/i2c-1) failed: Read-only file system
udevd-event[2702]: udev_node_mknod: chmod(/dev/i2c-1, 020660) failed: Read-only file system
udevd-event[2702]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fi2c-dev\x2fi2c-1': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2703]: delete_path: rmdir(/dev/.udev/names/i2c-2) failed: Read-only file system
udevd-event[2703]: udev_node_mknod: chmod(/dev/i2c-2, 020660) failed: Read-only file system
udevd-event[2703]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fi2c-dev\x2fi2c-2': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2704]: delete_path: rmdir(/dev/.udev/names/raw1394) failed: Read-only file system
udevd-event[2704]: udev_node_mknod: chmod(/dev/raw1394, 020660) failed: Read-only file system
udevd-event[2704]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fieee1394_protocol\x2fraw1394': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2708]: delete_path: rmdir(/dev/.udev/names/input\x2fmouse0) failed: Read-only file system
udevd-event[2707]: delete_path: rmdir(/dev/.udev/names/input\x2fevent0) failed: Read-only file system
udevd-event[2708]: udev_node_mknod: chmod(/dev/input/mouse0, 020640) failed: Read-only file system
udevd-event[2708]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2finput\x2finput0\x2fmouse0': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2707]: delete_path: rmdir(/dev/.udev/names/input\x2fby-path\x2fplatform-i8042-serio-0-event-kbd) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2707]: udev_node_mknod: chmod(/dev/input/event0, 020640) failed: Read-only file system
udevd-event[2707]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2finput\x2finput0\x2fevent0': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2744]: delete_path: rmdir(/dev/.udev/names/oldmem) failed: Read-only file system
udevd-event[2744]: udev_node_mknod: chmod(/dev/oldmem, 020660) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2720]: delete_path: rmdir(/dev/.udev/names/input\x2fevent2) failed: Read-only file system
udevd-event[2720]: delete_path: rmdir(/dev/.udev/names/input\x2fby-path\x2fplatform-i8042-serio-1-event-mouse) failed: Read-only file system
udevd-event[2720]: udev_node_mknod: chmod(/dev/input/event2, 020640) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2736]: delete_path: rmdir(/dev/.udev/names/full) failed: Read-only file system
udevd-event[2736]: udev_node_mknod: chmod(/dev/full, 020666) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2739]: delete_path: rmdir(/dev/.udev/names/kmsg) failed: Read-only file system
udevd-event[2739]: udev_node_mknod: chmod(/dev/kmsg, 020660) failed: Read-only file system
udevd-event[2739]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fmem\x2fkmsg': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2731]: delete_path: rmdir(/dev/.udev/names/input\x2fmice) failed: Read-only file system
udevd-event[2731]: udev_node_mknod: chmod(/dev/input/mice, 020640) failed: Read-only file system
udevd-event[2729]: delete_path: rmdir(/dev/.udev/names/input\x2fevent3) failed: Read-only file system
udevd-event[2729]: delete_path: rmdir(/dev/.udev/names/input\x2fby-path\x2fplatform-i8042-serio-0-event-kbd) failed: Read-only file system
udevd-event[2729]: udev_node_mknod: chmod(/dev/input/event3, 020640) failed: Read-only file system
udevd-event[2741]: delete_path: rmdir(/dev/.udev/names/mem) failed: Read-only file system
udevd-event[2741]: udev_node_mknod: chmod(/dev/mem, 020640) failed: Read-only file system
udevd-event[2745]: delete_path: rmdir(/dev/.udev/names/port) failed: Read-only file system
udevd-event[2745]: udev_node_mknod: chmod(/dev/port, 020640) failed: Read-only file system
udevd-event[2745]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fmem\x2fport': File exists
udevd-event[2719]: delete_path: rmdir(/dev/.udev/names/input\x2fevent1) failed: Read-only file system
udevd-event[2719]: delete_path: rmdir(/dev/.udev/names/input\x2fby-path\x2fplatform-i8042-serio-1-event-mouse) failed: Read-only file system
udevd-event[2719]: udev_node_mknod: chmod(/dev/input/event1, 020640) failed: Read-only file system
udevd-event[2719]: udev_db_add_device: unable to create db file '/dev/.udev/db/\x2fclass\x2finput\x2finput1\x2fevent1': Read-only file system
udevd-event[2746]: delete_path: rmdir(/dev/.udev/names/random) failed: Read-only file system
udevd-event[2746]: udev_node_mknod: chmod(/dev/random, 020666) failed: Read-only file system
udevd-event[2719]: node_symlink: symlink(../event1, /dev/input/by-path/platform-i8042-serio-0-event-kbd.udev-tmp) failed: Read-only file system
udevd-event[2746]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fmem\x2frandom': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2744]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fmem\x2foldmem': File exists
udevd-event[2720]: udev_db_add_device: unable to create db file '/dev/.udev/db/\x2fclass\x2finput\x2finput2\x2fevent2': Read-only file system
udevd-event[2736]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fmem\x2ffull': File exists
udevd-event[2754]: delete_path: rmdir(/dev/.udev/names/dlm_plock) failed: Read-only file system
udevd-event[2754]: udev_node_mknod: mknod(/dev/dlm_plock.udev-tmp, 020660, 10, 60) failed: Read-only file system
udevd-event[2747]: delete_path: rmdir(/dev/.udev/names/urandom) failed: Read-only file system
udevd-event[2747]: udev_node_mknod: chmod(/dev/urandom, 020666) failed: Read-only file system
udevd-event[2747]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fmem\x2furandom': File exists
udevd-event[2760]: delete_path: rmdir(/dev/.udev/names/nvram) failed: Read-only file system
udevd-event[2760]: udev_node_mknod: chmod(/dev/nvram, 020660) failed: Read-only file system
udevd-event[2760]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fmisc\x2fnvram': File exists
udevd-event[2748]: delete_path: rmdir(/dev/.udev/names/zero) failed: Read-only file system
udevd-event[2748]: udev_node_mknod: chmod(/dev/zero, 020666) failed: Read-only file system
udevd-event[2748]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fmem\x2fzero': File exists
udevd-event[2730]: delete_path: rmdir(/dev/.udev/names/input\x2fmouse1) failed: Read-only file system
udevd-event[2750]: delete_path: rmdir(/dev/.udev/names/cpu_dma_latency) failed: Read-only file system
udevd-event[2750]: udev_node_mknod: mknod(/dev/cpu_dma_latency.udev-tmp, 020660, 10, 55) failed: Read-only file system
udevd-event[2756]: delete_path: rmdir(/dev/.udev/names/mcelog) failed: Read-only file system
udevd-event[2756]: udev_node_mknod: chmod(/dev/mcelog, 020660) failed: Read-only file system
udevd-event[2756]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fmisc\x2fmcelog': File exists
udevd-event[2731]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2finput\x2fmice': File exists
udevd-event[2729]: udev_db_add_device: unable to create db file '/dev/.udev/db/\x2fclass\x2finput\x2finput3\x2fevent3': Read-only file system
udevd-event[2741]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fmem\x2fmem': File exists
udevd-event[2751]: delete_path: rmdir(/dev/.udev/names/dac960_gam) failed: Read-only file system
udevd-event[2751]: udev_node_mknod: chmod(/dev/dac960_gam, 020660) failed: Read-only file system
udevd-event[2751]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fmisc\x2fdac960_gam': File exists
udevd-event[2758]: delete_path: rmdir(/dev/.udev/names/network_latency) failed: Read-only file system
udevd-event[2758]: udev_node_mknod: mknod(/dev/network_latency.udev-tmp, 020660, 10, 54) failed: Read-only file system
udevd-event[2752]: delete_path: rmdir(/dev/.udev/names/dlm-control) failed: Read-only file system
udevd-event[2752]: udev_node_mknod: mknod(/dev/dlm-control.udev-tmp, 020660, 10, 62) failed: Read-only file system
udevd-event[2759]: delete_path: rmdir(/dev/.udev/names/network_throughput) failed: Read-only file system
udevd-event[2759]: udev_node_mknod: mknod(/dev/network_throughput.udev-tmp, 020660, 10, 53) failed: Read-only file system
udevd-event[2753]: delete_path: rmdir(/dev/.udev/names/dlm-monitor) failed: Read-only file system
udevd-event[2753]: udev_node_mknod: mknod(/dev/dlm-monitor.udev-tmp, 020660, 10, 61) failed: Read-only file system
udevd-event[2749]: delete_path: rmdir(/dev/.udev/names/btrfs-control) failed: Read-only file system
udevd-event[2749]: udev_node_mknod: mknod(/dev/btrfs-control.udev-tmp, 020660, 10, 58) failed: Read-only file system
udevd-event[2766]: udev_node_mknod: mknod(/dev/vga_arbiter.udev-tmp, 020660, 10, 63) failed: Read-only file system
udevd-event[2755]: delete_path: rmdir(/dev/.udev/names/fuse) failed: Read-only file system
udevd-event[2755]: udev_node_mknod: chmod(/dev/fuse, 020660) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2755]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fmisc\x2ffuse': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2764]: delete_path: rmdir(/dev/.udev/names/rtc) failed: Read-only file system
udevd-event[2764]: udev_node_mknod: chmod(/dev/rtc, 020644) failed: Read-only file system
udevd-event[2764]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fmisc\x2frtc': File exists
udevd-event[2767]: delete_path: rmdir(/dev/.udev/names/watchdog) failed: Read-only file system
udevd-event[2763]: delete_path: rmdir(/dev/.udev/names/psaux) failed: Read-only file system
udevd-event[2742]: delete_path: rmdir(/dev/.udev/names/null) failed: Read-only file system
udevd-event[2765]: delete_path: rmdir(/dev/.udev/names/tgt) failed: Read-only file system
udevd-event[2762]: delete_path: rmdir(/dev/.udev/names/pktcdvd\x2fcontrol) failed: Read-only file system
udevd-event[2761]: delete_path: rmdir(/dev/.udev/names/ocfs2_control) failed: Read-only file system
udevd-event[2757]: delete_path: rmdir(/dev/.udev/names/cpu\x2fmicrocode) failed: Read-only file system
udevd-event[2729]: node_symlink: symlink(../event4, /dev/input/by-path/platform-i8042-serio-1-event-mouse.udev-tmp) failed: Read-only file system
udevd-event[2729]: node_symlink: symlink(../event3, /dev/input/by-path/platform-i8042-serio-0-event-kbd.udev-tmp) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2768]: delete_path: rmdir(/dev/.udev/names/cpu\x2f0\x2fmsr) failed: Read-only file system
udevd-event[2730]: delete_path: rmdir(/dev/.udev/names/input\x2fby-path\x2fplatform-i8042-serio-1-mouse) failed: Read-only file system
udevd-event[2730]: udev_node_mknod: chmod(/dev/input/mouse1, 020640) failed: Read-only file system
udevd-event[2730]: udev_db_add_device: unable to create db file '/dev/.udev/db/\x2fclass\x2finput\x2finput3\x2fmouse1': Read-only file system
udevd-event[2720]: node_symlink: symlink(../event2, /dev/input/by-path/platform-i8042-serio-1-event-mouse.udev-tmp) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2763]: udev_node_mknod: chmod(/dev/psaux, 020660) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2763]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fmisc\x2fpsaux': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2765]: udev_node_mknod: mknod(/dev/tgt.udev-tmp, 020660, 10, 56) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2761]: udev_node_mknod: mknod(/dev/ocfs2_control.udev-tmp, 020660, 10, 59) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2767]: udev_node_mknod: chmod(/dev/watchdog, 020660) failed: Read-only file system
udevd-event[2742]: delete_path: rmdir(/dev/.udev/names/XOR) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2742]: udev_node_mknod: chmod(/dev/null, 020666) failed: Read-only file system
udevd-event[2762]: udev_node_mknod: mknod(/dev/pktcdvd/control.udev-tmp, 020660, 10, 57) failed: Read-only file system
udevd-event[2742]: udev_db_add_device: unable to create db file '/dev/.udev/db/\x2fclass\x2fmem\x2fnull': Read-only file system
udevd-event[2757]: udev_node_mknod: chmod(/dev/cpu/microcode, 020600) failed: Read-only file system
udevd-event[2757]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fmisc\x2fmicrocode': File exists
udevd-event[2767]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fmisc\x2fwatchdog': File exists
udevd-event[2768]: udev_node_mknod: chmod(/dev/cpu/0/msr, 020660) failed: Read-only file system
udevd-event[2768]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fmsr\x2fmsr0': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2769]: delete_path: rmdir(/dev/.udev/names/cpu\x2f1\x2fmsr) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2769]: udev_node_mknod: chmod(/dev/cpu/1/msr, 020660) failed: Read-only file system
udevd-event[2769]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fmsr\x2fmsr1': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2844]: delete_path: rmdir(/dev/.udev/names/parport0) failed: Read-only file system
udevd-event[2844]: udev_node_mknod: chmod(/dev/parport0, 020660) failed: Read-only file system
udevd-event[2844]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fppdev\x2fparport0': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2847]: delete_path: rmdir(/dev/.udev/names/raw\x2frawctl) failed: Read-only file system
udevd-event[2845]: delete_path: rmdir(/dev/.udev/names/ppp) failed: Read-only file system
udevd-event[2845]: udev_node_mknod: chmod(/dev/ppp, 020600) failed: Read-only file system
udevd-event[2845]: udev_db_add_device: unable to create db file '/dev/.udev/db/\x2fclass\x2fppp\x2fppp': Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2846]: delete_path: rmdir(/dev/.udev/names/lp0) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2847]: udev_node_mknod: chmod(/dev/raw/rawctl, 020660) failed: Read-only file system
udevd-event[2847]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fraw\x2frawctl': File exists
udevd-event[2853]: delete_path: rmdir(/dev/.udev/names/sg0) failed: Read-only file system
udevd-event[2853]: udev_node_mknod: chmod(/dev/sg0, 020640) failed: Read-only file system
udevd-event[2853]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fscsi_generic\x2fsg0': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2846]: delete_path: rmdir(/dev/.udev/names/par0) failed: Read-only file system
udevd-event[2846]: udev_node_mknod: chmod(/dev/lp0, 020660) failed: Read-only file system
udevd-event[2846]: udev_db_add_device: unable to create db file '/dev/.udev/db/\x2fclass\x2fprinter\x2flp0': Read-only file system
udevd-event[2854]: delete_path: rmdir(/dev/.udev/names/sg1) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2854]: udev_node_mknod: chmod(/dev/sg1, 020640) failed: Read-only file system
udevd-event[2854]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fscsi_generic\x2fsg1': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2858]: delete_path: rmdir(/dev/.udev/names/capi0) failed: Read-only file system
udevd-event[2858]: udev_node_mknod: chmod(/dev/capi0, 020660) failed: Read-only file system
udevd-event[2858]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi0': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2859]: delete_path: rmdir(/dev/.udev/names/capi1) failed: Read-only file system
udevd-event[2859]: udev_node_mknod: chmod(/dev/capi1, 020660) failed: Read-only file system
udevd-event[2859]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi1': File exists
udevd-event[2860]: delete_path: rmdir(/dev/.udev/names/capi10) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2860]: udev_node_mknod: chmod(/dev/capi10, 020660) failed: Read-only file system
udevd-event[2860]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi10': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2861]: delete_path: rmdir(/dev/.udev/names/capi11) failed: Read-only file system
udevd-event[2861]: udev_node_mknod: chmod(/dev/capi11, 020660) failed: Read-only file system
udevd-event[2861]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi11': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2862]: delete_path: rmdir(/dev/.udev/names/capi12) failed: Read-only file system
udevd-event[2862]: udev_node_mknod: chmod(/dev/capi12, 020660) failed: Read-only file system
udevd-event[2862]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi12': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2863]: delete_path: rmdir(/dev/.udev/names/capi13) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2864]: delete_path: rmdir(/dev/.udev/names/capi14) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2866]: delete_path: rmdir(/dev/.udev/names/capi16) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2868]: delete_path: rmdir(/dev/.udev/names/capi18) failed: Read-only file system
udevd-event[2869]: delete_path: rmdir(/dev/.udev/names/capi19) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2865]: delete_path: rmdir(/dev/.udev/names/capi15) failed: Read-only file system
udevd-event[2863]: udev_node_mknod: chmod(/dev/capi13, 020660) failed: Read-only file system
udevd-event[2863]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi13': File exists
udevd-event[2864]: udev_node_mknod: chmod(/dev/capi14, 020660) failed: Read-only file system
udevd-event[2864]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi14': File exists
udevd-event[2866]: udev_node_mknod: chmod(/dev/capi16, 020660) failed: Read-only file system
udevd-event[2868]: udev_node_mknod: chmod(/dev/capi18, 020660) failed: Read-only file system
udevd-event[2866]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi16': File exists
udevd-event[2868]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi18': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2865]: udev_node_mknod: chmod(/dev/capi15, 020660) failed: Read-only file system
udevd-event[2865]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi15': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2869]: udev_node_mknod: chmod(/dev/capi19, 020660) failed: Read-only file system
udevd-event[2867]: delete_path: rmdir(/dev/.udev/names/capi17) failed: Read-only file system
udevd-event[2869]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi19': File exists
udevd-event[2867]: udev_node_mknod: chmod(/dev/capi17, 020660) failed: Read-only file system
udevd-event[2867]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi17': File exists
udevd-event[2871]: delete_path: rmdir(/dev/.udev/names/capi20) failed: Read-only file system
udevd-event[2871]: udev_node_mknod: chmod(/dev/capi20, 020660) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2871]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi20': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2872]: delete_path: rmdir(/dev/.udev/names/capi21) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2870]: delete_path: rmdir(/dev/.udev/names/capi2) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2870]: udev_node_mknod: chmod(/dev/capi2, 020660) failed: Read-only file system
udevd-event[2870]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi2': File exists
udevd-event[2872]: udev_node_mknod: chmod(/dev/capi21, 020660) failed: Read-only file system
udevd-event[2872]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi21': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2874]: delete_path: rmdir(/dev/.udev/names/capi22) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2875]: delete_path: rmdir(/dev/.udev/names/capi23) failed: Read-only file system
udevd-event[2875]: udev_node_mknod: chmod(/dev/capi23, 020660) failed: Read-only file system
udevd-event[2875]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi23': File exists
udevd-event[2874]: udev_node_mknod: chmod(/dev/capi22, 020660) failed: Read-only file system
udevd-event[2874]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi22': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2876]: delete_path: rmdir(/dev/.udev/names/capi24) failed: Read-only file system
udevd-event[2876]: udev_node_mknod: chmod(/dev/capi24, 020660) failed: Read-only file system
udevd-event[2876]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi24': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2877]: delete_path: rmdir(/dev/.udev/names/capi25) failed: Read-only file system
udevd-event[2877]: udev_node_mknod: chmod(/dev/capi25, 020660) failed: Read-only file system
udevd-event[2877]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi25': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2878]: delete_path: rmdir(/dev/.udev/names/capi26) failed: Read-only file system
udevd-event[2878]: udev_node_mknod: chmod(/dev/capi26, 020660) failed: Read-only file system
udevd-event[2878]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi26': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2880]: delete_path: rmdir(/dev/.udev/names/capi28) failed: Read-only file system
udevd-event[2880]: udev_node_mknod: chmod(/dev/capi28, 020660) failed: Read-only file system
udevd-event[2880]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi28': File exists
udevd-event[2881]: delete_path: rmdir(/dev/.udev/names/capi29) failed: Read-only file system
udevd-event[2881]: udev_node_mknod: chmod(/dev/capi29, 020660) failed: Read-only file system
udevd-event[2881]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi29': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2879]: delete_path: rmdir(/dev/.udev/names/capi27) failed: Read-only file system
udevd-event[2879]: udev_node_mknod: chmod(/dev/capi27, 020660) failed: Read-only file system
udevd-event[2879]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi27': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2884]: delete_path: rmdir(/dev/.udev/names/capi31) failed: Read-only file system
udevd-event[2882]: delete_path: rmdir(/dev/.udev/names/capi3) failed: Read-only file system
udevd-event[2882]: udev_node_mknod: chmod(/dev/capi3, 020660) failed: Read-only file system
udevd-event[2882]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi3': File exists
udevd-event[2884]: udev_node_mknod: chmod(/dev/capi31, 020660) failed: Read-only file system
udevd-event[2884]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi31': File exists
udevd-event[2883]: delete_path: rmdir(/dev/.udev/names/capi30) failed: Read-only file system
udevd-event[2883]: udev_node_mknod: chmod(/dev/capi30, 020660) failed: Read-only file system
udevd-event[2883]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi30': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2885]: delete_path: rmdir(/dev/.udev/names/capi4) failed: Read-only file system
udevd-event[2885]: udev_node_mknod: chmod(/dev/capi4, 020660) failed: Read-only file system
udevd-event[2885]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi4': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2886]: delete_path: rmdir(/dev/.udev/names/capi5) failed: Read-only file system
udevd-event[2886]: udev_node_mknod: chmod(/dev/capi5, 020660) failed: Read-only file system
udevd-event[2886]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi5': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2887]: delete_path: rmdir(/dev/.udev/names/capi6) failed: Read-only file system
udevd-event[2887]: udev_node_mknod: chmod(/dev/capi6, 020660) failed: Read-only file system
udevd-event[2887]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi6': File exists
udevd-event[2889]: delete_path: rmdir(/dev/.udev/names/capi8) failed: Read-only file system
udevd-event[2889]: udev_node_mknod: chmod(/dev/capi8, 020660) failed: Read-only file system
udevd-event[2889]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi8': File exists
udevd-event[2888]: delete_path: rmdir(/dev/.udev/names/capi7) failed: Read-only file system
udevd-event[2888]: udev_node_mknod: chmod(/dev/capi7, 020660) failed: Read-only file system
udevd-event[2888]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi7': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2890]: delete_path: rmdir(/dev/.udev/names/capi9) failed: Read-only file system
udevd-event[2890]: udev_node_mknod: chmod(/dev/capi9, 020660) failed: Read-only file system
udevd-event[2890]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fcapi9': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2891]: delete_path: rmdir(/dev/.udev/names/console) failed: Read-only file system
udevd-event[2891]: udev_node_mknod: chmod(/dev/console, 020600) failed: Read-only file system
udevd-event[2891]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fconsole': File exists
udevd-event[2892]: delete_path: rmdir(/dev/.udev/names/ptmx) failed: Read-only file system
udevd-event[2892]: udev_node_mknod: chmod(/dev/ptmx, 020666) failed: Read-only file system
udevd-event[2892]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fptmx': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2893]: delete_path: rmdir(/dev/.udev/names/tty) failed: Read-only file system
udevd-event[2893]: udev_node_mknod: chmod(/dev/tty, 020666) failed: Read-only file system
udevd-event[2893]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2894]: delete_path: rmdir(/dev/.udev/names/tty0) failed: Read-only file system
udevd-event[2894]: udev_node_mknod: chmod(/dev/tty0, 020620) failed: Read-only file system
udevd-event[2894]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty0': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2895]: delete_path: rmdir(/dev/.udev/names/tty1) failed: Read-only file system
udevd-event[2895]: udev_node_mknod: chmod(/dev/tty1, 020620) failed: Read-only file system
udevd-event[2895]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty1': File exists
udevd-event[2896]: delete_path: rmdir(/dev/.udev/names/tty10) failed: Read-only file system
udevd-event[2896]: udev_node_mknod: chmod(/dev/tty10, 020620) failed: Read-only file system
udevd-event[2896]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty10': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2897]: delete_path: rmdir(/dev/.udev/names/tty11) failed: Read-only file system
udevd-event[2897]: udev_node_mknod: chmod(/dev/tty11, 020620) failed: Read-only file system
udevd-event[2897]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty11': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2898]: delete_path: rmdir(/dev/.udev/names/tty12) failed: Read-only file system
udevd-event[2898]: udev_node_mknod: chmod(/dev/tty12, 020620) failed: Read-only file system
udevd-event[2898]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty12': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2899]: delete_path: rmdir(/dev/.udev/names/tty13) failed: Read-only file system
udevd-event[2899]: udev_node_mknod: chmod(/dev/tty13, 020620) failed: Read-only file system
udevd-event[2899]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty13': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2900]: delete_path: rmdir(/dev/.udev/names/tty14) failed: Read-only file system
udevd-event[2900]: udev_node_mknod: chmod(/dev/tty14, 020620) failed: Read-only file system
udevd-event[2900]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty14': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2901]: delete_path: rmdir(/dev/.udev/names/tty15) failed: Read-only file system
udevd-event[2901]: udev_node_mknod: chmod(/dev/tty15, 020620) failed: Read-only file system
udevd-event[2901]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty15': File exists
udevd-event[2903]: delete_path: rmdir(/dev/.udev/names/tty16) failed: Read-only file system
udevd-event[2903]: udev_node_mknod: chmod(/dev/tty16, 020620) failed: Read-only file system
udevd-event[2903]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty16': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2904]: delete_path: rmdir(/dev/.udev/names/tty17) failed: Read-only file system
udevd-event[2904]: udev_node_mknod: chmod(/dev/tty17, 020620) failed: Read-only file system
udevd-event[2904]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty17': File exists
udevd-event[2905]: delete_path: rmdir(/dev/.udev/names/tty18) failed: Read-only file system
udevd-event[2905]: udev_node_mknod: chmod(/dev/tty18, 020620) failed: Read-only file system
udevd-event[2905]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty18': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2907]: delete_path: rmdir(/dev/.udev/names/tty19) failed: Read-only file system
udevd-event[2907]: udev_node_mknod: chmod(/dev/tty19, 020620) failed: Read-only file system
udevd-event[2907]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty19': File exists
udevd-event[2908]: delete_path: rmdir(/dev/.udev/names/tty2) failed: Read-only file system
udevd-event[2908]: udev_node_mknod: chmod(/dev/tty2, 020620) failed: Read-only file system
udevd-event[2908]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty2': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2909]: delete_path: rmdir(/dev/.udev/names/tty20) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2909]: udev_node_mknod: chmod(/dev/tty20, 020620) failed: Read-only file system
udevd-event[2909]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty20': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2910]: delete_path: rmdir(/dev/.udev/names/tty21) failed: Read-only file system
udevd-event[2910]: udev_node_mknod: chmod(/dev/tty21, 020620) failed: Read-only file system
udevd-event[2910]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty21': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2911]: delete_path: rmdir(/dev/.udev/names/tty22) failed: Read-only file system
udevd-event[2911]: udev_node_mknod: chmod(/dev/tty22, 020620) failed: Read-only file system
udevd-event[2911]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty22': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2912]: delete_path: rmdir(/dev/.udev/names/tty23) failed: Read-only file system
udevd-event[2912]: udev_node_mknod: chmod(/dev/tty23, 020620) failed: Read-only file system
udevd-event[2912]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty23': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2914]: delete_path: rmdir(/dev/.udev/names/tty25) failed: Read-only file system
udevd-event[2914]: udev_node_mknod: chmod(/dev/tty25, 020620) failed: Read-only file system
udevd-event[2914]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty25': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2913]: delete_path: rmdir(/dev/.udev/names/tty24) failed: Read-only file system
udevd-event[2913]: udev_node_mknod: chmod(/dev/tty24, 020620) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2913]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty24': File exists
udevd-event[2916]: delete_path: rmdir(/dev/.udev/names/tty27) failed: Read-only file system
udevd-event[2916]: udev_node_mknod: chmod(/dev/tty27, 020620) failed: Read-only file system
udevd-event[2916]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty27': File exists
udevd-event[2915]: delete_path: rmdir(/dev/.udev/names/tty26) failed: Read-only file system
udevd-event[2915]: udev_node_mknod: chmod(/dev/tty26, 020620) failed: Read-only file system
udevd-event[2915]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty26': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2917]: delete_path: rmdir(/dev/.udev/names/tty28) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2917]: udev_node_mknod: chmod(/dev/tty28, 020620) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2917]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty28': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2918]: delete_path: rmdir(/dev/.udev/names/tty29) failed: Read-only file system
udevd-event[2918]: udev_node_mknod: chmod(/dev/tty29, 020620) failed: Read-only file system
udevd-event[2918]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty29': File exists
udevd-event[2919]: delete_path: rmdir(/dev/.udev/names/tty3) failed: Read-only file system
udevd-event[2919]: udev_node_mknod: chmod(/dev/tty3, 020620) failed: Read-only file system
udevd-event[2919]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty3': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2920]: delete_path: rmdir(/dev/.udev/names/tty30) failed: Read-only file system
udevd-event[2920]: udev_node_mknod: chmod(/dev/tty30, 020620) failed: Read-only file system
udevd-event[2920]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty30': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2921]: delete_path: rmdir(/dev/.udev/names/tty31) failed: Read-only file system
udevd-event[2921]: udev_node_mknod: chmod(/dev/tty31, 020620) failed: Read-only file system
udevd-event[2921]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty31': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2922]: delete_path: rmdir(/dev/.udev/names/tty32) failed: Read-only file system
udevd-event[2922]: udev_node_mknod: chmod(/dev/tty32, 020620) failed: Read-only file system
udevd-event[2922]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty32': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2923]: delete_path: rmdir(/dev/.udev/names/tty33) failed: Read-only file system
udevd-event[2923]: udev_node_mknod: chmod(/dev/tty33, 020620) failed: Read-only file system
udevd-event[2924]: delete_path: rmdir(/dev/.udev/names/tty34) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2924]: udev_node_mknod: chmod(/dev/tty34, 020620) failed: Read-only file system
udevd-event[2924]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty34': File exists
udevd-event[2923]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty33': File exists
udevd-event[2925]: delete_path: rmdir(/dev/.udev/names/tty35) failed: Read-only file system
udevd-event[2925]: udev_node_mknod: chmod(/dev/tty35, 020620) failed: Read-only file system
udevd-event[2925]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty35': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2926]: delete_path: rmdir(/dev/.udev/names/tty36) failed: Read-only file system
udevd-event[2926]: udev_node_mknod: chmod(/dev/tty36, 020620) failed: Read-only file system
udevd-event[2926]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty36': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2927]: delete_path: rmdir(/dev/.udev/names/tty37) failed: Read-only file system
udevd-event[2927]: udev_node_mknod: chmod(/dev/tty37, 020620) failed: Read-only file system
udevd-event[2927]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty37': File exists
udevd-event[2929]: delete_path: rmdir(/dev/.udev/names/tty39) failed: Read-only file system
udevd-event[2929]: udev_node_mknod: chmod(/dev/tty39, 020620) failed: Read-only file system
udevd-event[2929]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty39': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2928]: delete_path: rmdir(/dev/.udev/names/tty38) failed: Read-only file system
udevd-event[2928]: udev_node_mknod: chmod(/dev/tty38, 020620) failed: Read-only file system
udevd-event[2928]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty38': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2930]: delete_path: rmdir(/dev/.udev/names/tty4) failed: Read-only file system
udevd-event[2930]: udev_node_mknod: chmod(/dev/tty4, 020620) failed: Read-only file system
udevd-event[2930]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty4': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2931]: delete_path: rmdir(/dev/.udev/names/tty40) failed: Read-only file system
udevd-event[2931]: udev_node_mknod: chmod(/dev/tty40, 020620) failed: Read-only file system
udevd-event[2931]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty40': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2933]: delete_path: rmdir(/dev/.udev/names/tty42) failed: Read-only file system
udevd-event[2933]: udev_node_mknod: chmod(/dev/tty42, 020620) failed: Read-only file system
udevd-event[2933]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty42': File exists
udevd-event[2934]: delete_path: rmdir(/dev/.udev/names/tty43) failed: Read-only file system
udevd-event[2934]: udev_node_mknod: chmod(/dev/tty43, 020620) failed: Read-only file system
udevd-event[2932]: delete_path: rmdir(/dev/.udev/names/tty41) failed: Read-only file system
udevd-event[2934]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty43': File exists
udevd-event[2932]: udev_node_mknod: chmod(/dev/tty41, 020620) failed: Read-only file system
udevd-event[2932]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty41': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2935]: delete_path: rmdir(/dev/.udev/names/tty44) failed: Read-only file system
udevd-event[2935]: udev_node_mknod: chmod(/dev/tty44, 020620) failed: Read-only file system
udevd-event[2935]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty44': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2937]: delete_path: rmdir(/dev/.udev/names/tty46) failed: Read-only file system
udevd-event[2937]: udev_node_mknod: chmod(/dev/tty46, 020620) failed: Read-only file system
udevd-event[2937]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty46': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2936]: delete_path: rmdir(/dev/.udev/names/tty45) failed: Read-only file system
udevd-event[2936]: udev_node_mknod: chmod(/dev/tty45, 020620) failed: Read-only file system
udevd-event[2936]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty45': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2938]: delete_path: rmdir(/dev/.udev/names/tty47) failed: Read-only file system
udevd-event[2938]: udev_node_mknod: chmod(/dev/tty47, 020620) failed: Read-only file system
udevd-event[2938]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty47': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2939]: delete_path: rmdir(/dev/.udev/names/tty48) failed: Read-only file system
udevd-event[2940]: delete_path: rmdir(/dev/.udev/names/tty49) failed: Read-only file system
udevd-event[2939]: udev_node_mknod: chmod(/dev/tty48, 020620) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2939]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty48': File exists
udevd-event[2940]: udev_node_mknod: chmod(/dev/tty49, 020620) failed: Read-only file system
udevd-event[2940]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty49': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2941]: delete_path: rmdir(/dev/.udev/names/tty5) failed: Read-only file system
udevd-event[2941]: udev_node_mknod: chmod(/dev/tty5, 020620) failed: Read-only file system
udevd-event[2941]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty5': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2942]: delete_path: rmdir(/dev/.udev/names/tty50) failed: Read-only file system
udevd-event[2942]: udev_node_mknod: chmod(/dev/tty50, 020620) failed: Read-only file system
udevd-event[2942]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty50': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2943]: delete_path: rmdir(/dev/.udev/names/tty51) failed: Read-only file system
udevd-event[2943]: udev_node_mknod: chmod(/dev/tty51, 020620) failed: Read-only file system
udevd-event[2943]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty51': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2944]: delete_path: rmdir(/dev/.udev/names/tty52) failed: Read-only file system
udevd-event[2944]: udev_node_mknod: chmod(/dev/tty52, 020620) failed: Read-only file system
udevd-event[2944]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty52': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2945]: delete_path: rmdir(/dev/.udev/names/tty53) failed: Read-only file system
udevd-event[2945]: udev_node_mknod: chmod(/dev/tty53, 020620) failed: Read-only file system
udevd-event[2945]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty53': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2946]: delete_path: rmdir(/dev/.udev/names/tty54) failed: Read-only file system
udevd-event[2946]: udev_node_mknod: chmod(/dev/tty54, 020620) failed: Read-only file system
udevd-event[2946]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty54': File exists
udevd-event[2947]: delete_path: rmdir(/dev/.udev/names/tty55) failed: Read-only file system
udevd-event[2947]: udev_node_mknod: chmod(/dev/tty55, 020620) failed: Read-only file system
udevd-event[2947]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty55': File exists
udevd-event[2948]: delete_path: rmdir(/dev/.udev/names/tty56) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2948]: udev_node_mknod: chmod(/dev/tty56, 020620) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2949]: delete_path: rmdir(/dev/.udev/names/tty57) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2949]: udev_node_mknod: chmod(/dev/tty57, 020620) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2949]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty57': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2948]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty56': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2950]: delete_path: rmdir(/dev/.udev/names/tty58) failed: Read-only file system
udevd-event[2950]: udev_node_mknod: chmod(/dev/tty58, 020620) failed: Read-only file system
udevd-event[2950]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty58': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2951]: delete_path: rmdir(/dev/.udev/names/tty59) failed: Read-only file system
udevd-event[2951]: udev_node_mknod: chmod(/dev/tty59, 020620) failed: Read-only file system
udevd-event[2951]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty59': File exists
udevd-event[2952]: delete_path: rmdir(/dev/.udev/names/tty6) failed: Read-only file system
udevd-event[2952]: udev_node_mknod: chmod(/dev/tty6, 020620) failed: Read-only file system
udevd-event[2952]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty6': File exists
udevd-event[2953]: delete_path: rmdir(/dev/.udev/names/tty60) failed: Read-only file system
udevd-event[2953]: udev_node_mknod: chmod(/dev/tty60, 020620) failed: Read-only file system
udevd-event[2953]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty60': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2954]: delete_path: rmdir(/dev/.udev/names/tty61) failed: Read-only file system
udevd-event[2954]: udev_node_mknod: chmod(/dev/tty61, 020620) failed: Read-only file system
udevd-event[2954]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty61': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2955]: delete_path: rmdir(/dev/.udev/names/tty62) failed: Read-only file system
udevd-event[2955]: udev_node_mknod: chmod(/dev/tty62, 020620) failed: Read-only file system
udevd-event[2955]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty62': File exists
udevd-event[2956]: delete_path: rmdir(/dev/.udev/names/tty63) failed: Read-only file system
udevd-event[2956]: udev_node_mknod: chmod(/dev/tty63, 020620) failed: Read-only file system
udevd-event[2956]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty63': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2957]: delete_path: rmdir(/dev/.udev/names/tty7) failed: Read-only file system
udevd-event[2957]: udev_node_mknod: chmod(/dev/tty7, 020620) failed: Read-only file system
udevd-event[2957]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty7': File exists
udevd-event[2958]: delete_path: rmdir(/dev/.udev/names/tty8) failed: Read-only file system
udevd-event[2958]: udev_node_mknod: chmod(/dev/tty8, 020620) failed: Read-only file system
udevd-event[2958]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty8': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2959]: delete_path: rmdir(/dev/.udev/names/tty9) failed: Read-only file system
udevd-event[2959]: udev_node_mknod: chmod(/dev/tty9, 020620) failed: Read-only file system
udevd-event[2959]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2ftty9': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2960]: delete_path: rmdir(/dev/.udev/names/ttyS0) failed: Read-only file system
udevd-event[2960]: udev_node_mknod: chmod(/dev/ttyS0, 020660) failed: Read-only file system
udevd-event[2960]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fttyS0': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2961]: delete_path: rmdir(/dev/.udev/names/ttyS1) failed: Read-only file system
udevd-event[2961]: udev_node_mknod: chmod(/dev/ttyS1, 020660) failed: Read-only file system
udevd-event[2961]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fttyS1': File exists
udevd-event[2962]: delete_path: rmdir(/dev/.udev/names/ttyS2) failed: Read-only file system
udevd-event[2962]: udev_node_mknod: chmod(/dev/ttyS2, 020660) failed: Read-only file system
udevd-event[2962]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fttyS2': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2963]: delete_path: rmdir(/dev/.udev/names/ttyS3) failed: Read-only file system
udevd-event[2963]: udev_node_mknod: chmod(/dev/ttyS3, 020660) failed: Read-only file system
udevd-event[2963]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2ftty\x2fttyS3': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2964]: delete_path: rmdir(/dev/.udev/names/usbmon0) failed: Read-only file system
udevd-event[2964]: udev_node_mknod: mknod(/dev/usbmon0.udev-tmp, 020660, 243, 0) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2965]: delete_path: rmdir(/dev/.udev/names/vcs) failed: Read-only file system
udevd-event[2965]: udev_node_mknod: chmod(/dev/vcs, 020660) failed: Read-only file system
udevd-event[2965]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fvc\x2fvcs': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2966]: delete_path: rmdir(/dev/.udev/names/vcs1) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2967]: delete_path: rmdir(/dev/.udev/names/vcsa) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2968]: delete_path: rmdir(/dev/.udev/names/vcsa1) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd-event[2966]: udev_node_mknod: chmod(/dev/vcs1, 020660) failed: Read-only file system
udevd-event[2966]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fvc\x2fvcs1': File exists
udevd-event[2967]: udev_node_mknod: chmod(/dev/vcsa, 020660) failed: Read-only file system
udevd-event[2967]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fvc\x2fvcsa': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd-event[2968]: udev_node_mknod: chmod(/dev/vcsa1, 020660) failed: Read-only file system
udevd-event[2968]: udev_db_add_device: unable to create db link '/dev/.udev/db/\x2fclass\x2fvc\x2fvcsa1': File exists
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
[   75.878357] eth1: link down
[   75.880320] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   77.037259] IPv4 FIB: Using LC-trie version 0.409
udevd[1818]: delete_path: rmdir(/dev/.udev/failed) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
udevd[1818]: delete_path: rmdir(/dev/.udev/queue) failed: Read-only file system
[   86.206671] eth0: no IPv6 routers present
Wait timeout. Will continue in the background.[FAILED]
Loading default keymap (us): [  OK  ]
Setting hostname mercury:  [  OK  ]
/proc/misc: No entry for device-mapper found
Is device-mapper driver missing from kernel?
device-mapper: version ioctl failed: Inappropriate ioctl for device
/proc/misc: No entry for device-mapper found
Is device-mapper driver missing from kernel?
device-mapper: version ioctl failed: Inappropriate ioctl for device
Command failed
Setting up Logical Volume Management:   No volume groups found
[  OK  ]
Checking filesystems
Checking all file systems.
[/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a /dev/sda6 
/1: Superblock last mount time is in the future.  FIXED.
/1: Superblock last write time is in the future.  FIXED.
/1: clean, 375726/7325696 files, 3537874/7325632 blocks
[/sbin/fsck.ext3 (1) -- /home] fsck.ext3 -a /dev/sda5 
/home: recovering journal
/home: Superblock last mount time is in the future.  FIXED.
/home: clean, 135356/6111232 files, 2597941/12209392 blocks
[  OK  ]
Remounting root filesystem in read-write mode:  [  227.723047] EXT3 FS on sda6, internal journal
[  OK  ]
Mounting local filesystems:  [  227.830167] kjournald starting.  Commit interval 5 seconds
[  227.830160] EXT3 FS on sda5, internal journal
[  227.830160] EXT3-fs: mounted filesystem with writeback data mode.
mount: wrong fs type, bad option, bad superblock on tmpfs,
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Note the timestamp difference:

 Starting udev: [   33.864015] fgrep used greatest stack depth: 3000 bytes left
 [  227.830160] EXT3 FS on sda5, internal journal

3.2 minutes for udev startup!

So i absolutely love the concept of devtmpfs, it might bring us out of 
this insanity of decoupling /dev device node init from kernel device 
init.

I do buy 'policy does not belong into the kernel' arguments anytime, but 
not if they result in absolute _unusable crappy situations_ like this. 
Decouple if you wish to, but heck, offer a workable solution - udev isnt 
one.

And note the first instinctive answer that was offered in this thread: 
'well, dont boot a new kernel on that old distro then'. That's not 
really acceptable - Fedora Core 6 is not _that_ old and we really dont 
want to restrict the kernel's window of compatibility to just a year or 
two.

And it's not like udev makes any sense without the kernel - so why is it 
a separate project, why do we allow users to suffer by a senseless cut 
of interfaces and the resulting version friction and upgrade mess?

In that sense i always liked the basic notion of devfs: self-contained 
kernel init. (What i hated about devfs was its implementation - whose 
suckiness had nothing to do with the principles of it.)

And yes, i realize that the devtmpfs authors probably did not envision 
this outcome - but i do hope devtmpfs results in either eliminating 
udev, or attracting it into the kernel repo. (which, to me, are 
basically the same thing technically.)

	Ingo
