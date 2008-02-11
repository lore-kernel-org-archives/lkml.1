Return-Path: <linux-kernel-owner+w=401wt.eu-S1759274AbYBKRNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbYBKRNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYBKRNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:13:15 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:36593 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbYBKRNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:13:14 -0500
Date: Mon, 11 Feb 2008 18:13:21 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: allow 64bit setting in Kconfig
Message-ID: <20080211171321.GA22584@uranus.ravnborg.org>
References: <20080128220944.GI8767@does.not.exist> <20080201152227.GB32085@elte.hu> <20080204204555.GC505@cs181133002.pp.htv.fi> <20080211163740.GA2446@elte.hu> <20080211165055.GA2959@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211165055.GA2959@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In my experience there is no way for me to enable 64BIT without somehow 
> manually fiddling with ARCH.
> 
> No matter whether it's menuconfig or oldconfig or whatever else.

>From the patch description when ARCH=x86 were introduced:

    # make {allno,allyes,allmod,rand}config [ARCH=...]
    option \ host arch      | 32bit         | 64bit
    =====================================================
    ./.                     | 32bit         | 64bit
    ARCH=x86                | 32bit         | 32bit
    ARCH=i386               | 32bit         | 32bit
    ARCH=x86_64             | 64bit         | 64bit

    The general rule are that ARCH= and native architecture
    takes precedence over the configuration.
    So make ARCH=i386 [whatever] will always build a 32-bit
    kernel no matter what the configuration says.
    The configuration will be updated to 32-bit if it was
    configured to 64-bit and the other way around.

    This behaviour is consistent with previous behaviour so
    no suprises here.

    make ARCH=x86 will per default result in a 32-bit kernel
    but as the only ARCH= value x86 allow the user to select
    between 32-bit and 64-bit using menuconfig.

So what you see is what was then discussed and considered
optimal functionality.
We shall keep in mind the main target here is to keep
peoples systems running as usual when they shift to
the unified {32 bit / 64 bit} x86 arch.

If you want anything changed then do this with respect to
the intended behaviour as documented above and keep the
setup used by our less kernel skilled testers in mind.

And you do not belong to the "less kernel skilled"
testers base.

	Sam
