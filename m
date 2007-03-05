Return-Path: <linux-kernel-owner+w=401wt.eu-S1752545AbXCEA3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbXCEA3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 19:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbXCEA3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 19:29:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57746 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbXCEA3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 19:29:23 -0500
Message-Id: <20070305002024.875968120@arndb.de>
User-Agent: quilt/0.45-1
Date: Mon, 05 Mar 2007 01:20:24 +0100
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 0/3] RFC: using hrtimers for in-kernel timeouts
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1/6WgW73gD7dtUenPb4HO0gZ2KPfsoqZf2CQrB
 qkAihNZU2Cp3K2o538IITdX/mFJWiOfrciK88G2h2Kc100KouB
 bBDc87ibKBzr8Fj8P3yNg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've played around with the new timer statistics to see which timers might
benefit of being moved from traditional timers to hrtimers.

Since my understanding is that timer_list timers are not really meant to
expire, this seems to include a lot of what comes in through
schedule_timeout, in particular select() and futex wait.

I have no idea if what I was attempting is even the right approach to
start with, but I want to share the patches in case it is ;-).

Maybe someone is interested in running some low-level benchmarks on this
or point out any bugs in the code.

	Arnd <><

--

