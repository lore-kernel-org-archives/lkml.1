Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbXICVeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbXICVeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 17:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbXICVeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 17:34:00 -0400
Received: from barikada.upol.cz ([158.194.242.200]:48482 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbXICVd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 17:33:59 -0400
Date: Mon, 3 Sep 2007 23:48:59 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Rob Landley <rob@landley.net>, Jan Engelhardt <jengelh@computergmbh.de>,
       linux-kernel@vger.kernel.org
Subject: Re: kconfig/kbuild rewite (Re: What's up with CONFIG_BLK_DEV?)
Message-ID: <20070903214859.GW475@flower.upol.cz>
References: <200708241517.28475.rob@landley.net> <Pine.LNX.4.64.0708242234250.28540@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0708242234500.28540@fbirervta.pbzchgretzou.qr> <200708260108.28584.rob@landley.net> <E1IRcvF-0007yi-73@flower> <20070902115150.GB30207@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070902115150.GB30207@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2007 at 01:51:50PM +0200, Sam Ravnborg wrote:
[]
> Then as now you have not yet expalined what you are trying to do.
> Nevertheless I look forward for a minmal set of patches that improve
> whatever you are working with.

Yes, because it's LKML, that wants not-hand-waving stuff in first
place. But recent kevent, scheduler stuff shows
inflexibility/agendas, though.

That examples were bad WRT kernel production infrastructure. Even then i
doubt, i must waste everyone's time with details, only goals.

> As for Kconfig the low hanging fruits are not in the tools but in the
> structure of the Kconfig files. There are a lot that can be improved
> with a decent effort but nobody has stepped up doing so.
> The tools could be better too but if the root problem is the structure
> of the Kconfig files this is where we should focus and not on the tools.

In my view this all interconnected. Designing flexible and easy
configuration system yields dramatic changes to the build one as well.

* profiles non/debug, non/production

* per file, per algorithm tuning
  * efficiency
    * choosing structure sizes
    * selecting fast/slow paths
    * per case choosing need/dead code
    * various parameters
  * optimization
    * per compiler/version
      * option profiles
      * feature/warning sets
    * linker
      * is there anything alternative?

* distributed development
  * open possibility to work in any part of the tree
    * making changes and quickly having
      * config (dependency, etc.) set/UI ready
      * per profile/option test builds
        (e.g. making return->goto or loop change and quickly getting -O0,
        -O2, -Os images; check size; have userspace testing skeleton -> have
	runtime test)
    * integration with quilt-like source/patch managers ``here''
  * allow per architecture development
    * small source tree
    * developer's profiles, that will have exact feature/tuning/build
      config options results for everybody within given source tree version
      (for easy testing, but not "send me your .config; what binutils?..")

* base set of tools to have easy to configure alternatives
  * shell
    to use basic POSIX (plus accepted, not NIH like in bash) features
    (i have some examples; unfortunately even basic set behaves
     differently and buggy)
  * make
    stat() wrapper executing shell everywhere; of course there are
    some features, but anyway, interface for it and the like is needed
  * perl/python/ruby
    establish text processing rules
  * coreutils/busybox/etc
    non is perfect, having replacement mechanism allows faster debug
    and enhancement of their own development and testing

* UI
  (maybe next time)
  
  Only one thing. I don't have time and will to study all that
  ncurses/slang/qt/gtk/AJAX/whatever stuff. I wanted to do basic terminal
  or text/stream editor friendly user interface. As for the former, i
  just upset about software capabilities of the todays terminal
  emulators. I'm fine with exchanging escape sequences, but all that
  inherited TEKTRONIX 4010, APL, HP2645, Microterm ACT-IV, Ann Arbor
  4080, LSI ADM-3a (man terminfo) legacy without even a hint of progress
  last 20 years is just dead.
  
  I likely to end up with shell script generation, that will be
  available for everybody who knows shell and have ordinary text editor.

  autoconf/configure inside out? Maybe, but at least from the new sheet of
  paper, with good background in history and basic text processing tools.

Just in case anybody cares about how ugly modern software development is
(INA software industry dude, and may be just crazy, of course). Well,
recent Rusty's gig may give a clue, how things may look different.

> For Kbuild I fail to see anything that demand a rewrite from a structure
> view of the Kbuild files.
> The Kbuild internal stuff is antoehr story - here a rewrite to a saner
> language then GNU make syntax could improve hackability a lot.
____
