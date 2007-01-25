Return-Path: <linux-kernel-owner+w=401wt.eu-S965573AbXAYSv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965573AbXAYSv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 13:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965572AbXAYSv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 13:51:58 -0500
Received: from mail.suse.de ([195.135.220.2]:40969 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965573AbXAYSvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 13:51:55 -0500
Date: Thu, 25 Jan 2007 10:51:01 -0800
From: Greg KH <greg@kroah.com>
To: Rainer Weikusat <rainer.weikusat@sncag.com>
Cc: torvalds@linux-foundation.org, bunk@stusta.de,
       linux-kernel@vger.kernel.org
Subject: Re: unfixed regression in 2.6.20-rc6 (since 2.6.19)
Message-ID: <20070125185101.GA26279@kroah.com>
References: <877ivb2kvc.fsf@semtex.sncag.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877ivb2kvc.fsf@semtex.sncag.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 04:20:55PM +0100, Rainer Weikusat wrote:
> 2.6.19 introduced changes to the UHCI handling of interrupt URBs that
> caused at least some keyspan USB-to-serial converters to fail, because
> the driver code incorrectly assumes that all URBs of the device are
> bulk URBs, while some of them (in the default configuration) are
> actually interrupt URBs. This has been reported via kernel bugzilla as
> bug 7544 on 2006/11/17:
> 
> 	http://bugzilla.kernel.org/show_bug.cgi?id=7544
> 
> I happen to use such a device, but I didn't have the time to deal with
> this issue until end of december. A fix for this regression has been
> available at least since 2006/12/26. The patch available via bugzilla
> has been reworked by me because of comments from Mr. Kroah-Hartmann,
> 
> 	http://marc.theaimsgroup.com/?l=linux-kernel&m=116783507105717&w=2
> 
> It has been part of the -mm tree until about three days ago and was
> then dropped by Andrew Morton because Mr Kroah-Hartmann added a
> structurally identical and functionally neutral (or slightly worse)
> rewritten-by-him version of it to something called 'gregkh-2.6',
> presumably, judging from the age of other patches in this particular
> tree (back until 2006/09/19), to never see the light of the day again.

Huh?  That's my staging tree for what goes to Linus and Andrew.

Yes, some patches in there are very old, and are not supposed to ever go
to mainline, but that is the minority.

I copied you when this patch was added to my tree, as I had reworked it
to be a bit more acceptable (no pointer arithmatic, proper coding style,
use the newer macros for endpoint detection, etc.), so you were aware
when this change was added.  If this patch does not work, please let me
know, and I will be glad to work to fix it.

thanks,

greg k-h
