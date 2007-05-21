Return-Path: <linux-kernel-owner+w=401wt.eu-S1757960AbXEUQH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbXEUQH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755315AbXEUQHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:07:50 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:14037 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522AbXEUQHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:07:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p+H69jsYrJQTHBQqUuxyNEUPSxp7D74gKn6LRFFtk6pcfdUqfP9TQhwPX9POG3/DxIoYLeBnmf3dWHRpmV371MqWipT1p86YoRcMw19l9qLgJJb9b1sVF7X6I9Mghp3ZSXsd90GyAPB0/HGVUZWtSHMC04JNcgmXvVI+hMuztEQ=
Message-ID: <9e4733910705210907g70142adfhcaf01bd6791f113d@mail.gmail.com>
Date: Mon, 21 May 2007 12:07:48 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Helge Hafting" <helge.hafting@aitel.hist.no>,
       "Dave Airlie" <airlied@gmail.com>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200705210857.44911.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <21d7e9970705210227x27234e2dme4e731a53f977082@mail.gmail.com>
	 <46516A14.2000102@aitel.hist.no>
	 <200705210857.44911.jbarnes@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Monday, May 21, 2007, Helge Hafting wrote:
> > >> > TThe problem with that is the concept of heads is flawed... there
> > >> > is in reality no such
> > >> > thing, you have crtcs and outputs, no heads. So any attempt to
> > >> > enforce the head concept involves putting policy into the kernel,
> > >> > as if I have 3 outputs but 2 crtcs how do I decide the mappings
> > >> > without the admin telling the kernel,
> > >>
> > >> Solution:
> > >> One device per crtc. You can then have two users, running consoles
> > >> or xservers on their crtcs, without having to involve root.
> > >
> > > Thats pretty much what the code does, but you still are putting a
> > > certain amount of policy in the kernel...
> >
> > What policy would that be?
> > The mapping is set by root from userspace, not by the kernel.
> > The same for ownership to crtc devices. The kernel may have to
> > provide some default so "init=/bin/sh" will work, that's all.
>
> The policy of mapping outputs to CRTCs.  Like Dave said, you may have
> several outputs but only one or two CRTCs, with limitations on how they
> can be routed.  So doing "one device per CRTC" isn't quite enough, you
> also have to choose an initial output setup.  But like you say this could
> be changed at boot time.
>
> > Sure.  Not multiseat by default, as the kernel can't know which output
> > goes with which keyboard. All I want it a system that allows
> > multiseat for those that care to set it up.
>
> Sure, and like I mentioned to Jon in another mail, a decent multiseat setup
> is possible with these interfaces, albeit with a userlevel graphics daemon
> to arbitrate what the CRTC->output mappings are and to coordinate access
> to the hw if needed.
>
> So really, I think the interfaces posted here will do what you want.  Maybe
> you can take a closer look and make sure?

What about modifying the existing fbdev API? You could start with one
fbdev device per CRTC and then add a new IOCTL to control the output
device. I haven't seen anything yet that justifies abandoning the
existing fbdev API.

Note that you could add fbdev API support to the radeon DRM driver.
Preserving the fbdev API doesn't mean that you have to preserve the
old driver code.

-- 
Jon Smirl
jonsmirl@gmail.com
