Return-Path: <linux-kernel-owner+w=401wt.eu-S1757388AbZEGOgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbZEGOgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbZEGOf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:35:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56907 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753731AbZEGOf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:35:57 -0400
Date: Thu, 7 May 2009 10:35:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jason Wessel <jason.wessel@windriver.com>, <greg@kroah.com>,
       <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to force
 writes
In-Reply-To: <200905070024.16982.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0905071029200.3087-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Oliver Neukum wrote:

> On a fundamental note, thinking about this in terms of numbers of URBs
> is strictly speaking wrong. We need to limit data in flight. For efficiency
> we should make buffers as large as possible within that limit.

But for latency you should submit URBs as soone as possible within that 
limit, which generally means small buffers.

How about setting the upper limit to URBs in flight based on the baud
rate?  Faster transfers deserve more URBs, right?  Assuming some
minimum number of bytes per URB (4? 8?), there should be enough URBs to
fill a pipeline whose length is around 5 ms or so (interrupt latency).

Alan Stern

