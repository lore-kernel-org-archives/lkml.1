Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbZGIKTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbZGIKTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 06:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756453AbZGIKTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 06:19:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58949 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802AbZGIKTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 06:19:37 -0400
Date: Thu, 9 Jul 2009 12:19:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: David Howells <dhowells@redhat.com>, rgetz@blackfin.uclinux.org,
       lethal@linux-sh.org, gerg@uclinux.org,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FDPIC: Ignore the loader's PT_GNU_STACK when
	calculating the stack size
Message-ID: <20090709101930.GJ10937@elf.ucw.cz>
References: <20090704024606.GE1345@ucw.cz> <20090701120814.30741.10146.stgit@warthog.procyon.org.uk> <24530.1247050900@redhat.com> <20090704033429.GA1799@ucw.cz> <8bd0f97a0907081148vc716eeepfdaf8178b1ecbce1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0907081148vc716eeepfdaf8178b1ecbce1@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-07-08 14:48:51, Mike Frysinger wrote:
> On Fri, Jul 3, 2009 at 23:34, Pavel Machek wrote:
> > On Wed 2009-07-08 12:01:40, David Howells wrote:
> >> Pavel Machek <pavel@ucw.cz> wrote:
> >>
> >> > The patch seems wrong to me; loader needs the stack, too, right?
> >> >
> >> > What about making sure that the loader specifies reasonable stack
> >> > size, instead?
> >>
> >> The loader doesn't need its own stack, unless it _is_ the executable.  It uses
> >> the executable's stack.  The problem is that the executable and the loader can
> >> both specify the stack size for NOMMU, but which one do we pick, or do we
> >> consider both.
> >
> > Imageine loader needs 64K, while executable only needs 4K. You surely
> > want to execute it with 64K stack, because it will not fit into 4K?
> 
> i really dont think this is realistic.  there is exactly one ldso that
> everyone uses under FDPIC ELF, and it needs a very minuscule stack.

Not very realistic; but that argues that the patch is NOP.

And if it _is_ realistic, the patch adds a bug.

=> patch is bad idea.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
