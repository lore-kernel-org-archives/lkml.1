Return-Path: <linux-kernel-owner+w=401wt.eu-S1752919AbYATLT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbYATLT4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 06:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbYATLTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 06:19:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46636 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbYATLTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 06:19:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc8-mm1: WARN_ON() in clockevents_register_device() on HP nx6325
Date: Sun, 20 Jan 2008 12:21:39 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <200801200210.38412.rjw@sisk.pl> <20080120102440.GA507@elte.hu>
In-Reply-To: <20080120102440.GA507@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801201221.40098.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 20 of January 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > Something goes wrong in the timers land.  I get this on boot:
> > 
> > ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> > Disabling APIC timer
> > ------------[ cut here ]------------
> > WARNING: at /home/rafael/src/mm/linux-2.6.24-rc8-mm1/kernel/time/clockevents.c:1
> > 65 clockevents_register_device+0x36/0xc4()
> 
> ok, since we disable the APIC timer, i suspect this warning can be 
> disregarded - the bootup is otherwise fine, right?
> 
> Thomas - why do we register it while it's disabled? I have put in that 
> warning to detect APIC miscalibrations.

Well, for an unknown reason, there's a ~5 s delay during resume from RAM (in
fact I can also trigger it in the "core" test mode, ie. without entering the
sleep state), which I thought might be related.  If not, it might be necessary
to bisect again.  Sigh.

Thanks,
Rafael
