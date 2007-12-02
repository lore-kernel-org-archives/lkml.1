Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbXLBIJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbXLBIJR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 03:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbXLBIJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 03:09:04 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:53509 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbXLBIJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 03:09:03 -0500
Date: Sun, 2 Dec 2007 03:08:58 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: any value in centralizing common 32/64 x86 content in
 vmlinux.lds.S?
Message-ID: <alpine.LFD.0.9999.0712020301180.29501@localhost.localdomain>
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


  given the amount of common content between
arch/x86/kernel/vmlinux_32.lds.S and arch/x86/kernel/vmlinux_64.lds.S,
what about just defining macros for some of that stuff in
arch/x86/kernel/vmlinux.lds.S and cutting down on all the duplication?

  as is done in include/asm-generic/vmlinux.lds.S, why not just
define some handy macros, like:

#define INITRAMFS(align)					\
	. = ALIGN(align);					\
	.init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {	\
	__initramfs_start = .;					\
	*(.init.ramfs)						\
	__initramfs_end = .;					\
	}

or something similar.

  i'm guessing there's a fair amount of content like that that can be
coalesced, no?  it would also standardize some of the niggling
differences between some of that content between the two files.

rday

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
