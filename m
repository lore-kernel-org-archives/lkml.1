Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbYKUNGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbYKUNGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 08:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbYKUNGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 08:06:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:58919 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbYKUNGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 08:06:42 -0500
Message-ID: <4926B251.6010109@kernel.org>
Date: Fri, 21 Nov 2008 22:06:25 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations, take
 #2
References: <1227190298-4585-1-git-send-email-tj@kernel.org> <E1L3G3Q-0006SJ-Uc@pomaz-ex.szeredi.hu> <49268876.7080303@kernel.org> <E1L3Tp0-0007dc-3S@pomaz-ex.szeredi.hu>
In-Reply-To: <E1L3Tp0-0007dc-3S@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 21 Nov 2008 13:06:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> On Fri, 21 Nov 2008, Tejun Heo wrote:
>>> I removed ->unrestricted_ioctl() and associated code because it really
>>> doesn't make any sense: the high level lib won't be used for CUSE
>>> stuff, otherwise unrestrited ioctls are not allowed (and the interface
>>> is rather horrible anyway).
>> Well, CUSE highlevel interface piggy backs on FUSE so it requires
>> unrestricted_ioctl() there for it and ossp does use it.
> 
> I thought it uses the lowlevel interface.  Why doesn't it do that?

Well, because it's simpler that way and people would be more used to it?
 It's just easier when you implement a method which returns something
and looks similar to the respective file operation.

> For CUSE there's really no point in going through high level
> interface, since there's just one file involved, so the path name
> generation (the main feature of the highlevel lib) doesn't make any
> sense.

Well, the choice was mostly for convenience as there also are a few
places where high level interface wraps things better a bit.  Converting
wouldn't be difficult.  Do you think it's important?  I think keeping
things as parallel to FUSE as possible is more important.

Thanks.

-- 
tejun
