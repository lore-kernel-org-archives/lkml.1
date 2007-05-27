Return-Path: <linux-kernel-owner+w=401wt.eu-S1759844AbXE0WCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759844AbXE0WCT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 18:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756794AbXE0WCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 18:02:08 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:43476 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464AbXE0WCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 18:02:08 -0400
Date: Sun, 27 May 2007 23:01:58 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
Message-ID: <20070527220158.GB22687@srcf.ucam.org>
References: <200705272229.21263.rjw@sisk.pl> <200705272231.54535.rjw@sisk.pl> <20070527204955.GA22202@srcf.ucam.org> <200705272345.04518.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705272345.04518.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2007 at 11:45:03PM +0200, Rafael J. Wysocki wrote:
> On Sunday, 27 May 2007 22:49, Matthew Garrett wrote:
> > If we remove process freezing in STR, this should just work[1] without the
> > need to complicate things. 
> 
> Under the (optimistic, IMO) assumption that the relevant user space task won't
> block on I/O with a suspended device involved or something like this.

Yeah, I forgot the footnote that was going to mention that. Clearly 
there are issues if this is on some block device that hasn't been 
resumed yet.

> BTW, I know of two subsystems that want their kernel threads to be frozen for
> synchronization purposes.  Please see these messages:
> 
> 1) https://lists.linux-foundation.org/pipermail/linux-pm/2007-May/012592.html
> (plus follow up)
> 
> 2) http://marc.info/?l=linux-kernel&m=117919066830575&w=2

I'm not entirely sold on this. The issue is that there's the possibility 
of races during suspend/resume? It sounds like that should be 
implemented in the driver, rather than depending on a side-effect of 
process freezing. Otherwise there's no way of selectively suspending 
that device.

> Besides, there's the hibernation that needs to freeze tasks for another reason,
> so it needs some way to ensure that drivers won't request firmware while
> the user land is frozen.

I agree that that's an issue right now, but I think we should see if 
this is repairable without just breaking those drivers. One option would 
be to defer resuming them until userspace is alive again - that would be 
no worse than the suspend to RAM case without process freezing.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
