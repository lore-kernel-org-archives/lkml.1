Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbZF3UtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbZF3UtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 16:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbZF3UtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 16:49:00 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:38674 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbZF3Us7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 16:48:59 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jamie Lokier <jamie@shareable.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] vfat: change the default from shortname=lower to shortname=mixed
References: <20090630032257.GA32096@shareable.org>
Date: Wed, 01 Jul 2009 05:48:58 +0900
In-Reply-To: <20090630032257.GA32096@shareable.org> (Jamie Lokier's message of
	"Tue, 30 Jun 2009 04:22:57 +0100")
Message-ID: <87skhhh2h1.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier <jamie@shareable.org> writes:

> I agree with the change to "shortname=mixed" being the default.
>
> Not only does it solve problems with Linux seeing files it created
> _itself_ change, "shortname=mixed" is the only option where files
> created on all versions of Windows appear the same in Linux, and vice
> versa.  It is better than Windows itself in that respect...
>
> "shortname=winnt" is not as good.  It solves the problem of
> Linux<->itself compatibility and Linux<->Windows-NT/2000/XP/Vista
> compatibility, but not Linux<->Windows-95/98/ME compatibility.
>
> I don't see any problems with changing the option from it's default,
> for filesystems which were written as VFAT by any OS.  For filesystems
> written as plain FAT, it may change them to appear as upper case in
> Linux, when they previously showed as lower case.  If there is a
> reliable way to detect filenames written by a plain FAT system, it
> might be desirable to show the names as lower case from them.
>
> Below are my notes, when I had to add "shortname=mixed" to a program
> because of user bug reports when they created files on various
> versions of Windows and they didn't work on an embedded Linux media
> player.  Feel free to use the notes in the Changelog or documentation.
>
>     Why use shortname=mixed.
>
>     This affects 8.3 filename reading and creation for maximum
>     compatibility with the behaviour of all versions of Windows.
>
>     There is a classic conflict between Windows 95 derivatives and
>     Windows NT derivatives, which causes spurious case changes when
>     moving some file names between them on removable media.  This
>     Linux setting manages to be compatible with both of them reliably,
>     and is therefore superior to all versions of Windows.
>
>     1. Filename reading uses the algorithm of Windows NT: if there
>        is only an 8.3 short name, its case is calculated from flags in
>        byte 12 of the short name entry.
>
>        This is needed for compatibility with files written by Windows
>        NT derivatives (including 2000, XP and Vista).  When Windows NT
>        creates two files called "PLAYLIST" and "file.ogg", the default
>        Linux algorithm ("shortname=lower") would see them as
>        "playlist" and "file.ogg" together, and the Windows 95
>        algorithm would see them as "PLAYLIST" and "FILE.OGG" together.
>        Both cause problems.
>
>     2. Filename creation uses the algorithm of Windows 95: Linux
>        creates a long name entry unless the original name fits into
>        8.3 and is entirely upper case.  This is more compatible than
>        shortname=winnt, because it creates a long name in more cases
>        to remove uncertainty.
>
>        This is needed for compatability with files created by Linux
>        and read by Windows 95 derivatives (and MS-DOS).  Windows 95
>        derivatives and MS-DOS interpret short name entries as upper
>        case, even when case flags are set in byte 12.  By storing a
>        long name entry, files stored by Linux will be read in the
>        desired case by all versions of Windows.
>
> The patch has my
>
> Signed-Off-By: Jamie Lokier <jamie@shareable.org>

Thanks for comment. I don't know whether signed-off-by is desirable for
this, so I'll add one Acked-by: simply if I apply this. Is it ok?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
