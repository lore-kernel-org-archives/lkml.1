Return-Path: <linux-kernel-owner+w=401wt.eu-S1760168AbXE0WE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbXE0WE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 18:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757622AbXE0WEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 18:04:22 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:43494 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757456AbXE0WEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 18:04:21 -0400
Date: Sun, 27 May 2007 23:04:12 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
Message-ID: <20070527220412.GC22687@srcf.ucam.org>
References: <200705272229.21263.rjw@sisk.pl> <200705272231.54535.rjw@sisk.pl> <20070527204955.GA22202@srcf.ucam.org> <3ae72650705271449q37f523c3t5980541122ab871@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ae72650705271449q37f523c3t5980541122ab871@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2007 at 11:49:30PM +0200, Kay Sievers wrote:

> What exactly is the problem we see here? The timeout of the firmware loader?
> What goes wrong with frozen userspace, usually there is only a netlink
> message sent from the kernel, which should be received and handled
> just fine when userspace is running again.

Driver calls request_firmware in the resume method. The userspace helper 
can't be run because it's been frozen, so the firmware never gets loaded 
and the call times out. The driver then fails to resume. While all this 
is happening, the rest of the kernel is blocking on that resume method. 
The firmware can be loaded once userspace has been started again, but by 
that time the driver has given up.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
