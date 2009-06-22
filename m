Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbZFVPdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbZFVPdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbZFVPdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:33:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58743 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731AbZFVPdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:33:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [linux-pm] [patch update 2 fix] PM: Introduce core framework for  run-time PM of I/O devices
Date: Mon, 22 Jun 2009 17:33:42 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
References: <Pine.LNX.4.44L0.0906192141380.4003-100000@netrider.rowland.org> <aec7e5c30906212320v3e3e991fyd028d005675f1e25@mail.gmail.com> <20090621234324.06fda564@infradead.org>
In-Reply-To: <20090621234324.06fda564@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906221733.44629.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009, Arjan van de Ven wrote:
> On Mon, 22 Jun 2009 15:20:43 +0900
> Magnus Damm <magnus.damm@gmail.com> wrote:
> 
> > On Sat, Jun 20, 2009 at 11:30 PM, Alan
> > Stern<stern@rowland.harvard.edu> wrote:
> > > Some more thoughts...
> > >
> > > Magnus, you might have some insights here.  It occurred to me that
> > > some devices can switch power levels very quickly, and the drivers
> > > might therefore want the runtime suspend and resume methods to be
> > > called as soon as possible, even in interrupt context.
> > 
> > I'd like to call pm_request_suspend() from interrupt context. I don't
> 
> there are some really strong reasons to at least be able to call the
> resume function from an interrupt handler.... shared interrupts are one
> of them.

Yes.  But that requires your hardware to be able to wake up fast enough, so I
think we can introduce pm_runtime_resume_atomic() and
pm_runtime_suspend_atomic() to be used with the devices that can do that, as
proposed by Alan.

Surely not all devices can do it, though.

Best,
Rafael
