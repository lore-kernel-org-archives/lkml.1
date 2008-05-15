Return-Path: <linux-kernel-owner+w=401wt.eu-S1758937AbYEON5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937AbYEON5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 09:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYEON5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 09:57:37 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:13178 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbYEON5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 09:57:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=MuLNfPzayi0XUnaVkc1oySalx7oe/E1wVAxQFJLmaRGLdBGFLWxOvcT2gM13+kL8Q2TK2aHjJ/0SXqf3lFM7Z90+Xg49d0/dK6MAozriNpDGyQJdU5nqbXTqkIFHzNmBdD8Jm9zQ3ckE5Of+Inrd/LZAlm8UiE5cZ3Llufod/Cg=
Message-ID: <2473b43f0805150657q16af99d4r81a9427a7db17edb@mail.gmail.com>
Date: Thu, 15 May 2008 07:57:34 -0600
From: "Adam Olsen" <arolsen@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Strange NFS+GD problem with kernel 2.6.24-16-server (on Hardy)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm having an issue with perl and libgd reading TrueType fonts over an
NFS mount.

The NFS server is an Isilon cluster (I believe they are based on FreeBSD 6.1?)
The client is a machine that's just been updated to Hardy.
  * Kernel 2.6.24-16-server
  * libgd-gd2-perl 2.35-1
  * libgd2-xpm 2.0.35

The issue is this:  using libgd via a perl script, I try writing text
to an image in a font, specified by a file name (the font is located
on the remote NFS server).  The script says that it cannot locate the
font.  The client machine does not have any other known problems with
the NFS share, it can read and write other files just fine.   We have
several other machines that are reading this same share, though they
are running kernel 2.6.24 from Gutsy (I confirmed that a downgrade to
2.6.24 on Hardy resolves the issue).

Here is a link to a script that can duplicate the problem 100% of the
time:  http://soc.ath.cx/testfont.pl.txt

An strace using the kernel that doesn't work looks like this:

access("/mnt/isilon/fonts/arial.ttf", R_OK) = 0
open("/mnt/isilon/fonts/arial.ttf", O_RDONLY) = 3
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
fstat64(3, {st_mode=S_IFREG|0666, st_size=48784, ...}) = 0
close(3)                                = 0

And the strace on the system that *does* work looks like this:

access("/mnt/isilon/fonts/arial.ttf", R_OK) = 0
open("/mnt/isilon/fonts/arial.ttf", O_RDONLY) = 3
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
fstat64(3, {st_mode=S_IFREG|0666, st_size=48784, ...}) = 0
mmap2(NULL, 48784, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb79cd000
close(3)                                = 0

Everything looks the same except the missing "mmap2" section.  Again,
a note, this same machine *can* access other shares and read fonts
just fine.  It appears to just be the connection to the Isilon
machine.  Everything worked before the upgrade, and a downgrade to
2.6.24 works.  Any information would be helpful.

-- 
Adam Olsen
SendOutCards.com
http://www.vimtips.org
http://last.fm/user/synic
