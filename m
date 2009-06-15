Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbZFOUCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbZFOUCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 16:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbZFOUB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 16:01:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45639 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbZFOUBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 16:01:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of I/O devices
Date: Mon, 15 Jun 2009 22:02:30 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
       Magnus Damm <damm@igel.co.jp>, linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
References: <200906140023.36147.rjw@sisk.pl> <200906150057.32424.rjw@sisk.pl> <20090614161850.01435082@infradead.org>
In-Reply-To: <20090614161850.01435082@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906152202.32094.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 June 2009, Arjan van de Ven wrote:
> On Mon, 15 Jun 2009 00:57:31 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Sunday 14 June 2009, Rafael J. Wysocki wrote:
> > > On Sunday 14 June 2009, Rafael J. Wysocki wrote:
> > > > Hi,
> > > > 
> > > > Below is the current version of my "run-time PM for I/O devices"
> > > > patch.
> > > > 
> > > > I've done my best to address the comments received during the
> > > > recent discussions, but at the same time I've tried to make the
> > > > patch only contain the most essential things.  For this reason,
> > > > for example, the sysfs interface is not there and it's going to
> > > > be added in a separate patch.
> > > > 
> > > > Please let me know if you want me to change anything in this
> > > > patch or to add anything new to it.  [Magnus, I remember you
> > > > wanted something like ->runtime_wakeup() along with
> > > > ->runtime_idle(), but I'm not sure it's really necessary.  Please
> > > > let me know if you have any particular usage scenario for it.]
> > 
> > Appended is an update of the patch addressing the today's comments
> > from Magnus.
> 
> few comments from me
> 
> 1) For the usecases for upcoming hw from Intel (where you really can't talk to the hw while it's in powersave mode); the locking needs to be
>    IRQ safe. Think of it like this:
>    Lets assume you get a (shared) interrupt from your device. In the handler you need to make 100% sure that 
>     1) you're not suspended at this point .. basically do a forced wakeup right there and then
>     2) assure that you're not about to suspend

Does it mean we need to use spin_[un]lock_irq[save|restore]() everywhere in the
framework?

> 2) You use jiffies in the API; I would suggest exposing milliseconds instead and internally convert to jiffies;
>    milliseconds tends to be a much more natural unit for this sort of thing

OK

Best,
Rafael
