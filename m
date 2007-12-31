Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbXLaP3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbXLaP3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 10:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXLaP3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 10:29:43 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:43828 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbXLaP3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 10:29:42 -0500
Date: Mon, 31 Dec 2007 16:29:39 +0100
From: Christer Weinigel <christer@weinigel.se>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       dpreed@reed.com, Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071231162939.2736562b@zoo.weinigel.se>
In-Reply-To: <20071230211329.39ae77c2@the-village.bc.nu>
References: <477711DC.5030800@keyaccess.nl>
	<alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>
	<20071230144700.78f4605c@the-village.bc.nu>
	<20071230152835.GX16946@elte.hu>
	<4777BDA5.4050203@keyaccess.nl>
	<alpine.LFD.1.00.0712301009220.32517@woody.linux-foundation.org>
	<20071230211329.39ae77c2@the-village.bc.nu>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Dec 2007 21:13:29 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > But that does't mean that other ports won't have the same timings.
> > Also, it doesn't mean that we really need to have exactly *those*
> > timings.
> 
> For ISA bus you want "at least" those timings. That is an easy case
> anyway - ISA bus boxes, old processors and generally no TSC so we can
> fall back to 0x80 - we know from 15 years experience the problem only
> occurs with recent non ISA systems that have borked firmware.
> 
> Lots of ISA hardware does really need the delays and most of it will
> be on old processors as well naturally enough.

If I recall correctly, the MediaGX/Geode processor does need _p for the
PIT accesses, and that CPU family does have a TSC (even though the TSC
stops at times so is hard to use).  I also seem to remember that the
breakage did not happen very often, but running a system without _p
overnight usually showed one hiccup where a read from the counter got
corrupted.

So unless I'm wrong (which I very well could be, it's been a couple of
years since I was debugging the PIT code on a misbehaving Geode SC1200
based system) there is at least one fairly modern CPU, which is used in
lots of embedded systems, and in active use, which does need the _p.

Just a data point... It's not only ancient systems that need _p.

  /Christer

-- 
"Just how much can I get away with and still go to heaven?"

Christer Weinigel <christer@weinigel.se>  http://www.weinigel.se
