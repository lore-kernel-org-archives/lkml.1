Return-Path: <linux-kernel-owner+w=401wt.eu-S932897AbZLNXOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897AbZLNXOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758776AbZLNXOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:14:38 -0500
Received: from sh.osrg.net ([192.16.179.4]:38397 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757928AbZLNXOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:14:37 -0500
Date: Tue, 15 Dec 2009 08:13:53 +0900
To: Valdis.Kletnieks@vt.edu
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, amwang@redhat.com,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Remove usedac in
 feature-removal-schedule.txt
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <17113.1260802675@localhost>
References: <20091214104423X.fujita.tomonori@lab.ntt.co.jp>
	<tip-06f8bda8324fa8bf39eed81d8b3df08063a37696@git.kernel.org>
	<17113.1260802675@localhost>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091215081341Y.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 15 Dec 2009 08:13:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 09:57:55 -0500
Valdis.Kletnieks@vt.edu wrote:

> On Mon, 14 Dec 2009 07:58:01 GMT, tip-bot for FUJITA Tomonori said:
> > Commit-ID:  06f8bda8324fa8bf39eed81d8b3df08063a37696
> 
> > x86: Remove usedac in feature-removal-schedule.txt
> 
> > The usedac option enables us to stop via_no_dac() setting
> > forbid_dac to 1. That is, someone who uses VIA bridges can use
> > DAC with this option even if some of VIA bridges seem to be
> > broken about DAC.
> 
> Does there exist real hardware where this makes sense?  If the chipset
> detects as "broken-DAC", is it in fact safe to use?

Not safe. Probably, you would see data corruption.

arch/x86/kernel/pci-dma.c says:

/* Many VIA bridges seem to corrupt data for DAC. Disable it here */


Seems that some of VIA bridges were fine. So this option made sense
with some hardware. I'm not sure if there are still users of this
option now.


>  Or is it similar to
> the 'force-enable HPET' code for some older boxes, where the HPET was in
> fact there but simply not advertised, so going ahead and using it was
> in fact perfectly safe? Allowing the use of "working but not advertised"
> is probably a good thing, allowing the use of known-broken probably isn't.
> 
> If it's just unadvertised, I wonder if if there's a way to write a quirk
> for VIA systems that will detect the situation and enable the support?

I guess that we could however it doesn't worth adding tricks for old
hardware.
