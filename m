Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbXE0UuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbXE0UuX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 16:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbXE0UuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 16:50:12 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:45003 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbXE0UuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 16:50:10 -0400
Date: Sun, 27 May 2007 21:49:56 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
Message-ID: <20070527204955.GA22202@srcf.ucam.org>
References: <200705272229.21263.rjw@sisk.pl> <200705272231.54535.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705272231.54535.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2007 at 10:31:53PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Use a hibernation and suspend notifier to disable the firmware requesting
> mechanism before a hibernation/suspend and enable it after the operation.

This avoids the problem of .resume methods calling userspace while 
userspace is frozen and a resulting hang, but does it actually result in 
the drivers beginning to work again? If we remove process freezing in 
STR, this should just work[1] without the need to complicate things. On 
the other hand, if we don't want to support these functions in the 
suspend and resume methods we could just audit the kernel and remove 
them all.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
