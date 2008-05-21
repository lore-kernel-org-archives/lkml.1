Return-Path: <linux-kernel-owner+w=401wt.eu-S936601AbYEUUDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936601AbYEUUDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757257AbYEUUDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:03:19 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:55796 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbYEUUDS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:03:18 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] USB: fix deadlock in HCD code
Date: Wed, 21 May 2008 22:03:13 +0200
User-Agent: KMail/1.9.9
Cc: Jiri Kosina <jkosina@suse.cz>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, lchiquitto@novell.com,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0805211042070.2490-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0805211042070.2490-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805212203.14187.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 21 Mai 2008 16:46:45 schrieb Alan Stern:
> One possibility is that in an earlier call to finish_urb,
> usb_hcd_giveback_urb was called with interrupts disabled and returned 
> with interrupts enabled.  In other words, some driver's callback 
> routine may have enabled interrupts incorrectly.

Are we sure the interrupt line is not shared with another driver that calls
spin_unlock_irq() in its interrupt handler?

	Regards
		Oliver

