Return-Path: <linux-kernel-owner+w=401wt.eu-S1758777AbYHEErc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbYHEErc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 00:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbYHEErP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 00:47:15 -0400
Received: from jenny.ondioline.org ([66.220.1.122]:42922 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbYHEErO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 00:47:14 -0400
From: Paul Collins <paul@burly.ondioline.org>
To: michael@ellerman.id.au
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
       linuxppc-dev@ozlabs.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: nfsd, v4: oops in find_acceptable_alias, ppc32 Linux, post-2.6.27-rc1
References: <20080802184554.GB715@fieldses.org>
	<87abfvm4cc.fsf@burly.wgtn.ondioline.org>
	<877iayy4qc.fsf@burly.wgtn.ondioline.org>
	<18581.40960.737792.454035@notabene.brown>
	<87r696l1yo.fsf@burly.wgtn.ondioline.org>
	<18582.32935.501672.689845@notabene.brown>
	<87fxpll5zq.fsf@burly.wgtn.ondioline.org>
	<87y73dcd60.fsf@burly.wgtn.ondioline.org>
	<1217860597.12535.2.camel@localhost>
	<87hca05ws4.fsf@burly.wgtn.ondioline.org>
	<20080804205908.GA29890@fieldses.org>
	<1217895418.7951.7.camel@localhost>
	<8763qg5don.fsf@burly.wgtn.ondioline.org>
	<1217910862.7951.22.camel@localhost>
Date: Tue, 05 Aug 2008 16:47:12 +1200
In-Reply-To: <1217910862.7951.22.camel@localhost> (Michael Ellerman's message
	of "Tue, 05 Aug 2008 04:34:22 +0000")
Message-ID: <871w145ar3.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> On Tue, 2008-08-05 at 15:43 +1200, Paul Collins wrote:
>> Michael Ellerman <michael@ellerman.id.au> writes:
>> I think may be able to rule NFS out now.  I just got this Oops when Xorg
>> started on boot.
>
> Cool, that looks fairly convincing.
>
>> In case anyone wants to disassemble it, I've uploaded the kernel to
>> http://ondioline.org/~paul/vmlinux-2.6.27-rc1-00158-g643fbd8 and the
>> config to http://ondioline.org/~paul/config-2.6.27-rc1-00158-g643fbd8
>> 
>> I've rebuilt a whole bunch of times in the course of this little
>> project, but the all four Oopses in this message are from the very
>> vmlinux linked above.
>> 
>> I have a couple of patches applied locally (a console font and a
>> Bluetooth HID quirk), so this is really Linus revision
>> 94ad374a0751f40d25e22e036c37f7263569d24c.
>
> And you're _sure_ none of them has a "break-everything" hunk in it? :)

Pretty sure!  Here's a diffstat:

$ git diff --stat HEAD^^..
 drivers/video/console/Kconfig             |   12 +
 drivers/video/console/Makefile            |    2 +
 drivers/video/console/font_neepalt10x20.c | 5392 ++++++++++++++++++++++++
 drivers/video/console/font_neepalt12x24.c | 6416 +++++++++++++++++++++++++++++
 drivers/video/console/fonts.c             |    8 +
 include/linux/font.h                      |    6 +-
 net/bluetooth/hidp/core.c                 |    6 +
 7 files changed, 11841 insertions(+), 1 deletions(-)

> I see you have FTRACE enabled. That's new and could potentially bugger
> things up without the compiler knowing, so can you turn that off.
>
> And can you enable CONFIG_CODE_PATCHING_SELFTEST and
> CONFIG_FTR_FIXUP_SELFTEST, that will enable tests of some code I changed
> that /could/ (maybe) cause random blow ups.

I'll try these out.

> Also, how old is the machine? Any chance you're just seeing random
> memory corruption?

It's about four years old.  It was in storage for about six months and I
got it repaired a few weeks ago (display cable and inverter).  The sort
of crazy crap I've been reporting certainly smacks of memory corruption.
But on the other hand, 2.6.25 (Debian's) and 2.6.26 (my own) have been
trouble-free.

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
