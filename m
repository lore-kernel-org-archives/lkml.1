Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbXL2NaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbXL2NaU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 08:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbXL2NaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 08:30:10 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:53908 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbXL2NaI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 08:30:08 -0500
Date: Sat, 29 Dec 2007 14:30:03 +0100
Message-Id: <75140323@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: jcm@jonmasters.org, Jan Engelhardt <jengelh@computergmbh.de>
Cc: dl9pf@gmx.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kbuild: modules_install regression ? - depmod
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+7sKRoLHSEZTlH6LFyKgEQQQ/pQX4IE+95PjEkDFfKzKsv+
 AommZtXB4YoLjHcOM/6i38Kwx+VeAq6tn7sg51iI6VAMeIWmxQ=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [Adding jcm to Cc]
> 
> On Dec 28 2007 16:08, devzero@web.de wrote:
> >
> >i have the same issue, but with 2.6.24-rc6 on a box with 512MB RAM
> >
> >System is openSUSE 10.3
> >
> >on "make modules_install" , depmod reproduceably dies with out of memory error when it is ~800MB VSZ and ~350MB RSS
> >this happens on different hardware.
> >
> >any clue what`s going wrong?
> >how much memory should i expect being needed with "make modules_install" , e.g. with allmodconfig ?
> 
> 
> If you enable CONFIG_DEBUG_INFO, don't be surprised.
> 

oh yes, that`s it!

apparently CONFIG_DEBUG_KERNEL, CONFIG_DEBUG_BUGVERBOSE and CONFIG_DEBUG_INFO defaults to "y" on my distro`s kernel, and i just copied config from /proc/config.gz and did a "make oldconfig".

after disabling those, all is fine now ! 

thanks for the hint!

> Though I'd say depmod should ignore the debug sections.

so depmod is acting sort of "stupid" here ?

regards
roland


> 
> >
> >
> >Subject:    kbuild: modules_install regression ? - depmod
> >From:       Jan-Simon =?utf-8?q?M=C3=B6ller?= <dl9pf () gmx ! de>
> >Date:       2007-11-01 4:14:34
> >Message-ID: 200711010514.34469.dl9pf () gmx ! de
> >[Download message RAW]
> >
> >Hi!
> >
> >I compiled kernel 2.6.24-rc1 (latest git as of today) on a Box with 256MB Ram.
> >During "make modules_install" I got these errors:
> >
> >  DEPMOD  2.6.24-rc1-default
> >WARNING: Can't read 
> >module /lib/modules/2.6.24-rc1-default/kernel/net/bridge/bridge.ko: Cannot 
> >allocate memory
> >WARNING: Can't read 
> >module /lib/modules/2.6.24-rc1-default/kernel/net/bridge/netfilter/ebt_redirect.ko: 
> >Cannot allocate memory
> >[...]
> >FATAL: Memory allocation failure depmod.c line 158: realloc(mod->deps, 
> >sizeof(mod->deps[0])*(mod->num_deps+1)).
> >make: *** [_modinst_post] Fehler 1
> >
> >
> >Depmod used too much memory and exits. Tried a 2nd time and checked with top.
> >
> >IMHO this is a regression.
> >
> >best regards
> >jan-simon
> >
> >__________________________________________________________________________
> >Erweitern Sie FreeMail zu einem noch leistungsstärkeren E-Mail-Postfach!		
> >Mehr Infos unter http://produkte.web.de/club/?mc=021131
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 


__________________________________________________________________________
Erweitern Sie FreeMail zu einem noch leistungsstärkeren E-Mail-Postfach!		
Mehr Infos unter http://produkte.web.de/club/?mc=021131

