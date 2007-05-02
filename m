Return-Path: <linux-kernel-owner+w=401wt.eu-S1766871AbXEBT73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766871AbXEBT73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766873AbXEBT73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:59:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59993 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1766871AbXEBT72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:59:28 -0400
Date: Wed, 2 May 2007 15:59:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Lord <lkml@rtr.ca>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, <marcel@holtmann.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@osdl.org>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [BUG] usb/core/hub.c loops forever on resume
 from ram due to bluetooth
In-Reply-To: <4637CD25.5070104@rtr.ca>
Message-ID: <Pine.LNX.4.44L0.0705021557470.2628-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, Mark Lord wrote:

> I have just replaced my primary single-core notebook
> with a nearly identical dual-core notebook,
> and moved the usb-bluetooth peripheral from the old
> machine to the new one.
> 
> On the single-core machine, suspend/resume (RAM) worked
> fine even with the bluetooth module enabled.
> 
> On the new dual-core machine, resuming with bluetooth
> enabled results in an infinite(?) lockup in an unbounded
> loop in hub_tt_kevent().  With PM debug on, I see
> tens of thousands of these messages scrolling on the console:
> 
>      kernel: usb 5-1: clear tt 4 (9042) error -71
>      kernel: usb 5-1: clear tt 4 (9042) error -71
>      kernel: usb 5-1: clear tt 4 (9042) error -71
>      (over and over and ...)
> 
> By restricting iterations on the unbounded loop
> the machine is able to resume again.
> 
> Greg / Marcel: any words of wisdom?
> 
> And we should probably put bounds permanently on that loop:
> 
> I devised/used this patch to accomplish it.
> Now, I still get close to a thousand or so such
> messages, in groups, showing up in syslog,
> but at least the system can resume after suspend.

A better approach would be to find out why your system gets into that loop 
and fix the underlying cause.

Alan Stern

