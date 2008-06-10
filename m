Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbYFJQha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbYFJQha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 12:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbYFJQhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 12:37:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254AbYFJQhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 12:37:15 -0400
Date: Tue, 10 Jun 2008 09:36:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oliver Neukum <oliver@neukum.org>
cc: Pavel Machek <pavel@suse.cz>, linux-usb@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linuxfoundation.org>,
       Andrew Morton <akpm@linuxfoundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc6: CONFIG_USB_PERSIST forced on
In-Reply-To: <alpine.LFD.1.10.0806100842420.3101@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0806100933060.3101@woody.linux-foundation.org>
References: <200806091712.46869.oliver@neukum.org> <alpine.LFD.1.10.0806091435120.3218@woody.linux-foundation.org> <20080609215651.GF21429@elf.ucw.cz> <200806101055.14539.oliver@neukum.org> <alpine.LFD.1.10.0806100842420.3101@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 10 Jun 2008, Linus Torvalds wrote:
> +
> +		intf = actconfig->interface[i];
> +		driver = to_usb_driver(intf->dev.driver);
> +		if (!driver)
> +			continue;

This is wrong. It should be

	if (!intf->dev.driver)
		continue;
	driver = to_usb_driver(intf->dev.driver);

because doing the check after the "to_usb_driver()" conversion is too 
late. I copied the bug from Oliver's version.

		Linus
