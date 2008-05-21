Return-Path: <linux-kernel-owner+w=401wt.eu-S935020AbYEUN2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935020AbYEUN2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 09:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764518AbYEUN1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:27:52 -0400
Received: from styx.suse.cz ([82.119.242.94]:41632 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763188AbYEUN1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:27:51 -0400
Date: Wed, 21 May 2008 15:27:50 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Oliver Neukum <oliver@neukum.org>
cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, lchiquitto@novell.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: fix deadlock in HCD code
In-Reply-To: <200805211521.01435.oliver@neukum.org>
Message-ID: <Pine.LNX.4.64.0805211524130.6718@jikos.suse.cz>
References: <Pine.LNX.4.64.0805211405520.6718@jikos.suse.cz>
 <200805211521.01435.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Oliver Neukum wrote:

> > hcd_urb_list_lock is used for synchronization between IRQ and non-IRQ 
> > contexts, so the non-IRQ context has to disable IRQs in order to prevent 
> > deadlocking with IRQ context.
> Which non-irq context is that?

One example -- assume usb_submit_urb() called from non-IRQ context. Then

usb_hcd_submit_urb() -> rh_urb_enqueue() -> rh_queue_status() -> 
usb_hcd_link_urb_to_ep().

-- 
Jiri Kosina
SUSE Labs
