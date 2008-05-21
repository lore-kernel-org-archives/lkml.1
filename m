Return-Path: <linux-kernel-owner+w=401wt.eu-S935533AbYEUOyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935533AbYEUOyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757474AbYEUOyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 10:54:31 -0400
Received: from cluster-g.mailcontrol.com ([85.115.41.190]:53896 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbYEUOya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 10:54:30 -0400
X-Greylist: delayed 1425 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 May 2008 10:54:30 EDT
Message-ID: <48343764.7020800@csr.com>
Date: Wed, 21 May 2008 15:53:24 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       lchiquitto@novell.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: fix deadlock in HCD code
References: <Pine.LNX.4.44L0.0805211040160.2490-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0805211040160.2490-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2008 14:53:23.0905 (UTC) FILETIME=[6B204B10:01C8BB52]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Wed, 21 May 2008, David Vrabel wrote:
> 
>> Alan Stern wrote:
>>> The functions you are worried about (usb_hcd_link_urb_to_ep and 
>>> usb_hcd_unlink_urb_from_ep) are documented as requiring that interrupts 
>>> be disabled by their callers.  This patch isn't needed.
>> This requirement is the only reason the whci-hcd driver disables
>> interrupts.  Removing this requirement would reduce the time that
>> interrupts are disabled in the whci-hcd driver.
> 
> That doesn't sound like a valid approach.  If you don't disable
> interrupts then you aren't protected against an interrupt handler
> submitting an URB and accessing your data structures while whci-hcd is
> in the middle of updating them.

I can't see how urbs can be submitted to whci-hcd from an interrupt
handler (urb callbacks are always called from a workqueue thread) but
they could be submitted from a timer, so you are correct.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
