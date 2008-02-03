Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbYBCFGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbYBCFGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 00:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYBCFGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 00:06:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33093 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbYBCFGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 00:06:06 -0500
Date: Sun, 3 Feb 2008 06:05:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] sleepy linux self-test
Message-ID: <20080203050537.GA18942@elte.hu>
References: <20080130131748.GA3796@elf.ucw.cz> <20080202193202.GB31621@elf.ucw.cz> <20080202193843.GB32039@elte.hu> <200802021837.17777.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802021837.17777.david-b@pacbell.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Brownell <david-b@pacbell.net> wrote:

> On Saturday 02 February 2008, Ingo Molnar wrote:
> > 
> > * Pavel Machek <pavel@ucw.cz> wrote:
> > 
> > > > It would have been easier to just use the public interface and 
> > > > hard-wire "rtc0".  But going directly to the hardware was dirtier, 
> > > > and more in the spirit of "hack that obviously shouldn't go upstream 
> > > > until it gets done properly".
> > > 
> > > Yes, it was "quick and dirty". And I do not think it is going upstream 
> > > in this form...?
> > 
> > which would be a pity - this thing _almost_ started doing suspend and 
> > resume cycles on my testsystems, all by itself :-)
> 
> OK, here's a version that's cleaner and suspends.  Resuming ... 
> another story, it's currently broken on this ARM board (no 
> relationship to this testing code).

yay! Threw this into my setup. It built fine with the new option 
disabled and enabled as well. Unfortunately it said this:

[   23.509562] Calling initcall 0xc0c49e00: be_sleepy+0x0/0x170()
[   23.515837] PM: no wakelarm-capable RTC
[   23.517562] initcall 0xc0c49e00: be_sleepy+0x0/0x170() returned 0.

(oh, btw., a small typo: s/wakelarm/wakealarm/)

is "wakealarm" something generally available on PC RTCs? I'll try to 
look into the BIOS setup, maybe it's just disabled ...

	Ingo
