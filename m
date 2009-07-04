Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbZGDQgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbZGDQgI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 12:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbZGDQf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 12:35:57 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:38414 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZGDQf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 12:35:56 -0400
Date: Sat, 4 Jul 2009 12:33:48 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: weekly column and a question about module_init() error codes
Message-ID: <alpine.LFD.2.00.0907041221330.2912@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  in a spate of self-promotion that probably has little interest for
members of *this* list, i'm now writing a weekly column for linux.com
for kernel newbies, first two pieces here:

  http://cli.gs/8WMgM9
  http://cli.gs/Zd2MuG

yes, i know it's trivial stuff but look at it this way -- if i can
explain it properly, then they won't be bugging *you* with those
questions. :-)

  and regarding return codes from module_init() routines, i realize
that you need to return zero to represent success so that the module
is loaded but, if anything goes wrong, you should return a negative
value corresponding to some value out of
include/asm-generic/errno-base.h:

#define EPERM            1      /* Operation not permitted */
#define ENOENT           2      /* No such file or directory */
#define ESRCH            3      /* No such process */
#define EINTR            4      /* Interrupted system call */
#define EIO              5      /* I/O error */
... snip ...

  however, based on some tests i ran, regardless of what error code i
return, a manual "insmod" always returns a shell error code ($?) of 1.
the message *printed* will correspond to the actual error value
returned, such as returning -EIO printing:

# insmod hi.ko
insmod: error inserting 'hi.ko': -1 Input/output error
#

  i'm assuming that, if i'm running insmod as part of a script and can
check only the return code, all i'm going to get is 0 or 1 (success or
fail), and there's no way to extract the actual value.  (i could
capture the error string printed, but that's a bit of a pain --
getting the numeric value would be so much easier.)

  or am i missing something painfully obvious?  thanks.

rday
--


========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
