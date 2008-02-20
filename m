Return-Path: <linux-kernel-owner+w=401wt.eu-S934584AbYBTUq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934584AbYBTUq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757176AbYBTUqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:46:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58721 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbYBTUqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:46:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Wed, 20 Feb 2008 21:45:00 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: suspend-devel@lists.sourceforge.net, Jeff Chua <jeff.chua.linux@gmail.com>,
       Dave Airlie <airlied@linux.ie>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       Jesse Barnes <jesse.barnes@intel.com>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802202114.43007.rjw@sisk.pl> <alpine.LFD.1.00.0802201224380.7833@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802201224380.7833@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802202145.01882.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 20 of February 2008, Linus Torvalds wrote:
> 
> On Wed, 20 Feb 2008, Rafael J. Wysocki wrote:
> > 
> > I think we should export the target sleep state somehow.
> 
> Yeah. By *not* using "->suspend()" for freezing or hibernate.
> 
> Please, Rafael - just make the f*cking suspend-to-disk use other routines 
> already.

Okay, I think I'll just start sending patches for that, but rather not earlier
than in the 2.6.27 time frame.  No one else works on that and I've been busy
with other things recently.  Besides, I'm not even a full time kernel
developer ...

> 99% of all hardware needs to do exactly *nothing* on suspend-to-disk, and the
> ones that really do need things tend to need to not do a whole lot.
> 
> For example, the "freeze" action for USB (which is one of the hardest 
> things to suspend) should literally be something like just setting the 
> controller STOP bit, and waiting for it to have stopped. The "unfreeze" 
> should be to just clear the stop bit, while the "restart" should be just a 
> controller reset to use the current memory image.
> 
> NONE OF THIS HAS ABSOLUTELY ANYTHING TO DO WITH SUSPEND.
> 
> It never did. I've told people so for years. Maybe actually seeing the 
> problems will make people realize.

I think so.

> So please, we shouldn't call "->suspend[_late]" or "->resume[_early]" at 
> all. Not with PMSG_FREEZE, not with PMSG_*anything*.
> 
> Can we please get this fixed some day? 

Yes, we can (hopefully).

Thanks,
Rafael
