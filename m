Return-Path: <linux-kernel-owner+w=401wt.eu-S1759214AbYBBDqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214AbYBBDqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 22:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbYBBDqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 22:46:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:35811 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbYBBDqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 22:46:30 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Rationalise ACPI backlight implementation
Date: Fri, 1 Feb 2008 22:46:12 -0500
User-Agent: KMail/1.9.5
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <20071226020325.GA21099@srcf.ucam.org> <20080128012549.GA24166@srcf.ucam.org> <20080127211013.1ddaa6a1.akpm@linux-foundation.org>
In-Reply-To: <20080127211013.1ddaa6a1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802012246.13162.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008 00:10, Andrew Morton wrote:
> On Mon, 28 Jan 2008 01:25:50 +0000 Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> 
> > On Sat, Jan 26, 2008 at 10:00:45PM -0800, Andrew Morton wrote:
> > > - Create a new /sys node with a new name which has the new semantics.
> > 
> > The semantics are the same as they always have been - values between 0 
> > and max_brightness are valid values. If you've made assumptions about 
> > what max_brightness is, then that's a bug in the userspace application 
> > rather than a change in the semantics of the interface.
> > 
> 
> WTH?  My (utterly comedic chase-crap-around-the-tree) brightness script
> was:
> 
> (
> 0 sh -c "echo $1 > /proc/acpi/sony/brightness"
> 0 sh -c "echo $1 > /proc/acpi/sony/brightness_default"
> 0 sh -c "echo $1 > /sys/class/backlight/sony/brightness"
> 0 sh -c "echo $1 > /sys/class/backlight/thinkpad_screen/brightness"
> ) 2>/dev/null
> 
> And yes, I had an rc.local command which assumed that 7 (later 8) is max
> brightness.
> 
> You cannot seriously tell me that if we are to change this range from 0-8
> up to 0-100 then this is not a backwards-incompatible change in
> semantics.
> 
> My /sys/class/backlight/ directory is presently empty.  Rather than trying
> to find out why, I think I'll just collapse in laughter.
> 
> Guys, sort it out, please.

I think that Matthew got it right.

The generic API is unchanged, brightness goes from 0 to max_brighness.

What he did was repair systems that use the acpi video driver
(which none of akpm's examples above do) such that the generic
API works for that case the same as it does with all other video drivers.

Andrew,
You might check if CONFIG_ACPI_VIDEO=m is set and you can load the "video" module.
While the sony may be non-standard and not load, your thinkpad may work.

thanks,
-Len
