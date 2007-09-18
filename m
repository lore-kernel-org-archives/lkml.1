Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbXIRU0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbXIRU0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 16:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbXIRU0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 16:26:32 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:59436 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037AbXIRU0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 16:26:31 -0400
Date: Tue, 18 Sep 2007 22:26:54 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Miles Lane <miles.lane@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: 2.6.23-rc6-mm1
Message-ID: <20070918202654.GA27836@uranus.ravnborg.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <a44ae5cd0709180827w7156dc17q13853c3f2c127142@mail.gmail.com> <20070918191741.GA27725@uranus.ravnborg.org> <a44ae5cd0709181242j517e39e0xc3f78224bcda360a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a44ae5cd0709181242j517e39e0xc3f78224bcda360a@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 03:42:58PM -0400, Miles Lane wrote:
> On 9/18/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> > Hi Miles.
> > On Tue, Sep 18, 2007 at 11:27:23AM -0400, Miles Lane wrote:
> > > Selecting Help for "Subarchitecture Type" causes "make menuconfig" to
> > > crash, and the bash display settings have to be reset.
> >
> > Not reproduceable here.
> > But I noticed that we pass a null pointer to a vsprintf function which
> > in the cases you pointed out printed a (null) at my system.
> > Could you plase try if attached patch fix your system.
> 
> Sorry, it still crashes.  I am running Ubuntu pre-6.10 (Gutsy -- the
> development version of the distro).  Maybe I should try "make
> mrproper" first?

make mrproper should not do any difference here.
I rather think you hit some ncurses bug.

If you could add '-g' to HOSTCFLAGS in top-level Makefile
and then do:
rm scripts/kconfig/mconf.o scripts/kconfig/mconf
make menuconfig

(to build mconf and to check that the error is still reproduceable).
And then run it in a debugger like this:
gdb scripts/kconfig/mconf
run arch/x86_64/Kconfig
         ^^^^^^ replace with your actual arch

Provoke the error and get a back-trace with 'bt'.

Thanks,
	Sam
