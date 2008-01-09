Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbYAIEv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbYAIEv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 23:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbYAIEvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 23:51:48 -0500
Received: from gir.skynet.ie ([193.1.99.77]:33591 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbYAIEvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 23:51:47 -0500
Date: Wed, 9 Jan 2008 04:51:45 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Andi Kleen <andi@firstfloor.org>
cc: Kevin Winchester <kjwinchester@gmail.com>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 1/1] Convert drivers in drivers/char/drm to use
 .unlocked_ioctl
In-Reply-To: <20080109041135.GA7130@one.firstfloor.org>
Message-ID: <alpine.DEB.0.82.0801090448520.9570@skynet.skynet.ie>
References: <20080109005416.039551758@gmail.com> <20080109005443.227306069@gmail.com>
 <alpine.DEB.0.82.0801090336000.9570@skynet.skynet.ie>
 <20080109041135.GA7130@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Wed, Jan 09, 2008 at 03:37:50AM +0000, Dave Airlie wrote:
> > 
> > > The drm drivers in this patch all used drm_ioctl to perform their
> > > ioctl calls.  The common function is converted to use lock_kernel()
> > > and unlock_kernel() and the drivers are converted to use .unlocked_ioctl
> > > 
> > 
> > NAK
> 
> Did you actually read Kevin's patch? 


Kevin's patch adds the lock/unlock to drm_ioctl which is exactly what I 
don't want, I want to have drm_ioctl become drm_unlocked_ioctl, and 
drm_ioctl to wrap it with the lock/unlocks, then the drivers can all
use unlocked_ioctl like Kevins patch pointing to drm_ioctl, and can 
migrate over to drm_unlocked_ioctl post lock auditing, the new latest i915 
driver seems to be fine with unlocked ioctls so far..

Yes I can use Kevin's patch as a base most likely, but it doesn't do what 
I want yet, and I've already started to do it properly in the drm upstream 
trees....

Dave.
