Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab0CJPE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:04:26 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:58058 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756034Ab0CJPEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:04:25 -0500
Date: Wed, 10 Mar 2010 10:04:22 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Markus Rechberger <mrechberger@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: USBFS Memory allocation Bug
In-Reply-To: <d9def9db1003100133wa705618ped71e146cf4c326d@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1003100958250.1516-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010, Markus Rechberger wrote:

> > At any rate, clearly the bug, if there is one, lies in the memory
> > management subsystem and not in usbfs.
> >
> 
> seems like yes, but the final result of this is that mediasrv was not
> killable anymore.

You should have said so earlier.  That is indeed a serious bug.

> Shouldn't the syscall just fail if this happens?

It _does_ just fail if memory can't be allocated.  Here's the relevant 
code from proc_do_submiturb():

		as->urb->transfer_buffer = kmalloc(uurb->buffer_length,
				GFP_KERNEL);
		if (!as->urb->transfer_buffer) {
			kfree(isopkt);
			kfree(dr);
			free_async(as);
			return -ENOMEM;
		}

Where was the mediasrv process hung when you tried to kill it?

Alan Stern

