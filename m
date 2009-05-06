Return-Path: <linux-kernel-owner+w=401wt.eu-S1761576AbZEFUvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761576AbZEFUvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759383AbZEFUvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:51:40 -0400
Received: from mail.windriver.com ([147.11.1.11]:61026 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbZEFUvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:51:39 -0400
Message-ID: <4A01F842.9080300@windriver.com>
Date: Wed, 06 May 2009 15:51:14 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to forcewrites
References: <Pine.LNX.4.44L0.0905061447500.4430-100000@iolanthe.rowland.org> <200905062201.42965.oliver@neukum.org> <4A01F201.3020406@windriver.com> <20090506202821.GA12449@kroah.com>
In-Reply-To: <20090506202821.GA12449@kroah.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 May 2009 20:51:14.0142 (UTC) FILETIME=[64F6F7E0:01C9CE8C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> Doing enough printk's such as in register_console() will cause loss
>> because you run out of URBs unless you can force them to complete.
>>     
>
> Why not just make the upper bound of urbs very large?  We used to have
> an unlimited number of in-flight urbs for some drivers until it was
> pointed out that a simple:
> 	cat /dev/null > /dev/ttyUSB0
> would cause a DoS :)
>
> What happens if your upper bound is 400?  4000?  Will that work
> properly?
>   
Sure, if you have enough of a urb available, ultimately you get all the
printk's.

If I want to printk from the nmi_watchdog out to this device, am I going
to get anything if the write is not synchronous, because in theory the
hcd device is never going to get accessed again?

Ideally I want to make sure that somehow I get my debug output out to
the console, even if it means we do some polling after the oops state is
set.

Jason.
