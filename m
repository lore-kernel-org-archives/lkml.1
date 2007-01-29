Return-Path: <linux-kernel-owner+w=401wt.eu-S1750896AbXA2KlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750896AbXA2KlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 05:41:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932758AbXA2KlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 05:41:13 -0500
Received: from twin.jikos.cz ([213.151.79.26]:48118 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbXA2KlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 05:41:12 -0500
Date: Mon, 29 Jan 2007 11:40:57 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Soeren Sonnenburg <kernel@nn7.de>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>
Subject: Re: 2.6.20-rc6 pb_fnmode regression
In-Reply-To: <1170066737.13904.12.camel@localhost>
Message-ID: <Pine.LNX.4.64.0701291138260.9448@twin.jikos.cz>
References: <1169904555.2462.10.camel@localhost>  <Pine.LNX.4.64.0701291049190.9448@twin.jikos.cz>
 <1170066737.13904.12.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007, Soeren Sonnenburg wrote:

> Well I need in-kernel usbhid and the way this was implemented in 2.6.19 
> (and before) one could change pb_fnmode on-the-fly. This is mentioned in 
> all the power/i/mac/book tutorials and everyone is used to switching 
> modes this way. I can happily patch the kernel to use the pb_fnmode but 
> nonetheless this is a regression to pre 2.6.20* and will confuse others 
> too...

Ah, now I see. The problem is that in pre-2.6.20-rc1 the pb_fnmode was 
setting global variable, but after the HID layer rework, this is a per-hid 
variable, which is of course not updated when write to sysfs triggers.

I will try to fix this before I send 2.6.20-rc6 updates to Linus, thanks 
for pointing this out.

-- 
Jiri Kosina
