Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbYIJX5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbYIJX5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 19:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbYIJX5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 19:57:12 -0400
Received: from mail.ocs.com.au ([202.134.241.204]:14361 "EHLO mail.ocs.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbYIJX5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 19:57:12 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 (debian 1:2.7.2-12) with nmh-1.2
From: Keith Owens <kaos@ocs.com.au>
To: David Miller <davem@davemloft.net>
cc: kaber@trash.net, linux-kernel@vger.kernel.org
Subject: Re: Recent copy of libpcap from CVS 
In-reply-to: Your message of "Wed, 10 Sep 2008 15:57:06 MST."
             <20080910.155706.100960963.davem@davemloft.net> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 11 Sep 2008 09:57:08 +1000
Message-ID: <7381.1221091028@ocs10w>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller (on Wed, 10 Sep 2008 15:57:06 -0700 (PDT)) wrote:
>From: Patrick McHardy <kaber@trash.net>
>Date: Tue, 09 Sep 2008 05:11:59 +0200
>
>> Thats odd, the version I had has USB support and that one also appears
>> to be missing my VLAN patches that are in current CVS.
>> 
>> I'll try to figure out what went wrong and send you both a new tarball.
>
>I just rebuilt the libpcap repo from an updated tarball Patrick sent me.
>Let me know if it's still screwed up :)

Comparing git://git.kernel.org/pub/scm/linux/kernel/git/davem/libpcap.git
against Patrick's tarball.  git is missing some mode and some rcsid
lines like this example below, I assume that the removal of these lines
in git was deliberate.

diff -urp libpcap-0.9-PRE-CVS/fad-getad.c libpcap/fad-getad.c
--- libpcap-0.9-PRE-CVS/fad-getad.c	2007-10-18 04:11:49.000000000 +1000
+++ libpcap/fad-getad.c	2008-09-11 09:45:20.144341324 +1000
@@ -1,4 +1,3 @@
-/* -*- Mode: c; tab-width: 8; indent-tabs-mode: 1; c-basic-offset: 8; -*- */
 /*
  * Copyright (c) 1994, 1995, 1996, 1997, 1998
  *	The Regents of the University of California.  All rights reserved.
@@ -32,11 +31,6 @@
  * SUCH DAMAGE.
  */
 
-#ifndef lint
-static const char rcsid[] _U_ =
-    "@(#) $Header: /tcpdump/master/libpcap/fad-getad.c,v 1.12 2007/09/14 00:44:55 guy Exp $ (LBL)";
-#endif
-
 #ifdef HAVE_CONFIG_H
 #include "config.h"
 #endif

However the removal of the #ifndef lint lines also removed a copyright
notice from the object.  The copyright line should be reinstated.

diff -urp libpcap-0.9-PRE-CVS/filtertest.c libpcap/filtertest.c
--- libpcap-0.9-PRE-CVS/filtertest.c	2007-10-11 16:56:22.000000000 +1000
+++ libpcap/filtertest.c	2008-09-11 09:45:20.148341971 +1000
@@ -19,14 +19,6 @@
  * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
-#ifndef lint
-static const char copyright[] _U_ =
-    "@(#) Copyright (c) 1988, 1989, 1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 2000\n\
-The Regents of the University of California.  All rights reserved.\n";
-static const char rcsid[] _U_ =
-    "@(#) $Header: /tcpdump/master/libpcap/filtertest.c,v 1.2 2005/08/08 17:50:13 guy Exp $ (LBL)";
-#endif
-
 #ifdef HAVE_CONFIG_H
 #include "config.h"
 #endif

