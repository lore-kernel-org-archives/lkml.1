Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbXEUJTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbXEUJTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 05:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbXEUJSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 05:18:52 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:51726 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754512AbXEUJSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 05:18:52 -0400
Message-ID: <465161B0.9050800@aitel.hist.no>
Date: Mon, 21 May 2007 11:09:04 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Jon Smirl <jonsmirl@verizon.net>, Jesse Barnes <jesse.barnes@intel.com>,
       jonsmirl@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
References: <200705171423.46748.jesse.barnes@intel.com>	 <pan.2007.05.20.17.41.22@gmail.com> <21d7e9970705210127o2360cd63mb8a41fdab9f211f9@mail.gmail.com>
In-Reply-To: <21d7e9970705210127o2360cd63mb8a41fdab9f211f9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> On 5/21/07, Jon Smirl <jonsmirl@verizon.net> wrote:
>> On Thu, 17 May 2007 14:23:45 -0700, Jesse Barnes wrote:
>>
>> > In collaboration with the FB guys, we've been working on enhancing the
>> > kernel's graphics subsystem in an attempt to bring some sanity to the
>> > Linux graphics world and avoid the situation we have now where several
>> > kernel and userspace drivers compete for control of graphics devices.
>>
>> How is supporting different users logged into each head going to work?
>> The original model for this was to give each head its own fbdev device.
>> It is important that each user be able to set their own mode without 
>> being
>> root.
>
> TThe problem with that is the concept of heads is flawed... there is
> in reality no such
> thing, you have crtcs and outputs, no heads. So any attempt to enforce
> the head concept involves putting policy into the kernel, as if I have
> 3 outputs but 2 crtcs how do I decide the mappings without the admin
> telling the kernel,
>
Solution:
One device per crtc. You can then have two users, running consoles
or xservers on their crtcs, without having to involve root.

The crtc->output mapping must still be done by root of course.

This solution allow the useful case where the computer boots, the boot 
scripts
set up a crtc->output mapping. Then users log in through the
various consoles (using getty or xdm or similiar) using their grahphical
devices in whatever way they want.  A true multiseat setup.


And if one user needs to use all the screens for multi-display work?
Let root change the mappings, possibly through some sudo setup.

Helge Hafting
