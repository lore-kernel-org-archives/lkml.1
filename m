Return-Path: <linux-kernel-owner+w=401wt.eu-S1030342AbXAaRTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030342AbXAaRTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030352AbXAaRTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:19:55 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38709 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030351AbXAaRTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:19:47 -0500
Subject: Re: [PATCH] Undo some of the pseudo-security madness
From: Arjan van de Ven <arjan@infradead.org>
To: Samium Gromoff <_deepfire@feelingofgreen.ru>
Cc: Pavel Machek <pavel@ucw.cz>, Valdis.Kletnieks@vt.edu,
       David Wagner <daw@cs.berkeley.edu>, linux-kernel@vger.kernel.org
In-Reply-To: <87mz4996wg.wl@betelheise.deep.net>
References: <87r6toufpp.wl@betelheise.deep.net>
	 <200701221520.l0MFKLdK032645@turing-police.cc.vt.edu>
	 <871wlnq7ue.wl@betelheise.deep.net> <20070123084805.GB5560@ucw.cz>
	 <87mz4996wg.wl@betelheise.deep.net>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 31 Jan 2007 17:59:48 +0800
Message-Id: <1170237588.2865.2.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> No amount of carefulness will prevent vendors stick arbitrarily
> damaging values of stack and mmap base randomisation, severely reducing
> the usefullness of MAP_FIXED.

MAP_FIXED is useful still. The only safe way is to use addresses you got
from mmap(), eg you overmap something.
Anything else is madness, with or without randomization. The C library
for example is free, and does, allocate memory and stacks etc etc.

Same for many other libraries; in addition libraries change in size all
the time... MAP_FIXED of an address you don't KNOW is free is a bug.
Period.
(using an address previously obtained from mmap() is safest, but you
could in theory also parse /proc/self/maps, although that is racey,
since nothing guarantees that the C library didn't spawn a background
thread that allocates memory)


