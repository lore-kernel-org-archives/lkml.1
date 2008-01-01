Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbYAAR6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbYAAR6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 12:58:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbYAAR5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 12:57:54 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:57402 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbYAAR5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 12:57:54 -0500
Date: Tue, 1 Jan 2008 18:57:54 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andreas Schwab <schwab@suse.de>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-mips@linux-mips.org
Subject: Re: [Patch 2/8] MIPS: Remove 'TOPDIR' from Makefiles
Message-ID: <20080101175754.GC31575@uranus.ravnborg.org>
References: <20080101071311.GA2496@hacking> <20080101072238.GC2496@hacking> <20080101101540.GB28913@uranus.ravnborg.org> <jefxxhlkxb.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jefxxhlkxb.fsf@sykes.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 02:44:48PM +0100, Andreas Schwab wrote:
> Sam Ravnborg <sam@ravnborg.org> writes:
> 
> >> @@ -24,7 +24,7 @@ HEAD_DEFINES := -D_kernel_start=0x$(KERNEL_START) \
> >>  		-D TIMESTAMP=$(shell date +%s)
> >>  
> >>  $(obj)/head.o: $(obj)/head.S $(KERNEL_IMAGE)
> >> -	$(CC) -fno-pic $(HEAD_DEFINES) -I$(TOPDIR)/include -c -o $@ $<
> >> +	$(CC) -fno-pic $(HEAD_DEFINES) -I$(objtree)/include -c -o $@ $<
> > This has never worked with O=.. builds.
> > The correct fix here is to use:
> >> +	$(CC) -fno-pic $(HEAD_DEFINES) -Iinclude -Iinclude2 -c -o $@ $<
> >
> > The -Iinclude2 is only for O=... builds so to keep current
> > behaviour removing $(TOPDIR)/ would do it.
> 
> Shouldn't that use $(LINUXINCLUDE), or $(KBUILD_CPPFLAGS)?
It would be better to use $(LINUXINCLUDE) as we then pull in all config
symbols too and do not have to hardcode kbuild internal names (include2).

As for the use of KBUILD_CPPFLAGS at present the usage is not consistent
across the architectures. Why does arm for example say:
KBUILD_CPPFLAGS       += -mbig-endian

This looks like a KBUILD_CFLAGS thing to me.

So we should preferably stick with LINUXINCLUDE for now.

	Sam
