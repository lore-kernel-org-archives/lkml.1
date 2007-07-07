Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbXGGLHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbXGGLHm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 07:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbXGGLHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 07:07:33 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:45632 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbXGGLHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 07:07:32 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 7 Jul 2007 07:05:15 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: can everything related to OSS's DMASOUND_PMAC get whacked?
Message-ID: <Pine.LNX.4.64.0707070658400.22169@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  (apologies for not asking more specifically but i poked a couple
folks and never got a reply.)

  the file sound/oss/dmasound/Makefile makes reference to a
non-existent variable CONFIG_DMASOUND_PMAC:

==========
#
# Makefile for the DMA sound driver
#

dmasound_pmac-y                 += dmasound_awacs.o \
                                   trans_16.o dac3550a.o tas_common.o \
                                   tas3001c.o tas3001c_tables.o \
                                   tas3004.o tas3004_tables.o

obj-$(CONFIG_DMASOUND_ATARI)    += dmasound_core.o dmasound_atari.o
obj-$(CONFIG_DMASOUND_PMAC)     += dmasound_core.o dmasound_pmac.o
obj-$(CONFIG_DMASOUND_PAULA)    += dmasound_core.o dmasound_paula.o
obj-$(CONFIG_DMASOUND_Q40)      += dmasound_core.o dmasound_q40.o
==========

  if one removes that reference and stuff related to it, the snowball
eventually produces the following diffstat:

 sound/oss/dmasound/Makefile          |    6
 sound/oss/dmasound/awacs_defs.h      |  251 -
 sound/oss/dmasound/dac3550a.c        |  209 -
 sound/oss/dmasound/dmasound.h        |    4
 sound/oss/dmasound/dmasound_awacs.c  | 3215 -------------------------
 sound/oss/dmasound/tas3001c.c        |  849 ------
 sound/oss/dmasound/tas3001c.h        |   64
 sound/oss/dmasound/tas3001c_tables.c |  375 --
 sound/oss/dmasound/tas3004.c         | 1138 --------
 sound/oss/dmasound/tas3004.h         |   77
 sound/oss/dmasound/tas3004_tables.c  |  301 --
 sound/oss/dmasound/tas_common.c      |  214 -
 sound/oss/dmasound/tas_common.h      |  284 --
 sound/oss/dmasound/tas_eq_prefs.h    |   24
 sound/oss/dmasound/tas_ioctl.h       |   23
 sound/oss/dmasound/trans_16.c        |  898 ------
 16 files changed, 7932 deletions(-)

so:

  1) thoughts?
  2) what exactly is OSS' status with respect to whether it's worth
investing any time in doing cleanup on it and ripping out unreferenced
content?

thanks.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
