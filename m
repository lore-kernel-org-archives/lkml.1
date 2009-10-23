Return-Path: <linux-kernel-owner+w=401wt.eu-S1752322AbZJWUzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbZJWUzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 16:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZJWUzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 16:55:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47266 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbZJWUzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 16:55:20 -0400
Date: Fri, 23 Oct 2009 22:54:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: NiTRo <nitroml@ntd.homelinux.org>, linux-kernel@vger.kernel.org,
       cve@mitre.org, Jamie Lokier <jamie@shareable.org>
Subject: Re: SECURITY PROBLEM: filesystem permiossion bypass on FD already
 opened
Message-ID: <20091023205418.GF27185@elf.ucw.cz>
References: <4AE20B6F.4060606@ntd.homelinux.org>
 <20091023204442.GA7332@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091023204442.GA7332@joi.lan>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-10-23 22:44:44, Marcin Slusarz wrote:
> On Fri, Oct 23, 2009 at 10:00:47PM +0200, NiTRo wrote:
> > Hi to all,
> >     Sorry for my bad english.
> >     Just discovered this security problem on my Suse 11 (Linux xxxx
> 
> You did not.
> http://lkml.org/lkml/2009/10/23/159

Actually, no, this is something different... and old/known AFAICT.

> > 2.6.25.18-0.2-pae #1 SMP 2008-10-21 16:30:26 +0200 i686 i686 i386
> > GNU/Linux) and my Slackware 10.1.0 (Linux xxxx 2.4.29-ow1 #1 Wed Feb 2
> > 00:05:42 CET 2005 i586 unknown unknown GNU/Linux) with OpenWall patch.
> > If a FD is opened on a allowed file and then the permission is changed
> > the file is still redeable starting from the already read position to
> > the EOF.
> > 
> > This is the scenario:
> > 
> > <root> creates a file /tmp/aaaa with 666 permission an with the "test"
> > string inside it
> >         xxx:/tmp # echo test > /tmp/aaaa
> >         xxx:/tmp # chmod 666 /tmp/aaaa
> > <sb> opens this file hooking it in a shell as FD number 3
> >         sb@xxx:~> bash 3< /tmp/aaaa
> > <sb> read and prints it
> >         sb@xxx:~> read a <&3
> >         sb@xxx:~> echo $a
> >         test
> >         sb@xxx:~>
> > ...anythig as expected...
> > <root> changes the permissions on file to 600 and changes its content
> > into "test o.o I cannot believe it..."
> >         xxx:/tmp # chmod 600 /tmp/aaaa
> >         xxx:/tmp # echo "test o.o I cannot believe it..." > /tmp/aaaa
> > <sb> continue to try reading the file
> >         sb@xxx:~> read a <&3
> >         sb@xxx:~> echo $a
> >         o.o I cannot believe it...
> >         sb@test:~>
> > ... and this is not expected...


Really? I'd expect it. I have file open for reading, you wrote
something new to it, so I can read it back. What is the problem?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
