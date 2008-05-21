Return-Path: <linux-kernel-owner+w=401wt.eu-S934211AbYEUOWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934211AbYEUOWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbYEUOWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 10:22:33 -0400
Received: from styx.suse.cz ([82.119.242.94]:44100 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755507AbYEUOWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 10:22:32 -0400
Date: Wed, 21 May 2008 16:22:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, lchiquitto@novell.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: fix deadlock in HCD code
In-Reply-To: <Pine.LNX.4.44L0.0805211005071.2490-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.64.0805211620270.6718@jikos.suse.cz>
References: <Pine.LNX.4.44L0.0805211005071.2490-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Alan Stern wrote:

> > Used in the suspend code. Your patch is indeed correct, but I fear 
> > there might be a second bug caused by wrong calling conditions.
> The problem in the Novell bugzilla entry was caused by the fact that the 
> OHCI irq routine was invoked with interrupts enabled, owing to a missing 
> IRQF_DISABLED flag.  That bug has already been fixed in 2.6.25.

That indeed is 2.6.25 kernel. I guess you are talking about commit 
442258e2ff69 here. If so, the reporter is definitely using the kernel 
containing this commit, and the lockups still trigger.

Seems that my patch is papering over the real bug (someone enabling 
interrupts somewhere) indeed, but I can't seem to be able to find such 
codepath.

Thanks,

-- 
Jiri Kosina
SUSE Labs
