Return-Path: <linux-kernel-owner+w=401wt.eu-S937328AbXGUN4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937328AbXGUN4h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 09:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762944AbXGUN4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 09:56:30 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3158 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761418AbXGUN43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 09:56:29 -0400
Date: Sat, 21 Jul 2007 09:56:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Nigel Cunningham <nigel@nigel.suspend2.net>
cc: Miklos Szeredi <miklos@szeredi.hu>, <rjw@sisk.pl>, <miltonm@bga.com>,
       <ying.huang@intel.com>, <linux-kernel@vger.kernel.org>, <david@lang.hm>,
       <linux-pm@lists.linux-foundation.org>, <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <200707212243.35602.nigel@nigel.suspend2.net>
Message-ID: <Pine.LNX.4.44L0.0707210954490.8201-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007, Nigel Cunningham wrote:

> What am I missing in the following suggested solution?
> 
> 1) In the freezer code, we implement a new TIF_LATEFREEZE process flag, which, 
> when set, causes a  userspace process to be frozen with kernel threads 
> instead of with userspace ones. When freezing, we freezing !TIF_LATEFREEZE, 
> sync and then freeze TIF_LATEFREEZE and freezable kernel threads.
> 
> 2) In the fuse code, the PID of the process that will do the work gets passed 
> to the fuse kernel code when the mount is done. The kernel code sets the 
> TIF_LATEFREEZE flag, and resets it on umount.

What happens when one FUSE filesystem makes use of another?  You'll 
still end up with unfreezable processes, except that now you won't 
detect them until the LATEFREEZE stage.

Alan Stern

