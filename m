Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0BOABv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 19:01:51 -0500
Received: from mail001.aei.ca ([206.123.6.130]:60035 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948Ab0BNX6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 18:58:31 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 1/1] Enable xy scrolling for Apple Magic Mouse
Date: Sun, 14 Feb 2010 18:58:26 -0500
User-Agent: KMail/1.13.0 (Linux/2.6.32.8-crc; KDE/4.4.0; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz> <201002141724.33223.edt@aei.ca> <87zl3bbfdo.fsf@troilus.org>
In-Reply-To: <87zl3bbfdo.fsf@troilus.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002141858.26917.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 February 2010 17:51:15 Michael Poole wrote:
> Ed Tomlinson writes:
> 
> > Hi,
> >
> > Here is a patch that enables xy scrolling with the magic mouse.  I have also
> > changed the accelleration logic to work better with xy scrolling.
> 
> Hi Ed,
> 
> Your other patch to call input_unregister_device() looks good -- thanks!

Thanks.  One question about it though.  Do we have to check if msc is null before
the unregister?

> I've never used a horizontal scroll wheel -- what are the common uses
> for it?  Why should the acceleration be separate for the two directions
> rather than using the same factor?  Why does the kernel need to emulate
> this rather than having user-space implement the emulation?

Its usefull for scrolling left and right while browsing.  If you use kde it can
be used to scroll between applications on the taskbar.   Here most applications
with a horizontial scrollbar work as expected.

I first tried with a single acceleration value for both axies.  It leads to confusing
things happening.   For example.  I quickly scroll down, then nudge the
window to the left.  This works as expect with two values.  With one the
nudge is accelerated and moves too far.

My personal goal is to have the basic, apple defined, gestures working
from kernel space.  This way the device works as expected without needing
to fiddle with X or other managers (think wayland and/or chromeOS).

> (If the answers to the last two questions justify putting this feature
> in the kernel, my only suggestions on the patch are style-related:
> scroll_accel{x,y} should probably be spelled scroll_accel_{x,y}, and
> there are missing spaces around the / operator when calculating stepx
> and stepy.)

I'll fix up the style and resubmit.

Thanks
Ed
