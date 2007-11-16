Return-Path: <linux-kernel-owner+w=401wt.eu-S1762807AbXKPRQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762807AbXKPRQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 12:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbXKPRQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 12:16:47 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:37838 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbXKPRQq (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:16:46 -0500
Date: Fri, 16 Nov 2007 12:16:29 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Nelson, Shannon" <shannon.nelson@intel.com>
cc: linux-rt-users@vger.kernel.org, Linux-kernel@vger.kernel.org,
       Sven-Thorsten Dietrich <sdietrich@novell.com>
Subject: Re: [PATCH][RT] 2.6.24-rc2-rt1 drivers/dma/ioat_dma.c compile fix
In-Reply-To: <BAE9DCEF64577A439B3A37F36F9B691C0371E3E3@orsmsx418.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.58.0711161214480.24276@gandalf.stny.rr.com>
References: <BAE9DCEF64577A439B3A37F36F9B691C0371E3E3@orsmsx418.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 16 Nov 2007, Nelson, Shannon wrote:
> first->async_tx.phys;
> > -       __list_splice(&new_chain, ioat_chan->used_desc.prev);
> > +       list_splice_tail(&new_chain, ioat_chan->used_desc.prev);
> >
>
> NAK.
>
> These functions do insertions differently.  The 'prev' is pointing to
> the last valid descriptor in the queue and you really want to get the
> new_chain stuck on after this.  Your list_splice_tail() will insert the
> new_chain just before it which will muck up the order of the DMA
> requests.
>
> You might have more success with
> 	list_splice_tail(&new_chain, ioat_chan->used_desc);
> where used_desc points to the whole list, rather than using the .prev
> pointer to a specific node.
>
> Please copy me on future ioatdma related comments.
>

And people wonder why we post RT related patches to LKML. This is exactly
why!

Thanks for the response Shannon!

-- Steve

