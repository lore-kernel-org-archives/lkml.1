Return-Path: <linux-kernel-owner+w=401wt.eu-S1762279AbYBAMmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762279AbYBAMmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 07:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755638AbYBAMmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 07:42:32 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:48186 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbYBAMmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 07:42:31 -0500
Date: Fri, 1 Feb 2008 07:42:15 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: what constitutes an "unused" include/linux header file?
Message-ID: <alpine.LFD.1.00.0802010735570.27049@localhost.localdomain>
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


  one of my cleanup scripts tries to specifically identify header
files under include/linux that appear to be entirely unused (that is,
un-included) from anywhere else in the source tree, but one of those
files it claims is unused is if_wanpipe.h, which has the following
properties:

$ grep -r "if_wanpipe.h" *
Documentation/networking/wan-router.txt:        if_wanpipe.h    WANPIPE Socket definitions
include/linux/Kbuild:unifdef-y += if_wanpipe.h
include/linux/if_wanpipe.h:* if_wanpipe.h       Header file for the Sangoma AF_WANPIPE Socket
$

  in short, while it exists, it isn't "include"d by anyone, but it's
still passed to userspace.  what's the protocol for having header
files in the kernel source tree that aren't actually used in any way
by the kernel, but are simply handed off to userspace?  certainly, it
might be handy to have some of these headers, but is it really the
responsibility of the kernel to be a helpful storage centre to make
userspace programming easier?  just curious.  (that's not the only
header file like that.)

rday
--


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

Home page:                                         http://crashcourse.ca
Fedora Cookbook:    http://crashcourse.ca/wiki/index.php/Fedora_Cookbook
========================================================================
