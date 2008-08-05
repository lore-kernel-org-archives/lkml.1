Return-Path: <linux-kernel-owner+w=401wt.eu-S1760956AbYHEWxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760956AbYHEWxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 18:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYHEWxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 18:53:13 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:34099 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbYHEWxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 18:53:12 -0400
Date: Tue, 5 Aug 2008 18:51:17 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: does an initcall level of "0s" actually exist?
Message-ID: <alpine.LFD.1.10.0808051848330.19162@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
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


  from include/asm-generic/vmlinux.lds.h:

#define INITCALLS                                                       \
        *(.initcallearly.init)                                          \
        VMLINUX_SYMBOL(__early_initcall_end) = .;                       \
        *(.initcall0.init)                                              \
        *(.initcall0s.init)                                             \
        *(.initcall1.init)                                              \
        *(.initcall1s.init)                                             \
... etc ...

  but from include/linux/init.h:

#define pure_initcall(fn)               __define_initcall("0",fn,0)

#define core_initcall(fn)               __define_initcall("1",fn,1)
#define core_initcall_sync(fn)          __define_initcall("1s",fn,1s)
#define postcore_initcall(fn)           __define_initcall("2",fn,2)
#define postcore_initcall_sync(fn)      __define_initcall("2s",fn,2s)

  i don't see any initcalls of level "0s".  in any event, might it not
be cleaner to have these files sync up?  no big deal, of course.  i'm
well aware that it doesn't break anything.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
