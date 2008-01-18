Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbYARIWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbYARIWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 03:22:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYARIV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 03:21:56 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47353 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750853AbYARIVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 03:21:55 -0500
Date: Fri, 18 Jan 2008 00:21:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dave Young" <hidave.darkstar@gmail.com>
Cc: "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>,
       linux-kernel@vger.kernel.org, "Zan Lynx" <zlynx@acm.org>,
       "Ingo Molnar" <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [2.6.24-rc8-mm1] Locking API boot-time self-tests hangs.
Message-Id: <20080118002152.c9e76c51.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0801172259s3377895dwb0b2ca1dd781d11b@mail.gmail.com>
References: <200801180120.m0I1KBuC065806@www262.sakura.ne.jp>
	<20080117181935.02294863.akpm@linux-foundation.org>
	<200801180319.m0I3Ju9N089501@www262.sakura.ne.jp>
	<20080117204247.5318e500.akpm@linux-foundation.org>
	<200801180640.m0I6enPI029212@www262.sakura.ne.jp>
	<a8e1da0801172259s3377895dwb0b2ca1dd781d11b@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008 14:59:32 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:

> On Jan 18, 2008 2:40 PM, Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
> > Hello.
> >
> > Andrew Morton wrote:
> > > It could be compiler version dependent.  I used gcc-4.1.0.  Which version
> > > were you and Zan using please?
> 
> I have the same problem, gcc 3.4.6
> 
> >
> > I'm using gcc 3.3.5 on Debian/Sarge .
> >
> > By the way, 2.6.24-rc8-mm1 doesn't hang with a kernel config
> >
> > # make -s allnoconfig
> > # make -s menuconfig
> >
> >   Set [*] to all entries in "Kernel hacking  --->" section
> >   (except "KGDB: kernel debugging with remote gdb").
> >
> > # make -s && make -s install

The only machine I have with gcc-3.x takes an amazing amount of time to
compile a quite minimal kernel then barfs in headers_install with

  CHK     include/linux/version.h
make[1]: `scripts/unifdef' is up to date.
make[1]: *** No rule to make target `|', needed by `asm-generic'.  Stop.

which is a mainline bug, too.  ISTR someone else reported it but I don't
recall it getting fixed.

I think I'll give up on this.  Either someone else fixes it or we merge the
bug into mainline.
