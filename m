Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbYBTRaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbYBTRaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbYBTRaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:30:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52600 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752973AbYBTRaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:30:05 -0500
Date: Wed, 20 Feb 2008 09:28:54 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Jesse Barnes <jesse.barnes@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk.
 Screen becomes green.
In-Reply-To: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
Message-ID: <alpine.LFD.1.00.0802200922590.7833@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Feb 2008, Jeff Chua wrote:
> 
> After inserting "return 0;" right at the top of those two functions, suspend
> (and power-off properly), and resume (without green screen) works just fine.
> 
> I would like to know what they're for.

Try suspend-and-resume without X.

Also, try it on one of the more modern laptops - even *with* X.

Basically, the kernel wants to be able to do what X does, because it means 
that when it works, it works _so_ much better than doing it in X. So 
getting it working is definitely worth it.

That said, before you do anything else, try if suspend-to-RAM works. 

That's the primary goal for this code anyway, and if it works that gives a 
good hint. Suspend-to-disk is fundamentally different, and it's entirely 
possible that for the suspend-to-disk case we should just say "screw 
trying to suspend/resume graphics", since you'll have the BIOS resuming 
text-mode anyway, and there are no performance or debugging advantages.

		Linus
