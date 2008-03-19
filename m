Return-Path: <linux-kernel-owner+w=401wt.eu-S1162828AbYCSXGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162828AbYCSXGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935225AbYCSVb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:31:28 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2264 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932549AbYCSVb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:31:26 -0400
Date: Tue, 18 Mar 2008 22:44:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pavel Machek <pavel@ucw.cz>, pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and
 hibernation callbacks
In-Reply-To: <200803190204.07592.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803182233370.10154-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008, Rafael J. Wysocki wrote:

> In the meantime I had an IRC chat with Ben, who wanted a couple of quite
> substantial changes to be made to this patch.
> 
> First, Ben thinks that ->prepare() should be called in a separate loop for
> all devices, before any of them is suspended, so that drivers can assume the
> availability of the other devices during ->prepare() (for example, so that they
> can use GFP_KERNEL memory allocations).  Accordingly, ->complete() would
> be called in a separate loop after calling ->resume() for all devices.

In order to make this work, you would have to prevent new children from
being registered starting from the time just after prepare() returns,
rather than from the time just before suspend() is called.  Nothing is
wrong with that, but it requires a redesign of the new flags.  (It's 
worth mentioning that drivers will want to have a flag that gets set 
just _before_ prepare() -- just _after_ is too late.)

In the other direction, it ought to be okay to allow new children to 
be registered during resume().  There's no need to wait for complete().

> Next, he wants the number of noirq callbacks to be reduced.

I agree.  For example, there isn't much point in having prepare() and
complete() entries for noirq.

> Both of the above things make sense, so I'll rework the patch (or maybe even
> all three patches) to implement them and we'll see how they will look like.

Alan Stern

