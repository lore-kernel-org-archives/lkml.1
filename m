Return-Path: <linux-kernel-owner+w=401wt.eu-S1752266AbZJWU7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbZJWU7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 16:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbZJWU7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 16:59:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54587 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZJWU7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 16:59:34 -0400
Date: Fri, 23 Oct 2009 22:59:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: NiTRo <nitroml@ntd.homelinux.org>
Cc: linux-kernel@vger.kernel.org, cve@mitre.org
Subject: Re: SECURITY PROBLEM: filesystem permiossion bypass on FD already
 opened
Message-ID: <20091023205932.GA28593@elf.ucw.cz>
References: <4AE20B6F.4060606@ntd.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE20B6F.4060606@ntd.homelinux.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-10-23 22:00:47, NiTRo wrote:
> Hi to all,
>     Sorry for my bad english.
>     Just discovered this security problem on my Suse 11 (Linux xxxx
> 2.6.25.18-0.2-pae #1 SMP 2008-10-21 16:30:26 +0200 i686 i686 i386
> GNU/Linux) and my Slackware 10.1.0 (Linux xxxx 2.4.29-ow1 #1 Wed Feb 2
> 00:05:42 CET 2005 i586 unknown unknown GNU/Linux) with OpenWall patch.
> If a FD is opened on a allowed file and then the permission is changed
> the file is still redeable starting from the already read position to
> the EOF.

There's no reason you could not even seek. And no, it is not a
problem, it is just how unix works.
								Pavel


> This is the scenario:
> 
> <root> creates a file /tmp/aaaa with 666 permission an with the "test"
> string inside it
>         xxx:/tmp # echo test > /tmp/aaaa
>         xxx:/tmp # chmod 666 /tmp/aaaa
> <sb> opens this file hooking it in a shell as FD number 3
>         sb@xxx:~> bash 3< /tmp/aaaa
> <sb> read and prints it
>         sb@xxx:~> read a <&3
>         sb@xxx:~> echo $a
>         test
>         sb@xxx:~>
> ...anythig as expected...
> <root> changes the permissions on file to 600 and changes its content
> into "test o.o I cannot believe it..."
>         xxx:/tmp # chmod 600 /tmp/aaaa
>         xxx:/tmp # echo "test o.o I cannot believe it..." > /tmp/aaaa
> <sb> continue to try reading the file
>         sb@xxx:~> read a <&3
>         sb@xxx:~> echo $a
>         o.o I cannot believe it...
>         sb@test:~>
> ... and this is not expected...

But it should be :-).
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
