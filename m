Return-Path: <linux-kernel-owner+w=401wt.eu-S1751710AbZL2RbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbZL2RbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 12:31:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbZL2RbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 12:31:00 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:37884 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbZL2RbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 12:31:00 -0500
Date: Tue, 29 Dec 2009 12:30:23 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: simplify numerous param.h's by including <asm-generic/param.h>?
Message-ID: <alpine.LFD.2.00.0912291224520.2860@localhost>
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


  a brief perusal of the numerous param.h files under
arch/<arch>/include/asm shows that most of them could be replaced with
a simple

  #include <asm-generic/param.h>

as is done by, for example, the microblaze param.h file.  the only
noticeable difference in those files is the value of EXEC_PAGESIZE,
which is already conditionally set in the generic version:

  #ifndef EXEC_PAGESIZE
  #define EXEC_PAGESIZE   4096
  #endif

so, at worst, a param.h file could be replaced by:

  #define EXEC_PAGESIZE <whatever>
  #include <asm-generic/param.h>

rather than duplicating the same content over and over.  (i did this
sort of centralization once upon a time with the ioctl.h file.)

  worth doing?  not worth doing?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
