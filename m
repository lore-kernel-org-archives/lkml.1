Return-Path: <linux-kernel-owner+w=401wt.eu-S1760230AbXHXQNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230AbXHXQNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbXHXQNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:13:36 -0400
Received: from aa013msr.fastwebnet.it ([85.18.95.73]:57039 "EHLO
	aa013msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbXHXQNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:13:36 -0400
Date: Fri, 24 Aug 2007 18:13:26 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Bob Picco" <bob.picco@hp.com>, "john stultz" <johnstul@us.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: "double" hpet clocksource && hard freeze [bisected]
Message-ID: <20070824181326.57ee5a2c@localhost>
In-Reply-To: <617E1C2C70743745A92448908E030B2A023EB8C4@scsmsx411.amr.corp.intel.com>
References: <20070823222115.122a37ca@localhost>
	<617E1C2C70743745A92448908E030B2A023EB2E1@scsmsx411.amr.corp.intel.com>
	<1187903135.6024.18.camel@localhost.localdomain>
	<1187905306.6024.24.camel@localhost.localdomain>
	<20070824124631.GF10594@localhost>
	<20070824152745.56214a24@localhost>
	<617E1C2C70743745A92448908E030B2A023EB8C4@scsmsx411.amr.corp.intel.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 09:04:22 -0700
"Luck, Tony" <tony.luck@intel.com> wrote:

> It is good to avoid registering two clocksources with the same name, but
> the fix might be a bit more fragile than the eariler one that temporarily
> marked the drivers/char/hpet.c one as CONFIG_IA64 only.  Given that the
> hang went away when you applied the earlier patch, I conclude that the
> drivers/char/hpet.c code is the one that got selected when you had two
> "hpet" entries ... and that there is something wrong with that code that
> doesn't work right on x86_64.  The fix to prevent registering a duplicate
> name is presumably working for you simply because arch/x86_64/kernel/hpet.c
> happens to get there first with its "hpet", so the drivers/char/hpet.c one
> is dropped.  If something changed that reversed the order of these registrations,
> then you'd get the "hpet" clocksource that results in a hang.

100% agree

-- 
	Paolo Ornati
	Linux 2.6.23-rc3-g1a8f4610-dirty on x86_64
