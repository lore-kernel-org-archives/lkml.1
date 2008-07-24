Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbYGXDrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbYGXDrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 23:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYGXDq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 23:46:56 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3948 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750997AbYGXDqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 23:46:55 -0400
Date: Wed, 23 Jul 2008 23:46:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [USB boot crash, -git] ecm_do_notify(), list_add corruption.
 prev->next should be next (ffff88003b8f82f8)
In-Reply-To: <200807231637.33009.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0807232342510.25883-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2008, David Brownell wrote:

> So far, the fingers point at dummy_hcd... the merge doesn't
> seem to have had problems, and the gadget driver had been
> tested with four different peripheral controller drivers
> (pre-merge).

> But the link state notification (probably using ep-e) message
> couldn't be queued (list_add_tail) because of this oopsing:
> 
> 
> > usb0: qlen 10
> > g_cdc gadget: notify connect false
> > list_add corruption. prev->next should be next (ffff88003b8f82f8), but was ffff88003b8f8e80. (prev=ffff88003b8f8e80).
> 
> Now, prev->next == prev is expected here:  that list of messages
> should be empty.
> 
> What's wrong is that head->prev != head, meaning something
> trashed a dummy_hcd data structure.

The problem could easily be that dummy-hcd simply isn't 
list-debugging-safe.  I wouldn't be at all surprised if, for example, 
it adds a node to a list without initializing the node first.

Alan Stern

