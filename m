Return-Path: <linux-kernel-owner+w=401wt.eu-S1760773AbYBTRwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773AbYBTRwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760004AbYBTRwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:52:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58585 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758006AbYBTRw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:52:29 -0500
Date: Wed, 20 Feb 2008 09:52:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Jesse Barnes <jesse.barnes@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk.
 Screen becomes green.
In-Reply-To: <b6a2187b0802200937q3ff8f470k235b5d1e00eab59e@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0802200945591.7833@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>  <alpine.LFD.1.00.0802200922590.7833@woody.linux-foundation.org> <b6a2187b0802200937q3ff8f470k235b5d1e00eab59e@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Feb 2008, Jeff Chua wrote:
> 
> Works without those two functions.

Ahh. You're using the BIOS to re-initialize your video, aren't you? 

If STR works without X, then you have something else resuming graphics, 
and that may be what then interacts badly with the fact that the kernel 
also does so. 

> Ok, what's next?

Let's try to narrow it down to what the interaction is. Are you using 
something like acpi_sleep=s3_bios or similar? That's what the kernel 
support is supposed to make unnecessary in the long run, along with all 
the video mode flickering (ie we should be able to resume to the video 
mode we want, not flicker through unnecessary modes).

			Linus
