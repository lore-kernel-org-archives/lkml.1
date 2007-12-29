Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbXL2BmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbXL2BmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 20:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbXL2BmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 20:42:09 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:46990 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbXL2BmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 20:42:07 -0500
Date: Sat, 29 Dec 2007 02:42:06 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: devzero@web.de, jcm@jonmasters.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dl9pf@gmx.de
Subject: Re: kbuild: modules_install regression ? - depmod
In-Reply-To: <73443449@web.de>
Message-ID: <Pine.LNX.4.64.0712290239020.29013@fbirervta.pbzchgretzou.qr>
References: <73443449@web.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Adding jcm to Cc]

On Dec 28 2007 16:08, devzero@web.de wrote:
>
>i have the same issue, but with 2.6.24-rc6 on a box with 512MB RAM
>
>System is openSUSE 10.3
>
>on "make modules_install" , depmod reproduceably dies with out of memory error when it is ~800MB VSZ and ~350MB RSS
>this happens on different hardware.
>
>any clue what`s going wrong?
>how much memory should i expect being needed with "make modules_install" , e.g. with allmodconfig ?


If you enable CONFIG_DEBUG_INFO, don't be surprised.

Though I'd say depmod should ignore the debug sections.

>
>
>Subject:    kbuild: modules_install regression ? - depmod
>From:       Jan-Simon =?utf-8?q?M=C3=B6ller?= <dl9pf () gmx ! de>
>Date:       2007-11-01 4:14:34
>Message-ID: 200711010514.34469.dl9pf () gmx ! de
>[Download message RAW]
>
>Hi!
>
>I compiled kernel 2.6.24-rc1 (latest git as of today) on a Box with 256MB Ram.
>During "make modules_install" I got these errors:
>
>  DEPMOD  2.6.24-rc1-default
>WARNING: Can't read 
>module /lib/modules/2.6.24-rc1-default/kernel/net/bridge/bridge.ko: Cannot 
>allocate memory
>WARNING: Can't read 
>module /lib/modules/2.6.24-rc1-default/kernel/net/bridge/netfilter/ebt_redirect.ko: 
>Cannot allocate memory
>[...]
>FATAL: Memory allocation failure depmod.c line 158: realloc(mod->deps, 
>sizeof(mod->deps[0])*(mod->num_deps+1)).
>make: *** [_modinst_post] Fehler 1
>
>
>Depmod used too much memory and exits. Tried a 2nd time and checked with top.
>
>IMHO this is a regression.
>
>best regards
>jan-simon
>
>__________________________________________________________________________
>Erweitern Sie FreeMail zu einem noch leistungsstärkeren E-Mail-Postfach!		
>Mehr Infos unter http://produkte.web.de/club/?mc=021131
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>

