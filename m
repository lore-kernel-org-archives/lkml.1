Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048Ab0ANVFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab0ANVFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 16:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190Ab0ANVFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 16:05:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754980Ab0ANVFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 16:05:47 -0500
Date: Thu, 14 Jan 2010 13:05:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Clifton <pcjc2@cam.ac.uk>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Bowler <nbowler@elliptictech.com>, airlied@linux.ie,
       intel-gfx@lists.freedesktop.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: disable LVDS downclock by
 default
In-Reply-To: <1263502711.16937.5.camel@pcjc2lap>
Message-ID: <alpine.LFD.2.00.1001141302360.13231@localhost.localdomain>
References: <alpine.LFD.2.00.1001122139411.17145@localhost.localdomain>  <84144f021001131303u56fa5470ua1c27dfef9f3de81@mail.gmail.com>  <20100113133357.67f9df6d@jbarnes-piketon> <4B4E403C.1050509@cs.helsinki.fi>  <20100113165530.2a7e7645@jbarnes-piketon>
 <4B4F6D5F.10008@cs.helsinki.fi>  <20100114193118.GA1203@emergent.ellipticsemi.com>  <84144f021001141218pa3cd71co76165532618145a8@mail.gmail.com>  <20100114202803.GA1749@emergent.ellipticsemi.com>  <20100114124802.025bbcae@jbarnes-piketon>
 <1263502711.16937.5.camel@pcjc2lap>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Jan 2010, Peter Clifton wrote:
> 
> Would it not be a better idea to turn this feature on by default, then
> use quirks to disable it on the afflicted borken machines?

No.

"Working" is good. "Broken" is bad.

We don't default to clearly unsafe models.

Maybe a few years from now, when people have learnt to do power management 
correctly and BIOSes fill in the fields right, we can reconsider. But 
right now, it's _way_ more important that things work reliably.

That said, I think a module parameter is the wrong thing. If this can be 
done dynamically with a sysfs value, do it that way instead (yes, I 
realize that module parameters end up being also visible in /sys, but I 
think Jesse's patch doesn't allow a person to set the value - and make it 
change the behavior - _while_ the display is all up and running).

		Linus
