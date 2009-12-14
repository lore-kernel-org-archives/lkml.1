Return-Path: <linux-kernel-owner+w=401wt.eu-S1758538AbZLNWCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538AbZLNWCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758495AbZLNWCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:02:53 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46291 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758467AbZLNWCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:02:52 -0500
Date: Mon, 14 Dec 2009 17:02:51 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Tejun Heo <tj@kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Warn people about flush_scheduled_work()
In-Reply-To: <200912142242.06633.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0912141701040.2690-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009, Oliver Neukum wrote:

> Am Montag, 14. Dezember 2009 22:33:38 schrieb Alan Stern:
> >         Consider using cancel_work_sync() or cancel_delayed_work_sync()
> >         instead.  In most situations they will accomplish what you 
> >         need.
> 
> In which respect is cancel_work_sync() fundamentally safer?
> If the work is already running and takes a lock you are holding,
> then what?

With cancel_work_sync() you _know_ what locks the work item is going to
take, since it's your work item.  With flush_scheduled_work() you have
no idea what locks will be needed by the items on the queue.  They 
could come from anywhere.

Alan Stern

