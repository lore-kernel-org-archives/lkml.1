Return-Path: <linux-kernel-owner+w=401wt.eu-S933376AbXJRP5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933376AbXJRP5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764406AbXJRP4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:56:18 -0400
Received: from services.sin.cvut.cz ([147.32.110.2]:60465 "EHLO
	services.sin.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763557AbXJRP4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:56:17 -0400
From: Jaroslav Sykora <jara@sin.cvut.cz>
Reply-To: jaroslav.sykora@gmail.com
Subject: [RFC PATCH 0/5] Shadow directories
Date: Thu, 18 Oct 2007 17:21:08 +0200
User-Agent: KMail/1.9.7
X-Face: >I|[{8s3:Ic!^A\YY'ktAfvq]K.-@B=!>(:.VX7_KNlZ@`l)vxL}2g~)k(#@=?utf-8?q?BN=24U+3MgB2=0A=097yR=5D=26tZ8PTc=3D=60?=<A%=5!.VCQ~(<-2#;/xmM4t6'MB7zDSm7i$nn/x^TC*adoyqd"{b0,=?utf-8?q?Hr=5F=0A=09?=<.yl<O}[Z[s.oX/:P917[b9QB%3f]{m=`7azOx[(.XW)"nW?N]jA5=%!<=?utf-8?q?=27ayW=5E!NQg6RcZ=0A=09vG?=@\&{XT%rV)u^hXq%ecRC;$jLBaa>ZZB_o
MIME-Version: 1.0
Content-Disposition: inline
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200710181721.09201.jara@sin.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Let's say we have an archive file "hello.zip" with a hello world program source
code. We want to do this:
	cat hello.zip^/hello.c
	gcc hello.zip^/hello.c -o hello
	etc..

The '^' is an escape character and it tells the computer to treat the file as a directory.
[Note: We can't do "cat hello.zip/hello.c" because of http://lwn.net/Articles/100148/ ]
The kernel patch implements only a redirection of the request to another directory
("shadow directory") where a FUSE server must be mounted. The decompression of 
archives is entirely  handled in the user space. More info can be found in the documentation
patch in the series.

The shadow directories are used in RheaVFS project [ http://rheavfs.sourceforge.net/ ],
and it also can be used with the original AVFS [ http://www.inf.bme.hu/~mszeredi/avfs/ ].

The patches are against vanilla 2.6.23.
This is my first bigger contribution to the kernel so please be gentle ;-)

Jara

-- 
"Elves and Dragons!" I says to him.  "Cabbages and potatoes are better
for you and me."  -- J. R. R. Tolkien
