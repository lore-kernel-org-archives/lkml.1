Return-Path: <linux-kernel-owner+w=401wt.eu-S1763465AbYCDRVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763465AbYCDRVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYCDRU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:20:56 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:35316 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbYCDRUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:20:55 -0500
Date: Tue, 4 Mar 2008 18:19:24 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, Adam Belay <abelay@novell.com>,
       Lee Revell <rlrevell@joe-job.com>, linux-pm@lists.linux-foundation.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080304181924.70aaf8c1@mjolnir.drzeus.cx>
In-Reply-To: <20080304071423.0e6b71c1@mjolnir.drzeus.cx>
References: <924EFEDD5F540B4284297C4DC59F3DEEA2E8B2@orsmsx423.amr.corp.intel.com>
	<Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org>
	<20080303231033.GB15255@one.firstfloor.org>
	<20080304040048.GA31562@codemonkey.org.uk>
	<20080304071423.0e6b71c1@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008 07:14:23 +0100
Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> 
> Many devices today are of a less than stellar quality, and singing
> capacitors are a common problem. A high-pitch noise is created, caused
> by power fluctuations as the processor enters and leaves deep sleep at
> a high frequency.
> 
> Instead of just disabling the deep sleep (which wastes power), this
> patch allows you to reduces the number of times it is entered so that
> the frequency can be kept inaudible.
> 
> Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
> --

Hold off on this. It turns out it still has major problems. The menu algorithm now and then gets really bad at predicting sleep times, completely killing this avoidance scheme.

(On that subject, does anyone except Adam understand that algorithm? Some comments wouldn't hurt...)

So for now, I'm back to thinking that measuring the interval between deep sleeps is the better approach. I could use some ideas for a good clock source though. I haven't dug much deeper than jiffies when it comes to kernel timekeeping.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
