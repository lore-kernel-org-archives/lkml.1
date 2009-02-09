Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbZBIAmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbZBIAmd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 19:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbZBIAmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 19:42:23 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:8512 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbZBIAmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 19:42:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=W+1ZLBTG4UjGwndlw+Xz63nHXN/WwxCf0cP+0NagJstYyztCCClss8gIlGkytiEVUv
         CcHFDKz6bHg0oJLzoe3MXEDfGz+kaM8YqkYFBuxFloJZTnQuH6rUJ3jq/Ay3rgjWoTyQ
         65/SYP/5W5GYG7LGYZLQYg/l1cS82ULsE6Qso=
MIME-Version: 1.0
Date: Sun, 8 Feb 2009 16:42:20 -0800
Message-ID: <dd18b0c30902081642l60c8eeacra52597efa60c1057@mail.gmail.com>
Subject: install_root=/ not going where it should go.
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm in the process of build a linux
from scratch system, and seem to be
confused in how I issue the right command
to have the kernel build to a certain root location.
(example)
the system Im building on is ubuntu
the new root tree is located in /mnt/*
when building the kernel I(in the home dir)

make INSTALL_HDR_PATH=/mnt/*  DESTDIR=/mnt/* modules_install
or
make INSTALL_HDR_PATH=/mnt/*  install_root=/mnt/* modules_install
(goes to the normal location,not /mnt's location);
or
make DESTDIR=/mnt/* modules_install

still goes to /lib/modules
(on the normal system(not /mnt);

at the moment:
The real main problem I have is chrooting
into /mnt/*(the new system) and having no headers
to compile the kernel from the beginning with.
(should I just cp include/*  /usr/include/);
or is there a simpler solution that I have missed
in the Documentation.

heres the error in the chrooted environment:

In file included from /usr/include/bits/posix1_lim.h:153,
                 from /usr/include/limits.h:145,
                 from
/usr/local/lib/gcc/i686-pc-linux-gnu/4.4.0/include-fixed/limits.h:122,
                 from
/usr/local/lib/gcc/i686-pc-linux-gnu/4.4.0/include-fixed/syslimits.h:7,
                 from
/usr/local/lib/gcc/i686-pc-linux-gnu/4.4.0/include-fixed/limits.h:11,
                 from scripts/basic/fixdep.c:115:
/usr/include/bits/local_lim.h:39:26: error: linux/limits.h: No such
file or directory
In file included from /usr/include/sys/socket.h:40,
                 from /usr/include/netinet/in.h:25,
                 from /usr/include/arpa/inet.h:23,
                 from scripts/basic/fixdep.c:117:
/usr/include/bits/socket.h:354:24: error: asm/socket.h: No such file
or directory
scripts/basic/fixdep.c: In function 'use_config':
scripts/basic/fixdep.c:206: error: 'PATH_MAX' undeclared (first use in
this function)
scripts/basic/fixdep.c:206: error: (Each undeclared identifier is
reported only once
scripts/basic/fixdep.c:206: error: for each function it appears in.)
scripts/basic/fixdep.c:206: warning: unused variable 's'
scripts/basic/fixdep.c: In function 'parse_dep_file':
scripts/basic/fixdep.c:306: error: 'PATH_MAX' undeclared (first use in
this function)
scripts/basic/fixdep.c:306: warning: unused variable 's'
scripts/basic/fixdep.c: In function 'traps':
scripts/basic/fixdep.c:377: warning: dereferencing type-punned pointer
will break strict-aliasing rules
scripts/basic/fixdep.c:379: warning: dereferencing type-punned pointer
will break strict-aliasing rules
make[1]: *** [scripts/basic/fixdep] Error 1
make: *** [scripts_basic] Error 2

any info would be appreciated.
regards;

-- 
Justin P. Mattock
