Return-Path: <linux-kernel-owner+w=401wt.eu-S1762689AbZBYLY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762689AbZBYLY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 06:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759820AbZBYLYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 06:24:48 -0500
Received: from omr7.networksolutionsemail.com ([205.178.146.57]:56098 "EHLO
	omr7.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759434AbZBYLYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 06:24:47 -0500
Message-ID: <49A52A73.2000406@nerdgrounds.com>
Date: Wed, 25 Feb 2009 03:24:35 -0800
From: Jonathan Campbell <jon@nerdgrounds.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: ATI Radeon DIRECTCOLOR -> TRUECOLOR patch
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote this patch several months ago against 2.6.27.4 out of personal 
preference (I don't think radeonfb has changed enough that it would fail 
against the current 2.6.28 all that much):

I'm pasting the URL here to avoid another round of discussion on whether 
or not my Mozilla Thunderbird client is mangling the patch:
http://nerdgrounds.com/linux-patches/linux-aty-force-truecolor.patch

I don't know about you but when I ask the framebuffer to set up 16-bit 
or 32-bit RGB modes I expect a video mode to be set up with R, G, and B 
mapped linearly so that I can display images properly, not some odd 
"directcolor" mode that seems to serve no other purpose than to avoid a 
few shifts converting the fbcon palette to an RGB triplet.

Looking at radeonfb: setting the framebuffer palette is accomplished by 
converting fbcon's RGB to 16bpp and storing that in a lookup table. 
Rendering of text for fbcon is done by referring to that lookup table, 
because radeonfb provides the 16bpp RGB values. So what exactly is 
abusing the palette/gamma registers to make a nonstandard RGB ramp 
supposed to accomplish? Is something like this that might make an 
infrequently called function like setcolor() 10 nanoseconds faster 
really worth it?

When my software running and periodically showing what dvgrab last wrote 
to disk the last thing I want clients to see when walking by is a bad 
acid trip rendition of what we're filming on camera just because 
radeonfb decided to use DIRECTCOLOR and some weird RGB ramp.

This patch changes radeonfb to remove DIRECTCOLOR behavior and act like 
a proper TRUECOLOR framebuffer. I consider it a cleaner option than 
having to use KD_GRAPHICS (XFree86), which locks out the framebuffer 
console, or CMAP ioctls (mplayer), which makes the mapping correct but 
then makes the framebuffer console's text dark purple and hard to see.

So far I've tested on three machines that I know have ATI-based video 
chipsets:
     An AMD64 dual-core 32-bit system, and two ppc-based machines, one a 
mac mini and the other a Powerbook G4.

If anyone still needs this weird DIRECTCOLOR behavior I'd be willing to 
make the patch into one that allows you to choose as an option in "make 
menuconfig"

and... a quick glance reveals that nvidiafb pulls this stunt too. anyone 
want a patch for that too?

