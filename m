Return-Path: <linux-kernel-owner+w=401wt.eu-S1030923AbXDVOn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030923AbXDVOn2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 10:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030928AbXDVOn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 10:43:28 -0400
Received: from oker.escape.de ([194.120.234.254]:43841 "EHLO oker.escape.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030923AbXDVOn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 10:43:27 -0400
X-Greylist: delayed 4102 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Apr 2007 10:43:27 EDT
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.4.34.3
References: <20070422101057.GA11893@hera.kernel.org>
From: Urs Thuermann <urs@isnogud.escape.de>
Date: 22 Apr 2007 15:33:58 +0200
In-Reply-To: <20070422101057.GA11893@hera.kernel.org>; from Willy Tarreau on Sun, 22 Apr 2007 10:10:57 +0000
Message-ID: <ygfzm508reh.fsf@janus.isnogud.escape.de>
User-Agent: Gnus/5.0808 (Gnus v5.8.8) Emacs/20.7
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau <wtarreau@hera.kernel.org> writes:

> I've just released Linux 2.4.34.3.
> 
> Nothing critical, just a bunch of bugfixes and small security fix.

I get the following compile error:

gcc -D__KERNEL__ -I/usr/src/linux-2.4.34.3-ut/include -Wall -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common -fno-builtin-sprintf -fomit-frame-pointer  -pipe -mpreferred-stack-boundary=2 -fno-guess-branch-probability -march=i686 -fno-unit-at-a-time   -nostdinc -iwithprefix include -DKBUILD_BASENAME=fib_semantics  -c -o fib_semantics.o fib_semantics.c
fib_semantics.c: In function `fib_create_info':
fib_semantics.c:436: error: label `errout' used but not defined
make[3]: *** [fib_semantics.o] Error 1
make[3]: Leaving directory `/usr/src/linux-2.4.34.3-ut/net/ipv4'
make[2]: *** [first_rule] Error 2
make[2]: Leaving directory `/usr/src/linux-2.4.34.3-ut/net/ipv4'
make[1]: *** [_subdir_ipv4] Error 2
make[1]: Leaving directory `/usr/src/linux-2.4.34.3-ut/net'
make: *** [_dir_net] Error 2

The appended patch fixes this problem.


urs


--- net/ipv4/fib_semantics.c.orig	2007-04-22 13:31:23.000000000 +0000
+++ net/ipv4/fib_semantics.c	2007-04-22 13:31:42.000000000 +0000
@@ -433,7 +433,7 @@
 
 	if (r->rtm_type > RTN_MAX) {
 		err = -EINVAL;
-		goto errout;
+		goto failure;
 	}
 
 	/* Fast check to catch the most weird cases */
