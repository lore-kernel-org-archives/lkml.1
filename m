Return-Path: <linux-kernel-owner+w=401wt.eu-S1759763AbZFNXSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763AbZFNXSh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 19:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbZFNXS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 19:18:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:37062 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbZFNXS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 19:18:28 -0400
Date: Sun, 14 Jun 2009 16:18:50 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
       Magnus Damm <damm@igel.co.jp>, linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of
 I/O devices
Message-ID: <20090614161850.01435082@infradead.org>
In-Reply-To: <200906150057.32424.rjw@sisk.pl>
References: <200906140023.36147.rjw@sisk.pl>
	<200906141158.50171.rjw@sisk.pl>
	<200906150057.32424.rjw@sisk.pl>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 00:57:31 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday 14 June 2009, Rafael J. Wysocki wrote:
> > On Sunday 14 June 2009, Rafael J. Wysocki wrote:
> > > Hi,
> > > 
> > > Below is the current version of my "run-time PM for I/O devices"
> > > patch.
> > > 
> > > I've done my best to address the comments received during the
> > > recent discussions, but at the same time I've tried to make the
> > > patch only contain the most essential things.  For this reason,
> > > for example, the sysfs interface is not there and it's going to
> > > be added in a separate patch.
> > > 
> > > Please let me know if you want me to change anything in this
> > > patch or to add anything new to it.  [Magnus, I remember you
> > > wanted something like ->runtime_wakeup() along with
> > > ->runtime_idle(), but I'm not sure it's really necessary.  Please
> > > let me know if you have any particular usage scenario for it.]
> 
> Appended is an update of the patch addressing the today's comments
> from Magnus.

few comments from me

1) For the usecases for upcoming hw from Intel (where you really can't talk to the hw while it's in powersave mode); the locking needs to be
   IRQ safe. Think of it like this:
   Lets assume you get a (shared) interrupt from your device. In the handler you need to make 100% sure that 
    1) you're not suspended at this point .. basically do a forced wakeup right there and then
    2) assure that you're not about to suspend
2) You use jiffies in the API; I would suggest exposing milliseconds instead and internally convert to jiffies;
   milliseconds tends to be a much more natural unit for this sort of thing

