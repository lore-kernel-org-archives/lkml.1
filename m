Return-Path: <linux-kernel-owner+w=401wt.eu-S1422834AbXBHBMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422834AbXBHBMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 20:12:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422855AbXBHBMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 20:12:08 -0500
Received: from raven.upol.cz ([158.194.120.4]:35583 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422834AbXBHBMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 20:12:07 -0500
Date: Thu, 8 Feb 2007 02:20:49 +0100
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, torvalds@osdl.org,
       sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: discussion of Kbuild fixes (kbuild: Kbuild.include avoid using spaces in call arguments)
Message-ID: <20070208012049.GE22699@flower.upol.cz>
References: <20070207165204.GA5537@martell.zuzino.mipt.ru> <Pine.LNX.4.64.0702071846180.14457@scrub.home> <20070207220435.GC22699@flower.upol.cz> <Pine.LNX.4.64.0702080029030.14457@scrub.home> <20070207153848.e02d355d.randy.dunlap@oracle.com> <Pine.LNX.4.64.0702080051520.14457@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702080051520.14457@scrub.home>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 01:00:44AM +0100, Roman Zippel wrote:
> Hi,
> 
> On Wed, 7 Feb 2007, Randy Dunlap wrote:
> 
> > > > > Linus, please revert. Thanks.
> > > >  
> > > > Roman, while it went so fast to Linus, i didn't expect that, let me
> > > > try to fix all this with this little patch.
> > > 
> > > Sorry, it needs more changes, the patch simply wasn't ready.
> > 
> > Can you be more explicit?  and then it should get some time
> > in -mm, hopefully.
> 
> I did already. It needs to be splitted,

i did that patch for ultrasonic testers of Linus's tree. Shame on me,
because, i was sure, that... whatever. This is where i thought, that i
almost understand it all, but another huge level of complexity was
revealed (even it's just a whitespace ;).

I've started to split changes,

> lose the symlink stuff and be more careful with whitespace. It probably
> could use a better name than checker-shell, e.g. autoconf calls this
> TRY_RUN, so something like this.

but i can't understand you, Roman, against:

-- `find | sort' in localversion (i insist on split between paths and
    files)

-- symlinks to /dev/null in option checking -- isn't it better to not
   have any (though cached) access to files on filesystem, instead of to
   /dev/null? cont.:
 
Anyway, i think, it's better than before, that now all is one place, and
can be named as you wish. Any further changes, like common `tmp'
directory are easy to fix. Readable form, easy to test/debug:

add `-x' to `set' or `echo >gcc-checks.txt', and you will get output, you wish.

IMHO it's good, while arch specific gcc checking already done (:

I wish to have more people to work on this (even with just comments),
because "Kbuild.include" was only first step to reduce bloated top
Makefile. Since then, it seems, Sam have more important things to do.

If further work is useful, i will be glad if you think so.

Thanks.
____
