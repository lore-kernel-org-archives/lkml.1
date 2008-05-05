Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbYEEG2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbYEEG2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 02:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbYEEG2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 02:28:12 -0400
Received: from mail.karo-electronics.de ([213.146.116.110]:35983 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbYEEG2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 02:28:10 -0400
Message-ID: <18462.43245.728465.911831@ipc1.ka-ro>
Date: Mon, 5 May 2008 08:27:57 +0200
From: =?iso-8859-15?q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
To: Willy Tarreau <w@1wt.eu>
Cc: NeilBrown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.25: 'mkdir -p' does not work with rootdir as mount point inside a read only filesystem
In-Reply-To: <20080503063231.GA688@1wt.eu>
References: <18456.34604.472989.35082@ipc1.ka-ro>
	<20080501215231.297e0d9d.akpm@linux-foundation.org>
	<53722.192.168.1.70.1209711343.squirrel@neil.brown.name>
	<20080503063231.GA688@1wt.eu>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Willy Tarreau writes:
> > My guess is that you have an old/buggy version of mkdir.
> > 
> > What does
> >     mkdir --version
> > 
> > say?
> > Mine says:
> > mkdir (GNU coreutils) 6.10
> > Copyright (C) 2008 Free Software Foundation, Inc.
> > etc...
> 
> I would bet this is the problem for the reporter.
> 
> I tried the same here, and cannot exhibit the problem. Just like the
> reporter, my / is ro and /dev is rw :
> 
I'm using busybox 1.0 (on an embedded PXA320 system).

> stat64("/dev/a/b/c", 0xbf9175dc)        = -1 ENOENT (No such file or directory)
> umask(0)                                = 022
> open(".", O_RDONLY|O_LARGEFILE|O_DIRECTORY) = 3
> chdir("/")                              = 0
> mkdir("dev", 0755)                      = -1 EEXIST (File exists)
> stat64("dev", {st_mode=S_IFDIR|0755, st_size=17080, ...}) = 0
> chdir("dev")                            = 0
> mkdir("a", 0755)                        = 0
> chdir("a")                              = 0
> mkdir("b", 0755)                        = 0
> chdir("b")                              = 0
> umask(022)                              = 0
> mkdir("c", 0777)                        = 0
> fchdir(3)                               = 0
> close(3)                                = 0
> 
This is what strace shows in my case:
mkdir("/", 0777)                        = -1 EEXIST (File exists)
stat64("/", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
mkdir("/dev/", 0777)                    = -1 EROFS (Read-only file system)
umask(022)                              = 022
write(2, "mkdir: ", 7mkdir: )                  = 7
write(2, "Cannot create directory `/dev/\'", 31Cannot create directory `/dev/') = 31
write(2, ": Read-only file system\n", 24: Read-only file system
) = 24
io_submit(0x1, 0x1, 0xfbad2088 <unfinished ... exit status 1>


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
