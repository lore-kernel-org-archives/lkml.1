Return-Path: <linux-kernel-owner+w=401wt.eu-S1751321AbZIVT4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbZIVT4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbZIVT4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:56:25 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:45681 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbZIVT4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:56:24 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Frans Pop <elendil@planet.nl>
Subject: Re: Hibernation oops with 2.6.31 won't fit the screen - bisected
Date: Tue, 22 Sep 2009 21:56:19 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, magnus.damm@gmail.com, tglx@linutronix.de
References: <200909192155.01225.linux@rainbow-software.org> <200909192344.55258.elendil@planet.nl>
In-Reply-To: <200909192344.55258.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909222156.21871.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 September 2009 23:44:54 Frans Pop wrote:
> Ondrej Zary wrote:
> > hibernation worked great with 2.6.30 - I had over a month of uptime (it
> > never worked so well before - always crashed after some time). But in
> > 2.6.31, it's broken again - and completely. The first hibernation works
> > but it always crashes on the second one.
> >
> > The problem is that the oops is so long that it does not fit the screen -
> > even 1280x1024 is not enough. Scrolling does not work (as it used to do
> > on 2.4 kernels), netconsole does not catch it. So how can I debug this?
>
> One way to get at least an indication of what broke the hibernation is to
> run a bisection to find the change that broke hibernation. That could
> provide sufficient clues for a next step.
>
> Would that be an option for you?

I bisected it and found this:

c7121843685de2bf7f3afd3ae1d6a146010bf1fc is first bad commit
commit c7121843685de2bf7f3afd3ae1d6a146010bf1fc
Author: Magnus Damm <magnus.damm@gmail.com>
Date:   Tue Jul 28 14:09:55 2009 -0700

    clocksource: Save mult_orig in clocksource_disable()

    To fix the common case where ->enable() does not set up
    mult, make sure mult_orig is saved in mult on disable.

    Also add comments to explain why we do this.

    Signed-off-by: Magnus Damm <damm@igel.co.jp>
    Cc: johnstul@us.ibm.com
    Cc: lethal@linux-sh.org
    Cc: akpm@linux-foundation.org
    LKML-Reference: <20090618152432.10136.9932.sendpatchset@rx1.opensource.se>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

:040000 040000 c965062bc79af46cdb3522fc7ab1cc81d2f84de3 26616c88a8128b25fd15c3da39ac6251cd9723b6 M      include


Reverting this commit fixes the problem.

-- 
Ondrej Zary
