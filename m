Return-Path: <linux-kernel-owner+w=401wt.eu-S1751388AbZJSFEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbZJSFEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 01:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbZJSFEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 01:04:34 -0400
Received: from www.tglx.de ([62.245.132.106]:47295 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbZJSFEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 01:04:34 -0400
Date: Mon, 19 Oct 2009 07:04:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Kacur <jkacur@redhat.com>
cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH RFC] PPC-BRIQ_PANEL: Remove BKL and replace with atomic
 variable.
In-Reply-To: <alpine.LFD.2.00.0910182137470.3462@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0910190658070.4975@localhost.localdomain>
References: <alpine.LFD.2.00.0910182137470.3462@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2005;0cOn Sun, 18 Oct 2009, John Kacur wrote:

> >From b64c7d0f11eab96cb253b23c7264c999746116c0 Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Sun, 18 Oct 2009 21:29:21 +0200
> Subject: [PATCH] PPC-BRIQ_PANEL: Remove BKL and replace with atomic variable.
> 
> There are no locks here except the bkl in briq_panel_open. It's only
> purpose is to ensure single access. Remove the bkl and ensure single access
> by making vfd_is_open an atomic_variable.

And again, can you please look more carefully at the init
vs. read/write functions ?

The BKL is not only protecting the single user variable it's also
serializing write against the access to the display in init.

Thanks,

	tglx
