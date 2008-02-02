Return-Path: <linux-kernel-owner+w=401wt.eu-S1759440AbYBBLhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbYBBLhg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 06:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbYBBLhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 06:37:16 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:35241 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677AbYBBLhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 06:37:12 -0500
Date: Sat, 2 Feb 2008 12:37:10 +0100
From: Christer Weinigel <christer@weinigel.se>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080202123710.42df1aa0@weinigel.se>
In-Reply-To: <20080125180232.GA4613@kroah.com>
References: <20080125180232.GA4613@kroah.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2008 10:02:32 -0800
Greg KH <greg@kroah.com> wrote:

> FYI, this is a patch that will be sent out in the next round to Linus
> for inclusion in 2.6.25.
> 
> If anyone has any objections about it, please let me know.

Yes, I have objections and I've told you before.  

> Over two years ago, the Linux USB developers stated that they believed
> there was no way to create a USB kernel driver that was not under the
> GPL.  This patch moves the USB apis to enforce that decision.
> 
> There are no known closed source USB drivers in the wild, so this
> patch should cause no problems.

This is a bit disingenuous.   Of course there are closed source USB
drivers out there.  I've written multiple of them during my life as a
consultant.  The nature of closed source drivers is that they quite
often are written for custom hardware that isn't used by that many
people, so you have probably not seen them, but they are definitely out
there in the wild.

For some of these drivers, being in kernel space is very important
since they transfer large amounts of data with very tight latency
requirements.  It may, in theory, be possible to do the same thing in
userspace with multiple cooperative threads and libusb, but it would be
much more complex and much more error prone (it's hard to do control
loops where you need about 40 us turnaround time). 

Yes, I'd much prefer if all companies would just publish their sources
as GPL, but some companies, rightly or nor, believe that they expose too
much information about their custom hardware if they do.  And I do feel
that such a rabid GPL-stance is going to alienate those companies.  Most
of those companies also select one kernel for their custom hardware and
use that kernel for a long time, so for them this feature removal will
come as a bit of a surprise.  

  /Christer
