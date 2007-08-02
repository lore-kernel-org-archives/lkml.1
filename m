Return-Path: <linux-kernel-owner+w=401wt.eu-S1757191AbXHBOdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbXHBOdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 10:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbXHBOcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 10:32:54 -0400
Received: from twin.jikos.cz ([213.151.79.26]:51958 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbXHBOcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 10:32:53 -0400
Date: Thu, 2 Aug 2007 16:26:45 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] 2.6.23-rc1-mm2
In-Reply-To: <Pine.LNX.4.44L0.0708021019400.3611-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.64.0708021622090.26230@twin.jikos.cz>
References: <Pine.LNX.4.44L0.0708021019400.3611-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007, Alan Stern wrote:

> > > > > uhci_hcd 0000:00:0c.0: dma_pool_free buffer-32, 6b6b6b6b/6b6b6b6b (bad dma)
> > > I guess the patch below (which I have just added to my tree) fixes that, 
> > > right? Thanks.
> > Yes - that's correct. This patch fixes the bug. Thanks.
> Does it also fix the "dma_pool_free" error?

I believe it should -- caused by calling usb_buffer_free() with bogus 
dma_addr_t, as corresponding usbhid_device has been already kfree()d.

-- 
Jiri Kosina
