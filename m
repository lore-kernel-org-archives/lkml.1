Return-Path: <linux-kernel-owner+w=401wt.eu-S1751537AbZL1Lzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbZL1Lzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 06:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbZL1Lzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 06:55:45 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:43109 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZL1Lzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 06:55:44 -0500
Date: Mon, 28 Dec 2009 06:55:00 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: processing the unused and "badref" CONFIG variables
Message-ID: <alpine.LFD.2.00.0912280649520.19521@localhost>
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


  just to prod people into maybe perusing the output here:

http://www.crashcourse.ca/wiki/index.php/Unused_CONFIG_variables

even if *most* of those definitions of unused CONFIG variables don't
do any harm, as i mentioned, sometimes that output clearly identifies
typoes that should be fixed.  in other cases, it identifies strange
situations like this:

===== RADIO_TEA5764_XTAL
drivers/media/radio/radio-tea5764.c:132:#ifndef RADIO_TEA5764_XTAL
drivers/media/radio/radio-tea5764.c:133:#define RADIO_TEA5764_XTAL 1
drivers/media/radio/radio-tea5764.c:137:static int use_xtal = RADIO_TEA5764_XTAL;
drivers/media/radio/Kconfig:412:config RADIO_TEA5764_XTAL

  in the above, what seems to be happening is that a Kconfig variable
is being defined and would lead the developer to think that it
represents something selectable, whereas the source file itself simply
hardcodes the equivalent value (or something like that).  that strikes
me as a recipe for confusion and potentially maddening debugging.

  also, over the course of today, i'll be updating the page of what i
call "badref" CONFIG variables -- variables that are being *tested*
but are not *defined* in any Kconfig file.  those have the potential
for more serious errors.  the current (unupdated) output for that is
here:

http://www.crashcourse.ca/wiki/index.php/Badref_CONFIG_variables

i'm betting a lot of that output isn't going to change even after
updating to the latest git tree.

rday
--



========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
