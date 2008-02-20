Return-Path: <linux-kernel-owner+w=401wt.eu-S933780AbYBTUat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780AbYBTUat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760622AbYBTUaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:30:22 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54586 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752297AbYBTUaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:30:18 -0500
Date: Wed, 20 Feb 2008 12:29:44 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jesse Barnes <jesse.barnes@intel.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk.
 Screen becomes green.
In-Reply-To: <200802202114.43007.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.00.0802201224380.7833@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802201118.08468.jesse.barnes@intel.com> <200802201209.03807.jesse.barnes@intel.com> <200802202114.43007.rjw@sisk.pl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 20 Feb 2008, Rafael J. Wysocki wrote:
> 
> I think we should export the target sleep state somehow.

Yeah. By *not* using "->suspend()" for freezing or hibernate.

Please, Rafael - just make the f*cking suspend-to-disk use other routines 
already. 99% of all hardware needs to do exactly *nothing* on 
suspend-to-disk, and the ones that really do need things tend to need to 
not do a whole lot.

For example, the "freeze" action for USB (which is one of the hardest 
things to suspend) should literally be something like just setting the 
controller STOP bit, and waiting for it to have stopped. The "unfreeze" 
should be to just clear the stop bit, while the "restart" should be just a 
controller reset to use the current memory image.

NONE OF THIS HAS ABSOLUTELY ANYTHING TO DO WITH SUSPEND.

It never did. I've told people so for years. Maybe actually seeing the 
problems will make people realize.

So please, we shouldn't call "->suspend[_late]" or "->resume[_early]" at 
all. Not with PMSG_FREEZE, not with PMSG_*anything*.

Can we please get this fixed some day? 

		Linus
