Return-Path: <linux-kernel-owner+w=401wt.eu-S1752240AbXJ0WYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbXJ0WYW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 18:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbXJ0WYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 18:24:12 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3528 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750895AbXJ0WYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 18:24:11 -0400
Date: Sat, 27 Oct 2007 18:24:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: linux-kernel@vger.kernel.org, <netdev@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] QUESTION: How to fix race between .suspend routine
 and watchdog timer
In-Reply-To: <200710272119.44574.maximlevitsky@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0710271820240.2321-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2007, Maxim Levitsky wrote:

> > Use del_timer_sync().  It guarantees that when it returns, the timer 
> > will be stopped and the timer routine will no longer be running on any 
> > CPU.
> > 
> Even if the timer re-enables itself, are you sure?

Last time I looked at the source code, that's what it did.  I'll look
again...  Yep, it still does.  It checks to see if the timer routine is
currently running; if so then it waits a little while and tries again.

Alan Stern

