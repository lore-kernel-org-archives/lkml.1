Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675AbYLJTP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbYLJTP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 14:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbYLJTPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 14:15:16 -0500
Received: from gw.goop.org ([64.81.55.164]:34851 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbYLJTPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 14:15:15 -0500
Message-ID: <49401540.8030609@goop.org>
Date: Wed, 10 Dec 2008 11:15:12 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>
Subject: Re: Oops in UHCI when encountering "host controller process error"
References: <Pine.LNX.4.44L0.0812101006540.2175-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0812101006540.2175-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> The entry point is uhci_urb_enqueue().  You can do whatever you like 
> there, but bear in mind that it may be called in interrupt context.  
> uhci_sprint_schedule() should be fine.
>
> However I don't really see the point.  If the DMA pool allocations are 
> so badly messed up that the initial setup is wrong, why bother to 
> search any further?

I was trying to use it as a way of gauging where the damage was coming from.

But its moot now; Ian Campbell tracked it down to a missing TLB flush 
which explained all the weird non-deterministic symptoms we were 
seeing.  It all looks pretty good now.

    J

