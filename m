Return-Path: <linux-kernel-owner+w=401wt.eu-S1751547AbXDKJGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbXDKJGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbXDKJGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:06:46 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:58174 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbXDKJGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:06:45 -0400
Date: Wed, 11 Apr 2007 11:06:26 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "menu" versus "menuconfig" -- they're *both* a bad idea
In-Reply-To: <Pine.LNX.4.64.0704110357200.9384@CPE00045a9c397f-CM001225dbafb6>
Message-ID: <Pine.LNX.4.61.0704111059190.32056@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0704110357200.9384@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 11 2007 03:58, Robert P. J. Day wrote:
>
>  General setup
>    [ ] Configure standard kernel features (for small systems)  --->
>
>note how, even if you don't choose to configure features for small
>systems, if you go under that menu entry, you're still presented with
>a couple config options related to kallsyms.

A CONFIG_EMBEDDED bug. This should perhaps be changed.
Or at best, deactivate the ---> part when it's N.

>===========================
>menuconfig EMBEDDED
>	bool "Configure standard kernel features (for small systems)"
>	...
>===========================
>
>  first, for submenu entries to show up if you select features for
>"small systems," you need to tack "if EMBEDDED" onto every prompt,
>
>...
>bool "Sysctl syscall support" if EMBEDDED
>bool "Load all symbols for debugging/ksymoops" if EMBEDDED
>bool "Support for hot-pluggable devices" if EMBEDDED
>...
>
>and so on, which gets annoyingly repetitive after a while.

Can we agree that CONFIG_EMBEDDED is a specialcase?

>
>  worse, you have options that don't even depend on the menu that
>they're a sub-entry for, as in:
>
>...
>config KALLSYMS_ALL
>        bool "Include all symbols in kallsyms"
>        depends on DEBUG_KERNEL && KALLSYMS
>...
>
>  what is really needed here is a new Kconfig structure, perhaps
>called "selectablemenuconfig" (or something not quite so verbose),
>which would, in one fell swoop:
>
>1) be singly-clickable to activate or de-activate an entire submenu
>and possibly further submenus, and
>
>2) make all of those submenu entries *automatically* depend on the
>config option that represents the submenu.
>
>  at the moment, you can do pretty much the same thing with
>"menuconfig" but it's downright messy.  rather than make all these
>"menuconfig" changes right now, i would prefer to see a cleaner
>structure introduced that does most of that work under the hood.


Jan
-- 
