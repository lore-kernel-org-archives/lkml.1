Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab0CFRtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 12:49:22 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37949 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab0CFRtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 12:49:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=n1IYiVpudMaodaUNx+U3vidvoTD71iPIexr6J3B7H2tRKfT3Wt6kgIsSNbjw9REgwJ
         Bv6kglC69SczXX+1dIC9NSlwEeRgSuk5+5CVZCGBSTAoJ8QJVMZiKEz0V0hJXf0G0hvV
         eFBYTAXtrAomRoJB3pWkxSn/JytkcPwt7939Q=
Message-ID: <4B92944E.8080209@gmail.com>
Date: Sat, 06 Mar 2010 09:43:42 -0800
From: walt <w41ter@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.3a3pre) Gecko/20100304 Shredder/3.2a1pre
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: "Switch !O_CREAT case to use of do_last()" causes segfault in glibc
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,
commit 1f36f774b22a0ceb7dd33eca626746c81a97b6a5
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Dec 26 10:56:19 2009 -0500

     Switch !O_CREAT case to use of do_last()

     ... and now we have all intents crap well localized

This commit is triggering a segfault when I try to open a spreadsheet in
openoffice:

Program received signal SIGSEGV, Segmentation fault.
0x00007ffff6d13129 in __readdir (dirp=0x0) at ../sysdeps/unix/readdir.c:45
45      ../sysdeps/unix/readdir.c: No such file or directory.
         in ../sysdeps/unix/readdir.c
(gdb) bt
#0  0x00007ffff6d13129 in __readdir (dirp=0x0) at ../sysdeps/unix/readdir.c:45
#1  0x00007ffff1dc58b0 in ?? () from /usr/lib/libicuuc.so.42
#2  0x00007ffff1dc591d in ?? () from /usr/lib/libicuuc.so.42
#3  0x00007ffff1dc5d7e in uprv_tzname_4_2 () from /usr/lib/libicuuc.so.42
#4  0x00007fffd7f73601 in icu_4_2::TimeZone::initDefault() () from /usr/lib/libicui18n.so.42
#5  0x00007fffd7f738c5 in icu_4_2::TimeZone::createDefault() () from /usr/lib/libicui18n.so.42
#6  0x00007fffd7f6e5c9 in icu_4_2::Calendar::createInstance(icu_4_2::Locale const&, UErrorCode&) ()
    from /usr/lib/libicui18n.so.42


Here is readdir.c:445 (from glibc-2.11):

#ifndef NOT_IN_libc
   __libc_lock_lock (dirp->lock);
#endif

Thanks.
