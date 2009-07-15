Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbZGOLbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbZGOLbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 07:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbZGOLbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 07:31:40 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:35101 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbZGOLbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 07:31:40 -0400
Date: Wed, 15 Jul 2009 07:29:18 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: any remaining value to EXPORT_UNUSED_SYMBOL{,_GPL} macros?
Message-ID: <alpine.LFD.2.00.0907150723560.22509@localhost>
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


  i asked this on the kernel newbies list since it seemed fairly
trivial but perhaps it's better to ask it here.  is there any value to
hanging onto those two macro definitions given this from
Documentation/feature-removal-schedule.txt:

What:   Unused EXPORT_SYMBOL/EXPORT_SYMBOL_GPL exports
        (temporary transition config option provided until then)
        The transition config option will also be removed at the same time.
When:   before 2.6.19
Why:    Unused symbols are both increasing the size of the kernel binary
        and are often a sign of "wrong API"
Who:    Arjan van de Ven <arjan@linux.intel.com>

  and that a scan of the entire source tree reveals:

$ grep -r EXPORT_UNUSED_SYMBOL *
fs/libfs.c:EXPORT_UNUSED_SYMBOL(simple_prepare_write);
include/linux/module.h:#define EXPORT_UNUSED_SYMBOL(sym) __EXPORT_SYMBOL(sym, "_unused")
include/linux/module.h:#define EXPORT_UNUSED_SYMBOL_GPL(sym) __EXPORT_SYMBOL(sym, "_unused_gpl")
include/linux/module.h:#define EXPORT_UNUSED_SYMBOL(sym)
include/linux/module.h:#define EXPORT_UNUSED_SYMBOL_GPL(sym)
include/linux/module.h:#define EXPORT_UNUSED_SYMBOL(sym)
include/linux/module.h:#define EXPORT_UNUSED_SYMBOL_GPL(sym)
scripts/checkpatch.pl:		    ($line =~ /EXPORT_UNUSED_SYMBOL.*\((.*)\)/)) {
scripts/mod/modpost.c:	{ .str = "EXPORT_UNUSED_SYMBOL",     .export = export_unused },
scripts/mod/modpost.c:	{ .str = "EXPORT_UNUSED_SYMBOL_GPL", .export = export_unused_gpl },

  in short, one actual usage in fs/libfs.c, and a bunch of other
references that contribute nothing to their value.

  thoughts?  if these macros have been deprecated for a while, why not
just dump that final usage and get rid of them?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
"Kernel Newbie Corner" column @ linux.com:          http://cli.gs/WG6WYX
========================================================================
