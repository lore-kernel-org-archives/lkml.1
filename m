Return-Path: <linux-kernel-owner+w=401wt.eu-S1765374AbXIMHAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765374AbXIMHAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 03:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759383AbXIMHAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 03:00:37 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:54561 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbXIMHAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 03:00:36 -0400
Date: Thu, 13 Sep 2007 09:02:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Frank van Maarseveen <frankvm@frankvm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22.6: still seeing section mismatch warnings
Message-ID: <20070913070200.GA23330@uranus.ravnborg.org>
References: <20070912160017.GA3948@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912160017.GA3948@janus>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 06:00:17PM +0200, Frank van Maarseveen wrote:
> I'm still seeing the warnings below (2.6.22 started off with lots of
> section mismatch warning) but I have no idea if it is safe to ignore
> these:
> 
> WARNING: arch/i386/kernel/built-in.o(.text+0xea62): Section mismatch: reference to .init.data:trampoline_end (between 'setup_trampoline' and 'cpu_coregroup_map')
> WARNING: arch/i386/kernel/built-in.o(.text+0xea67): Section mismatch: reference to .init.data:trampoline_data (between 'setup_trampoline' and 'cpu_coregroup_map')
> WARNING: arch/i386/kernel/built-in.o(.text+0xea79): Section mismatch: reference to .init.data:trampoline_data (between 'setup_trampoline' and 'cpu_coregroup_map')
> WARNING: arch/i386/kernel/built-in.o(.exit.text+0x26): Section mismatch: reference to .init.text: (between 'cache_remove_dev' and 'ffh_cstate_exit')
> WARNING: arch/i386/kernel/built-in.o(.data+0xee0): Section mismatch: reference to .init.text: (between 'thermal_throttle_cpu_notifier' and 'mce_work')
> WARNING: kernel/built-in.o(.text+0x1b415): Section mismatch: reference to .init.text: (between 'kthreadd' and 'init_waitqueue_head')
> 
> 
> gcc version 3.4.6 (Debian 3.4.6-5)

Does not appear with an allmodconfig.
Care to send me your .config then I may take a look.

The warnings are the kernel being much more anal with respect to use
of __init sections and friends and you can for normal use ignore them.
They usually find bugs in errorhandling which seldom trigger and
the bugs has been there for ages in most cases - but it is onyl now
we detect them.

	Sam
