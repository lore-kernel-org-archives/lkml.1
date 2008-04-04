Return-Path: <linux-kernel-owner+w=401wt.eu-S1751700AbYDDUwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbYDDUwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 16:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbYDDUwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 16:52:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48216 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbYDDUwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 16:52:01 -0400
Date: Fri, 4 Apr 2008 13:51:54 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: Re: usb unbind/bind => WARNING at fs/sysfs/dir.c [Was:
	2.6.25-rc8-mm1]
Message-ID: <20080404205154.GB14315@kroah.com>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org> <47F68CA0.7090007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F68CA0.7090007@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 10:16:32PM +0200, Jiri Slaby wrote:
> On 04/02/2008 06:32 AM, Andrew Morton wrote:
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm1/
>
> After
> $ echo -n 4-1.2 >/sys/bus/usb/drivers/usb/unbind
> $ echo -n 4-1.2 >/sys/bus/usb/drivers/usb/bind
>
> I have this in logs:
>
> sysfs: duplicate filename 'usbdev4.12_ep81' can not be created

Does this also show up in 2.6.25-rc8 without -mm?

I thought I fixed this already, I don't see what slipped into -mm that
would have caused it to come back.  Time to run some more tests...

Oh, also note that binding and unbinding the main "usb" driver is not
encouraged, or even supported.  I'm amazed it works, as this is not
something that any "real" user would do as it makes no sense at all
because we have no "alternative" drivers yet for the main USB device.

thanks,

greg k-h
