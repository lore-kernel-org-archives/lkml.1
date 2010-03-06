Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab0CFR7U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 12:59:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57651 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab0CFR7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 12:59:19 -0500
Date: Sat, 6 Mar 2010 17:59:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: walt <w41ter@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: "Switch !O_CREAT case to use of do_last()" causes segfault in
 glibc
Message-ID: <20100306175917.GD30031@ZenIV.linux.org.uk>
References: <4B92944E.8080209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B92944E.8080209@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 06, 2010 at 09:43:42AM -0800, walt wrote:
> Hi Al,
> commit 1f36f774b22a0ceb7dd33eca626746c81a97b6a5
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Sat Dec 26 10:56:19 2009 -0500
> 
>     Switch !O_CREAT case to use of do_last()
> 
>     ... and now we have all intents crap well localized
> 
> This commit is triggering a segfault when I try to open a spreadsheet in
> openoffice:
> 
> Program received signal SIGSEGV, Segmentation fault.
> 0x00007ffff6d13129 in __readdir (dirp=0x0) at ../sysdeps/unix/readdir.c:45
> 45      ../sysdeps/unix/readdir.c: No such file or directory.
>         in ../sysdeps/unix/readdir.c
> (gdb) bt
> #0  0x00007ffff6d13129 in __readdir (dirp=0x0) at ../sysdeps/unix/readdir.c:45
> #1  0x00007ffff1dc58b0 in ?? () from /usr/lib/libicuuc.so.42
> #2  0x00007ffff1dc591d in ?? () from /usr/lib/libicuuc.so.42
> #3  0x00007ffff1dc5d7e in uprv_tzname_4_2 () from /usr/lib/libicuuc.so.42
> #4  0x00007fffd7f73601 in icu_4_2::TimeZone::initDefault() () from /usr/lib/libicui18n.so.42
> #5  0x00007fffd7f738c5 in icu_4_2::TimeZone::createDefault() () from /usr/lib/libicui18n.so.42
> #6  0x00007fffd7f6e5c9 in icu_4_2::Calendar::createInstance(icu_4_2::Locale const&, UErrorCode&) ()
>    from /usr/lib/libicui18n.so.42

Very interesting.  Could you give the relevant parts of strace (or reproduce
it with something less monumental than openoffice)?
