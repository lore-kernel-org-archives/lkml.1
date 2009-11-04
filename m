Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbZKDOOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbZKDOOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 09:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756394AbZKDOOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 09:14:23 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:48195 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809AbZKDOOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 09:14:22 -0500
Date: Wed, 4 Nov 2009 15:15:45 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Arnaud Patard <apatard@mandriva.com>, linux-mips@linux-mips.org,
       LKML <linux-kernel@vger.kernel.org>, huhb@lemote.com, yanh@lemote.com,
       Zhang Le <r0bertz@gentoo.org>, Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       liujl@lemote.com
Subject: Re: [PATCH -queue v0 5/6] [loongson] rtc: enable legacy RTC driver
	on fuloong2f
Message-ID: <20091104141545.GA18408@linux-mips.org>
References: <cover.1257325319.git.wuzhangjin@gmail.com> <e13ed33a99dbf14f223360d414aa2b2c5caa9b1f.1257325319.git.wuzhangjin@gmail.com> <m3eioetvx5.fsf@anduin.mandriva.com> <1257333527.8716.20.camel@falcon.domain.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257333527.8716.20.camel@falcon.domain.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 07:18:47PM +0800, Wu Zhangjin wrote:

> In reality, fuloong2e, fuloong2f and yeeloong2f work fine with RTC_LIB,
> but relative patches need to append to drivers/rtc/rtc-cmos.c and also
> need a RTC platform device. If what I remembered is right, Gdium also
> need corresponding patches to make it work with RTC_LIB.
> 
> Herein, I just let the basic support for those machines work, and then,
> the RTC_LIB support will be sent out later.
> 
> and a small question: if legacy RTC driver works well on these machines,
> why should we forbid people to use it? I think it's better to remove the
> "select RTC_LIB" line for MIPS, and then, the people will be free to
> choose what they want, and even for the users whose platform not support
> RTC_LIB.

RTC_LIB is the way to go; the non-RTC_LIB drivers are there only for
backward compatbility.  A grep through the defcconfig files for all
platforms on all architectures finds that by now all have set
CONFIG_RTC_LIB and the remaining users of CONFIG_RTC, CONFIG_JS_RTC,
CONFIG_GEN_RTC, CONFIG_EFI_RTC, CONFIG_DS1302 (which all depend on !RTC_LIB)
are all defconfig files which seem to be slowly bitrotting.

Time to axe !RTC_LIB?  I'm tempted.

  Ralf
