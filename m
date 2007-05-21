Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbXEUJ2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbXEUJ2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 05:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbXEUJ1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 05:27:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:25873 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbXEUJ1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 05:27:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=t4linWuYAUM5QJ5cO9ydXPo1RDXpbzIygtUxy84U57p88H6G97IIfwaxCNdADjqDwAWC2v6ZmdjGDYiIpbkvzSlb1udIth4agVOZ/g306xBiPtYPOsjC+fPU9Ba4K5Qfne9F1lY9FTWZIqN6TTqv+Eg+c5/P8+YmlJqEV3cRyZc=
Message-ID: <21d7e9970705210227x27234e2dme4e731a53f977082@mail.gmail.com>
Date: Mon, 21 May 2007 19:27:49 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Helge Hafting" <helge.hafting@aitel.hist.no>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jon Smirl" <jonsmirl@verizon.net>,
       "Jesse Barnes" <jesse.barnes@intel.com>, jonsmirl@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <465161B0.9050800@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <pan.2007.05.20.17.41.22@gmail.com>
	 <21d7e9970705210127o2360cd63mb8a41fdab9f211f9@mail.gmail.com>
	 <465161B0.9050800@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Helge Hafting <helge.hafting@aitel.hist.no> wrote:
> Dave Airlie wrote:
> > On 5/21/07, Jon Smirl <jonsmirl@verizon.net> wrote:
> >> On Thu, 17 May 2007 14:23:45 -0700, Jesse Barnes wrote:
> >>
> >> > In collaboration with the FB guys, we've been working on enhancing the
> >> > kernel's graphics subsystem in an attempt to bring some sanity to the
> >> > Linux graphics world and avoid the situation we have now where several
> >> > kernel and userspace drivers compete for control of graphics devices.
> >>
> >> How is supporting different users logged into each head going to work?
> >> The original model for this was to give each head its own fbdev device.
> >> It is important that each user be able to set their own mode without
> >> being
> >> root.
> >
> > TThe problem with that is the concept of heads is flawed... there is
> > in reality no such
> > thing, you have crtcs and outputs, no heads. So any attempt to enforce
> > the head concept involves putting policy into the kernel, as if I have
> > 3 outputs but 2 crtcs how do I decide the mappings without the admin
> > telling the kernel,
> >
> Solution:
> One device per crtc. You can then have two users, running consoles
> or xservers on their crtcs, without having to involve root.

Thats pretty much what the code does, but you still are putting a
certain amount of policy in the kernel...
>
> The crtc->output mapping must still be done by root of course.
>
> This solution allow the useful case where the computer boots, the boot
> scripts
> set up a crtc->output mapping. Then users log in through the
> various consoles (using getty or xdm or similiar) using their grahphical
> devices in whatever way they want.  A true multiseat setup.
>
>
> And if one user needs to use all the screens for multi-display work?
> Let root change the mappings, possibly through some sudo setup.
>

Multiseat isn't what i would want as a default on any machine, so the
default setup should be to clone the single user onto as many screens
as possible, as this is what users expect.. the system startup scripts
can then reconfigure it, to suit the admins needs..

Dave.
>
