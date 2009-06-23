Return-Path: <linux-kernel-owner+w=401wt.eu-S1757768AbZFWQVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768AbZFWQVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZFWQUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:20:54 -0400
Received: from comar.uludag.org.tr ([193.140.100.220]:57149 "EHLO
	pardus.org.tr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756353AbZFWQUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:20:54 -0400
Message-ID: <4A4100E6.9080401@pardus.org.tr>
Date: Tue, 23 Jun 2009 19:20:54 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Dave Airlie <airlied@linux.ie>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm v2.6.31 merge (part 1)
References: <alpine.DEB.2.00.0906120720410.11737@skynet.skynet.ie> <4A3FF03A.4050401@pardus.org.tr> <alpine.DEB.2.00.0906222350570.20307@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.2.00.0906222350570.20307@skynet.skynet.ie>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> You don't have an r600, an rs690 isn't an r600 at all.
>
> Can you bisect to where the lockups start or have you always had lockups?
>
> Dave.
>   

Yes I noticed that r600 is a different one, sorry.

First of all I'm maintaining the kernel package for a linux distro[0]
which is currently at 2.6.30. It was plain vanilla in terms of drm/
until I noticed a strange problem on X. X was rendering some pixmaps (In
firefox or other apps) completely black. They were rendered correctly
just after zooming to them 4-6 times.

Then we decided to grab F11 drm patches (for nouveau support and also
radeon patches). The bad rendering problem is disappeared but I started
to have random lockups causing X server to hog the cpu.

Today I reverted the fedora patches and started using vanilla drm/
again, I didn't have a lockup during the day but the rendering problem
is back.

Then I googled a little bit and enabled the debug parameter of the drm
module after the lockup which logs the following 6 lines infinitely:

[ 4653.077514] [drm:radeon_do_wait_for_fifo] wait for fifo failed status
: 0x9003C100 0x00080100
[ 4653.077516] [drm:drm_ioctl] ret = fffffff0
[ 4653.077557] [drm:drm_ioctl] pid=1066, cmd=0x6444, nr=0x44, dev
0xe200, auth=1
[ 4653.077561] [drm:radeon_cp_idle]
[ 4653.077563] [drm:radeon_do_cp_idle]

straceing the X server says infinitely that the ioctl (0x6444) on
/dev/dri/card0 returns -EBUSY.



Thanks,
Ozan Caglayan

[0]: http://www.pardus.org.tr/eng


