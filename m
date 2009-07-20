Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbZGTUU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbZGTUU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZGTUU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:20:26 -0400
Received: from relay.gothnet.se ([82.193.160.251]:63052 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751629AbZGTUUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:20:25 -0400
Message-ID: <4A64D16E.90903@shipmail.org>
Date: Mon, 20 Jul 2009 22:19:58 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080926)
MIME-Version: 1.0
To: Stephane Marchesin <marchesin@icps.u-strasbg.fr>
CC: Christoph Hellwig <hch@infradead.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: DRM drivers with closed source user-space: WAS [Patch 0/3] 	Resubmit
 VIA Chrome9 DRM via_chrome9 for upstream
References: <4A647358.1040009@shipmail.org>	 <20090720135844.GA16844@infradead.org> <4A648718.9000709@shipmail.org> <6a89f9d50907201213x8e16e60s38b0a4bd929ce4ca@mail.gmail.com>
In-Reply-To: <6a89f9d50907201213x8e16e60s38b0a4bd929ce4ca@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Marchesin wrote:
>> You obviously got all this completely wrong.
>>
>> I avoid writing closed source drivers whenever I can, I'm not whining and
>> I'm not trying to push any of them. The code VIA is trying to submit has not
>> been written by me nor anybody I know. All VIA code I and the companies I've
>> worked for has written is open-sourced and contributed to the Openchrome /
>> mesa / drm project.
>>
>> The point I'm trying to make is the following:
>>
>> If the common agreement of the linux community is to *NOT* allow these
>> drivers in, so be it, then be honest and go ahead and tell the driver
>> writers. Don't make them respin their development trying to fix minor flaws
>> when their driver won't get in anyway!
>>
>>     
>
>   

Stephane,
Some comments on how these things has been handled / could be handled.
> I would like to raise a couple of real-life issues I have in mind:
>
> * First example, let's say VIA gets their Chrome9 DRM merged into the
> kernel. Now let's say I reverse engineer the hardware (or use the docs
> whenever they're available) and write a 3D component that needs
> modifications to the existing DRM interface (or maybe I realize I need
> a completely new DRM). Then who gets the upper hand? Do I have to keep
> compatibility with user space binary modules that I do not care about?
>   

If there is a serious OS project, I'd start a new DRM driver.
That's sort of what may happen with openChrome vs via..

> * Second example, what is the policy if we find security holes in the
> DRM for a closed user-space afterwards? This breaks the initial
> promise of security, does that get the driver removed then? Or what if
> the promise is pending updated documentation that never arrives?
>   

I'd say the DRM driver gets disabled unless fixed. How would we handle 
that problem today with, for example, the SiS driver?

> * Third example, what if down the line we need changes in the DRM that
> require updating all DRM modules. Do we (we as in DRM developers)
> touch the DRM files for the VIA Chrome9 stuff, at the risk of breaking
> the code (since we don't test with proprietary modules)? Or do we let
> the Chrome9 files as-is, keeping the old DRM infrastructure and
> therefore add more and more DRM cruft?
>   

Again, this has been done quite commonly in the past and was easier to 
get right with the old drm.git testing ground. Same issue with 
unmaintained drivers with OS user-space. Who has actually tested all the 
drivers when making such a change? I certainly haven't. The change was 
left for testing for a while in drm.git before Dave moved it upstream.

> In my opinion, accepting GPL'ed DRM modules that support binary user
> space components is like opening pandora's box.
>
> Stephane
>   

Yeah, drivers supporting binary blobs only is out of the question as it 
seems.

Now's the tricky question how do we handle VIA's patches where they 
claim they have an open-source 2D component that exercises all of the 
DRM module for EXA render acceleration, and on top of this the 3D binary 
driver that apparently uses no additional DRM functionality compared to 
the 2D component?

In the ideal world I'd of course like to see a Chrome9 3D driver based 
of the new openChrome drm driver with a modern GPU memory manager, 
kernel modesetting and Gallium, but that's a dedicated man-year or more 
away if / when someone decides to work on it.

/Thomas



