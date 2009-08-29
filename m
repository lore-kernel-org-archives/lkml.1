Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbZH2Vl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbZH2Vl2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 17:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbZH2Vl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 17:41:27 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:52706 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752569AbZH2Vl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 17:41:27 -0400
Subject: Re: memleaks, acpi + ext4 + tty
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <43e72e890908280952j410293fbm47b4b9d566e26c14@mail.gmail.com>
References: <43e72e890908272225w79ec5bf6kc7ef1160e5a088ae@mail.gmail.com>
	 <tnxtyzr7vcl.fsf@pc1117.cambridge.arm.com>
	 <43e72e890908280952j410293fbm47b4b9d566e26c14@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Sat, 29 Aug 2009 22:41:21 +0100
Message-Id: <1251582081.6412.6.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Aug 2009 21:41:22.0307 (UTC) FILETIME=[7379C530:01CA28F1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-28 at 09:52 -0700, Luis R. Rodriguez wrote:
> On Fri, Aug 28, 2009 at 9:32 AM, Catalin
> Marinas<catalin.marinas@arm.com> wrote:
> > "Luis R. Rodriguez" <mcgrof@gmail.com> wrote:
> >> unreferenced object 0xffff880006ce0400 (size 1024):
> >>   comm "mplayer", pid 5293, jiffies 4295366945
> >>   backtrace:
> >>     [<ffffffff81121fad>] create_object+0x13d/0x2d0
> >>     [<ffffffff81122265>] kmemleak_alloc+0x25/0x60
> >>     [<ffffffff81119f3b>] __kmalloc+0x16b/0x250
> >>     [<ffffffff813021b0>] tty_buffer_request_room+0xc0/0x190
> >>     [<ffffffff8130244c>] tty_insert_flip_string+0x3c/0xb0
> >>     [<ffffffff81302f49>] pty_write+0x49/0x70
> >>     [<ffffffff812fd3b0>] n_tty_write+0x1c0/0x450
> >>     [<ffffffff812f9ec1>] tty_write+0x1a1/0x290
> >>     [<ffffffff81124518>] vfs_write+0xb8/0x1a0
> >>     [<ffffffff81124fcc>] sys_write+0x4c/0x80
> >>     [<ffffffff81011f02>] system_call_fastpath+0x16/0x1b
> >>     [<ffffffffffffffff>] 0xffffffffffffffff
> >
> > It could be a real leak as you get several of these. I cc'ed Greg KH
> > for any suggestions he may have. It looks like it only happens when
> > running mplayer.
> 
> It took me a while to figure out how to reproduce, and it really
> didn't make sense to see this playing video, why would playing video
> affect tty?

Maybe mplayer is just opening the tty for some user interaction.

I managed to the same report just using "top" but it is not persistent,
so it may be a false positive.

-- 
Catalin

