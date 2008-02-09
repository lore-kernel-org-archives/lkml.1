Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbYBITHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbYBITHz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 14:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbYBITHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 14:07:48 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:37975 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbYBITHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 14:07:46 -0500
Date: Sat, 9 Feb 2008 14:07:39 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: some questions about generated headers
Message-ID: <alpine.LFD.1.00.0802091345150.14859@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
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


  just a few observations about the generated headers and whether
there's some cleanup to be done there.

1)

  the generated header linux/tty.h consists solely of:

=====
#ifndef _LINUX_TTY_H
#define _LINUX_TTY_H

/*
 * 'tty.h' defines some structures used by tty_io.c and some defines.
 */

#endif
=====

  i once submitted a patch that, if this header were included from
userspace, would print, "Don't include me from user space, I'm empty."
or something to that effect.  is that worth doing?  or should user
space code be including that header at all?  (should an empty header
even be *exported* to user space?)

2)

  include/linux/soundcard.h still contains some weird, non-standard
checks:

...
#if (!defined(__KERNEL__) && !defined(KERNEL) && !defined(INKERNEL) &&
!defined(_KERNEL)) || defined(USE_SEQ_MACROS)
...

  so what's with KERNEL or INKERNEL or _KERNEL?  do those tests still
have any value?  or can they be tossed?

3)

  related to 2), what's up with __KERNEL as well?  it still shows up
in a number of places in the kernel source.   for example, see
include/linux/hdsmart.h:

...
#ifndef __KERNEL
...
#endif /* __KERNEL__ *

(and that missing trailing slash creeps me out, too.)

4)

  any chance of replacing the current unifdef with sunifdef (son of
unifdef), which is smarter and can simplify some of the compound
logical preprocessor checks to get rid of more junk in those generated
headers?

  http://www.sunifdef.strudl.org/


  that should do for now.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

Home page:                                         http://crashcourse.ca
Fedora Cookbook:    http://crashcourse.ca/wiki/index.php/Fedora_Cookbook
========================================================================
