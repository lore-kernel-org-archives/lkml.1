Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbZHMSjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbZHMSjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 14:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZHMSjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 14:39:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53842 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752841AbZHMSjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 14:39:21 -0400
Date: Thu, 13 Aug 2009 14:39:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC][PATCH 0/3] PM: Asynchronous suspend and resume
In-Reply-To: <200908132028.53094.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908131435490.8368-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009, Rafael J. Wysocki wrote:

> > If the set of pm_connection objects is reasonably small then the
> > master_hook and slave_hook aren't needed; you can just read through the
> > entire list.  Leaving out parent-child connections, which we already
> > know, would help shrink the set.
> 
> Do you mean a global list for the entire system?  I'm not sure if that wouldn't
> hurt performance (please note that it also affects runtime PM).

It doesn't have to affect runtime PM.  That is, for runtime PM we can 
make the bus subsystems responsible for enforcing the dependencies.

> We could use counters of "suspended slaves" and "active masters" to optimize
> things, but still updating these counters could take time (one has to find all
> devices dependent on given one and update a counter for each of them).

The problem with counters is that devices can be removed in the middle 
of a suspend or resume.  That would mess up the counter values.

Alan Stern

