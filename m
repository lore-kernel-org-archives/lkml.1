Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbXEXVLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbXEXVLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbXEXVLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:11:44 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:45435 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbXEXVLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:11:43 -0400
Date: Thu, 24 May 2007 23:12:37 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Romano Giannetti <romano.giannetti@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk
Subject: Re: Long delay in resume from RAM (Was Re: [patch 00/69] -stablereview)
Message-ID: <20070524211237.GC1372@uranus.ravnborg.org>
References: <4652070D.3090509@redhat.com> <alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org> <20070521212522.GL3429@sequoia.sous-sol.org> <1179870110.16656.2.camel@localhost> <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org> <1180008394.15600.26.camel@localhost> <1180019201.15600.57.camel@localhost> <alpine.LFD.0.98.0705240815530.26602@woody.linux-foundation.org> <1180037649.15241.6.camel@localhost> <20070524140154.c8e93d69.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524140154.c8e93d69.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 02:01:54PM -0700, Andrew Morton wrote:
> On Thu, 24 May 2007 22:14:08 +0200
> Romano Giannetti <romano.giannetti@gmail.com> wrote:
> 
> > Compiling now. I had lost a lot of time because at first try it stopped
> > in ntfs:
> > 
> >   CC [M]  fs/ntfs/super.o
> > fs/ntfs/super.c: In function ___init_ntfs_fs___:
> > fs/ntfs/super.c:3152: error: expected ___)___ before ___NTFS_VERSION___
> > fs/ntfs/super.c: At top level:
> > fs/ntfs/super.c:3262: error: expected ___,___ or ___;___ before ___NTFS_VERSION___
> > make[2]: *** [fs/ntfs/super.o] Error 1
> > make[1]: *** [fs/ntfs] Error 2
> > make: *** [fs] Error 2
> >   
> > I suppose because NTFS_VERSION were defined as EXTRA_CFLAGS too in the Makefile, 
> 
> ntfs is being naughty.
> 
> --- a/fs/ntfs/Makefile~a
> +++ a/fs/ntfs/Makefile
> @@ -6,7 +6,7 @@ ntfs-objs := aops.o attrib.o collate.o c
>  	     index.o inode.o mft.o mst.o namei.o runlist.o super.o sysctl.o \
>  	     unistr.o upcase.o
>  
> -EXTRA_CFLAGS = -DNTFS_VERSION=\"2.1.28\"
> +EXTRA_CFLAGS += -DNTFS_VERSION=\"2.1.28\"
>  
>  ifeq ($(CONFIG_NTFS_DEBUG),y)
>  EXTRA_CFLAGS += -DDEBUG
> _
> 
> 
> akpm:/usr/src/linux-2.6.22-rc2> grep -r EXTRA_CFLAGS . | fgrep '+=' | wc -l 
> 131
> akpm:/usr/src/linux-2.6.22-rc2> grep -r EXTRA_CFLAGS . | fgrep -v '+=' | wc -l 
> 55
> 
> hm, lots of Makefiles commit the same sin.  Sam, is this as busted as
> I think it is?

I really cannot see why it makes a difference.
If you use += (and :=) make will resolve EXTRA_CFLAGS when it see it.
Whereas with = make will resolve it only when actually referenced.

But the way we use EXTRA_CFLAGS it should not matter.
If the fix above really helps nfs I need to take a closer look tomorrow.

	Sam
