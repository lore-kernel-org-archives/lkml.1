Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbXLBUIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbXLBUIa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 15:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbXLBUIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 15:08:20 -0500
Received: from netrider.rowland.org ([192.131.102.5]:3380 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756909AbXLBUIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 15:08:19 -0500
Date: Sun, 2 Dec 2007 15:08:18 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Arjan van de Ven <arjan@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Need lockdep help
In-Reply-To: <20071202120411.2aac7720@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.44L0.0712021506500.4185-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Dec 2007, Arjan van de Ven wrote:

> > This creates a lockdep violation; each rwsem in turn is locked while 
> > the other is being held.  However the only way this could lead to 
> > deadlock would be if there was already a bug in the system Power 
> > Management code (overlapping notifications).
> 
> or.. modifications to the notifier chain while all this is happening
> (remember: rwsems are fair, once a writer shows up, all readers wait)

But modifications to the notifier chain don't invoke the callout
routines.  Hence they won't try to lock the new rwsem and won't lead to
deadlock.

Alan Stern

