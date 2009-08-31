Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbZHaP7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbZHaP7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 11:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbZHaP7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 11:59:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53042 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbZHaP7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 11:59:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 10] PM: Measure suspend and resume times for individual devices (was: Re: [PATCH 2/6] PM: Asynchronous resume of devices)
Date: Mon, 31 Aug 2009 18:00:49 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <Pine.LNX.4.44L0.0908311006490.10295-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908311006490.10295-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908311800.49664.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 August 2009, Alan Stern wrote:
> On Sun, 30 Aug 2009, Rafael J. Wysocki wrote:
> 
> > > > For testing purposes it would be nice to have a one-line summary for
> > > > each device containing a thread ID, start timestamp, end timestamp, and
> > > > elapsed time.  With that information you could evaluate the amount of
> > > > parallelism and determine where the bottlenecks are.  It would give a
> > > > much more detailed picture of the entire process than the total time of
> > > > your recent patch 9.
> > > 
> > > Of course it would.  I think I'll implement it.
> > 
> > OK, below is a patch for that.  It only prints the time elapsed, because the
> > timestamps themselves can be obtained from the usual kernel timestamping.
> 
> Does that include the start timestamps?  I don't see them anywhere in
> the patch.  Without the start timestamps we have no way to know how
> much time was spent waiting for dpm_list_mtx or other resources as
> opposed to actually carrying out the operation.

If the callback in question is actually defined, there will be additional debug
printouts before executing it from which we can get the start timestamps.

If the callback is not defined, the time elapsed will be 0 anyway, which is
kind of untinteresting.

Thanks,
Rafael
