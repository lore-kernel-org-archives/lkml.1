Return-Path: <linux-kernel-owner+w=401wt.eu-S932123AbXA0Wmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbXA0Wmd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 17:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932138AbXA0Wmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 17:42:33 -0500
Received: from cavan.codon.org.uk ([217.147.92.49]:41800 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123AbXA0Wmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 17:42:32 -0500
Date: Sat, 27 Jan 2007 22:42:06 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@osdl.org>, David Brownell <david-b@pacbell.net>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Message-ID: <20070127224206.GA26241@srcf.ucam.org>
References: <20061219185223.GA13256@srcf.ucam.org> <200701261356.42171.david-b@pacbell.net> <20070126231521.GA12370@srcf.ucam.org> <200701261642.56896.david-b@pacbell.net> <20070126165657.663358ab.akpm@osdl.org> <20070127173804.GD3942@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070127173804.GD3942@ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 27, 2007 at 05:38:04PM +0000, Pavel Machek wrote:

> Change breaking that was 'introduce suspend early to fix suspend on
> mac mini', by Linus, IIRC. So no, it is not easy to revert this one.

But it's easy to fix it. Either drivers need suspend routines that are 
called without interrupts enabled, or they don't. The current situation 
is that the interface is broken regardless of which is the case - the 
situation with the patch is that the interface only stops working for 
drivers that need the suspend routine to be called with disabled 
interrupts. 

-- 
Matthew Garrett | mjg59@srcf.ucam.org
