Return-Path: <linux-kernel-owner+w=401wt.eu-S1758390AbYCVXpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390AbYCVXpY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 19:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbYCVXpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 19:45:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48464 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497AbYCVXpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 19:45:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation callbacks (rev. 2)
Date: Sun, 23 Mar 2008 00:44:27 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <Pine.LNX.4.44L0.0803221920150.8044-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803221920150.8044-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803230044.29132.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 23 of March 2008, Alan Stern wrote:
> On Sat, 22 Mar 2008, Rafael J. Wysocki wrote:
> 
[--snip--]
> 
> No, you have missed the entire point.  The problem doesn't exist in the
> current code; it exists only if we switch over to using a single list.  
> Routines like dpm_suspend() won't be able to use list_for_each_entry()
> to traverse the list because entries may be removed by other threads
> during the traversal.  Even list_for_each_entry_safe() won't work
> correctly without careful attention to details.

Ah, ok.  Thanks for the clarification.

Doesn't it help that we traverse the list under dpm_list_mtx?  Anyone who
removes an entry is required to take dpm_list_mtx that we're holding while
the list is traversed except when the callbacks are invoked.

The only problem I see is when the device currently being handled is removed
from the list by a concurrent thread.  Is that you were referring to?

Rafael
