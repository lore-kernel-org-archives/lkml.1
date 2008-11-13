Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbYKMMOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbYKMMOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 07:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbYKMMOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 07:14:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:48824 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbYKMMOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 07:14:34 -0500
Message-ID: <491C1A1D.4090908@kernel.org>
Date: Thu, 13 Nov 2008 21:14:21 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu> <491A96AE.3080600@kernel.org> <491BC3E3.7040903@kernel.org> <E1L0aEn-0006dh-BK@pomaz-ex.szeredi.hu> <491C0FA0.5070500@kernel.org> <E1L0aox-0006iY-2L@pomaz-ex.szeredi.hu>
In-Reply-To: <E1L0aox-0006iY-2L@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 13 Nov 2008 12:14:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> On Thu, 13 Nov 2008, Tejun Heo wrote:
>> I don't really mind people doing strange things in userland as long as
>> it's safe but you're the maintainer.  It's a bit strange to export the
>> feature only for CUSE, so I'm a little bit hesitant.
> 
> You are starting from the fact that ioctl is a good API.  It's not,
> it's a bad API, so I don't want to encourage the use of it.

Heh heh, I don't think ioctl is a good API but it's fun to watch people
screw up themselves.  :-P

>>  I wanna make it
>> useful for both.  So, at the kernel level, only well formed for FUSE and
>> everything goes for CUSE.  Does that sound good enough?
> 
> With additional restrictions for ptraceability yes.  But if you just
> restrict it to CUSE at first, that's fine by me as well :)

It actually wasn't a big change.  Now only well formed ioctls are
allowed for FUSE server and kernel will dispatch the correct amount of
input data and feed back the correct amount of output data without any
retry.  With proper massaging of FUSE ioctl API, ioctl, at least for
FUSE, will be very straight forward.

Thanks.

-- 
tejun
