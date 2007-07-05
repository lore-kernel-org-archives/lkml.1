Return-Path: <linux-kernel-owner+w=401wt.eu-S1762264AbXGEVhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762264AbXGEVhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 17:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758449AbXGEVhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 17:37:35 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:45501 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588AbXGEVhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 17:37:35 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 23:37:26 +0200
User-Agent: KMail/1.9.7
Cc: Miklos Szeredi <miklos@szeredi.hu>, pavel@ucw.cz, paulus@samba.org,
       johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
References: <Pine.LNX.4.44L0.0707051713440.2753-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707051713440.2753-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707052337.27066.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 5. Juli 2007 schrieb Alan Stern:
> On Thu, 5 Jul 2007, Miklos Szeredi wrote:
> 
> > I fear, that your efforts to "save" the freezer are in vain.  It is
> > already moderately hackish with that PF_FREEZER_SKIP and the kernel
> > dotted randomly with try_to_freeze() calls, but adding bandaids to try
> > to order freezing userspace processes in the right order would just
> > make it a horrible mess.
> 
> I agree that bandaids won't work.  What's needed is something more 
> radical.  Things like FUSE must be written so that the kernel parts 
> _can_ freeze even while they are waiting for a response from a user 
> thread.

OK, some radical ideas.

In principle we want a deadlock here. Tasks that are frozen due to fuse
are as good as frozen, there's no need to formally freeze them.
The bad uninterruptible tasks are those waiting for hardware.

Can we detect the difference? Perhaps we can label those crucial locks
and when only tasks in the refrigerator and tasks waiting on these locks
are left we are content and go on to suspending the device tree.

	Flame away
		Oliver
