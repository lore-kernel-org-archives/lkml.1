Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbXBKMOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbXBKMOX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 07:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932378AbXBKMOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 07:14:23 -0500
Received: from cavan.codon.org.uk ([217.147.92.49]:38710 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbXBKMOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 07:14:20 -0500
Date: Sun, 11 Feb 2007 12:13:40 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Willy Tarreau <w@1wt.eu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Daniel Barkalow <barkalow@iabervon.org>,
       nigel@nigel.suspend2.net, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.osdl.org>
Message-ID: <20070211121339.GB4204@srcf.ucam.org>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <200702101130.44471.rjw@sisk.pl> <Pine.LNX.4.64.0702101231281.20138@iabervon.org> <200702102050.28218.rjw@sisk.pl> <20070211065404.GA943@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070211065404.GA943@1wt.eu>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Re: NAK new drivers without proper power management?
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 11, 2007 at 07:54:04AM +0100, Willy Tarreau wrote:

> instead of modifying all drivers to explicitly state that they don't support
> it, we should start with a test of the NULL pointer for .suspend which should
> mean exactly the same without modifying the drivers. I find it obvious that
> a driver which does provide a suspend function will not support it. And if
> some drivers (eg /dev/null) can support it anyway, it's better to change
> *those* drivers to explicitly mark them as compatible.

No, that doesn't work. In the absence of suspend/resume methods, the PCI 
layer will implement basic PM itself. In some cases, this works. In 
others, it doesn't. There's no way to automatically determine which is 
which without modifying the drivers.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
