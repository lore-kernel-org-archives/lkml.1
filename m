Return-Path: <linux-kernel-owner+w=401wt.eu-S1765466AbYBTTZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765466AbYBTTZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 14:25:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbYBTTZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 14:25:40 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:56711 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbYBTTZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 14:25:39 -0500
Date: Wed, 20 Feb 2008 19:25:16 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>
Message-ID: <20080220192516.GA24771@srcf.ucam.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <alpine.LFD.1.00.0802200922590.7833@woody.linux-foundation.org> <b6a2187b0802200954p1cccb01aqbc48c865797f0af1@mail.gmail.com> <alpine.LFD.1.00.0802201007300.7833@woody.linux-foundation.org> <b6a2187b0802201049r25959293r1e6b83ca67f65f04@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0802201049r25959293r1e6b83ca67f65f04@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 02:49:39AM +0800, Jeff Chua wrote:

> Here's an interesting discovery. After I found that "echo reboot >
> /sys/power/disk" does reboot, I tried "echo shutdown >
> /sys/power/disk", it does shutdown properly.
> 
> With "platform" it refuses to shutdown. Both reboot and shutdown still
> end up with Mr. Green at resume.

That kind of suggests that the ACPI platform code is hitting the 
hardware directly - we've seen similar issues with PATA controllers. The 
right thing to do here is almost certainly just to avoid explicitly 
powering down hardware on hibernation.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
