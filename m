Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbZG2N4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbZG2N4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755706AbZG2N4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:56:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45274 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755705AbZG2N4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:56:32 -0400
Date: Wed, 29 Jul 2009 09:56:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, <stable@kernel.org>,
       <stable-review@kernel.org>, <torvalds@linux-foundation.org>,
       <akpm@linux-foundation.org>, <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 14/71] USB: EHCI: use the new clear_tt_buffer interface
In-Reply-To: <20090728234153.376866725@mini.kroah.org>
Message-ID: <Pine.LNX.4.44L0.0907290952001.3087-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009, Greg KH wrote:

> 2.6.30-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> commit 914b701280a76f96890ad63eb0fa99bf204b961c upstream.
> 
> This patch (as1256) changes ehci-hcd and all the other drivers in the
> EHCI family to make use of the new clear_tt_buffer callbacks.  When a
> Clear-TT-Buffer request is in progress for a QH, the QH is not allowed
> to be linked into the async schedule until the request is finished.
> At that time, if there are any URBs queued for the QH, it is linked
> into the async schedule.

Greg, can we hold off on applying this patch to the stable tree?

It turns out that this change causes a WARN_ON to trigger in some 
circumstances, and the proposed patch to fix _that_ hasn't yet been 
submitted to the mainline because a few people have reported that it 
leaks DMA pool memory.  So far there hasn't been much progress in 
tracking this down.

Alan Stern

