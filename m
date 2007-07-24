Return-Path: <linux-kernel-owner+w=401wt.eu-S1761600AbXGXO1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761600AbXGXO1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 10:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbXGXO10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 10:27:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49940 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750761AbXGXO1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 10:27:25 -0400
Date: Tue, 24 Jul 2007 10:27:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: Towards eliminating the freezer
In-Reply-To: <200707241021.35573.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0707241025020.3568-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Oliver Neukum wrote:

> Am Montag 23 Juli 2007 schrieb Alan Stern:
> > Now here's an idea which might work.  Can we require every caller of
> > device_add() to hold some existing device's semaphore?  Normally it
> > would be the semaphore of the new device's parent, but it could be a
> > higher ancestor.  There even could be a single "root" semaphore for
> > drivers registering a top-level device with no parent.
> 
> What prevents us from having a device addition semaphore?
> Adding device is not critical to performance, is it?

It would create a locking order violation.  Many drivers hold a device
semaphore while registering a child device, so they would acquire your
new semaphore while holding a device sem.  But the PM core needs to
prevent registration while calling suspend() methods, so it would need
to acquire the device sems while holding your new semaphore.

Alan Stern

