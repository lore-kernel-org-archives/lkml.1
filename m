Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbYKLJgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbYKLJgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 04:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbYKLJgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 04:36:42 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59807 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYKLJgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 04:36:41 -0500
To: tj@kernel.org
CC: hch@infradead.org, miklos@szeredi.hu, fuse-devel@lists.sourceforge.net,
       greg@kroah.com, linux-kernel@vger.kernel.org
In-reply-to: <491AA222.10209@kernel.org> (message from Tejun Heo on Wed, 12
	Nov 2008 18:30:10 +0900)
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu> <491A96AE.3080600@kernel.org> <20081112091416.GA19721@infradead.org> <491AA222.10209@kernel.org>
Message-Id: <E1L0C9B-0004Az-VX@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 12 Nov 2008 10:36:25 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008, Tejun Heo wrote:
> Christoph Hellwig wrote:
> > On Wed, Nov 12, 2008 at 05:41:18PM +0900, Tejun Heo wrote:
> >>> emulated char devices to be char devices?  What I mean is, what would
> >>> happen if instead of a char device /dev/dsp would be a regular file
> >>> mounted on /dev/dsp (which implements all the necessary interfaces:
> >>> ioctls, poll, etc)?
> >> For most it would work, I suppose, but there are all sorts of wonky
> >> users out in the wild (and quite a few that we don't have source access
> >> to) and different configurations, so I think it's better to appear as
> >> proper character device if it is a character device.  It will also help
> >> udev and other desktop thingies deal with devices implemented in userland.
> > 
> > Note that mounting a char device on /dev/dsp is exactly the same as
> > mounting a regular file on /dev/dsp - the only difference is what you
> > set i_mode to.
> 
> A difference is how the device is located.  With proper character device
> emulation, any char device node on any filesystem would work.  Not sure
> how relevant that would be tho.

Yeah, I think it would be a bit hacky to lie about being a device with
a specific major/minor number, when in fact we just set those in the
stat fields, and the real char device would return ENODEV or implement
something else.

So I'd prefer the CUSE approach if we want the file to actually look
like a device.

Miklos
