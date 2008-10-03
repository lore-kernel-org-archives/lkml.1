Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbYJCMuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbYJCMuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 08:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbYJCMuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 08:50:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:34612 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbYJCMuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 08:50:21 -0400
Date: Fri, 3 Oct 2008 05:49:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH 1/6] Hibernation: Introduce new system state for the
 last phase of hibernation
Message-ID: <20081003054921.376a41ec@infradead.org>
In-Reply-To: <200810031327.19293.rjw@sisk.pl>
References: <200808290002.55026.rjw@sisk.pl>
	<200809300010.39000.rjw@sisk.pl>
	<20081003013557.42ce685d.akpm@linux-foundation.org>
	<200810031327.19293.rjw@sisk.pl>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008 13:27:18 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Friday, 3 of October 2008, Andrew Morton wrote:
> > On Tue, 30 Sep 2008 00:10:37 +0200 "Rafael J. Wysocki"
> > <rjw@sisk.pl> wrote:
> > 
> > > Hibernation: Introduce new system state for the last phase of
> > > hibernation
> > > 
> > > Replace unused SYSTEM_SUSPEND_DISK with a new system_state value
> > > SYSTEM_HIBERNATE_ENTER that can be used by device drivers to
> > > check if the system is in the last phase of hibernation.
> > 
> > Violent objections.
> > 
> > We just don't know what this change will do.  It potentially affects
> > every code site in the kernel which looks at system_state.
> 
> Do you mean anyone checking 'system_state != SOMETHING' ?  Oh well.

I think Andrew also means things looking for system_state > something
like

arch/powerpc/platforms/cell/smp.c:      if (system_state < SYSTEM_RUNNING &&
arch/powerpc/kernel/smp.c:      if (system_state < SYSTEM_RUNNING)
arch/powerpc/kernel/smp.c:      if (system_state > SYSTEM_BOOTING)
drivers/xen/xenbus/xenbus_probe.c:      if (system_state > SYSTEM_RUNNING) {


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
