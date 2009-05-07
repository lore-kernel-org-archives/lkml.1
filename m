Return-Path: <linux-kernel-owner+w=401wt.eu-S1760039AbZEGQcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039AbZEGQcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 12:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbZEGQcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 12:32:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39866 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753409AbZEGQcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 12:32:08 -0400
Date: Thu, 7 May 2009 12:32:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jason Wessel <jason.wessel@windriver.com>, <greg@kroah.com>,
       <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to force
 writes
In-Reply-To: <200905071701.51195.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0905071229270.3151-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Oliver Neukum wrote:

> > How about setting the upper limit to URBs in flight based on the baud
> > rate?  Faster transfers deserve more URBs, right?  Assuming some
> > minimum number of bytes per URB (4? 8?), there should be enough URBs to
> > fill a pipeline whose length is around 5 ms or so (interrupt latency).
> 
> Hm, you say many URBs can complete before an interrupt handler
> can react?

How long can interrupts remain disabled?  On a non-RT system, it might 
be several milliseconds.

In any case, a full-speed host controller won't issue IRQs more often 
than once per ms.  Quite a few URBs can complete in that time.

Alan Stern

