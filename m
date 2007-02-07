Return-Path: <linux-kernel-owner+w=401wt.eu-S1422787AbXBGWJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422787AbXBGWJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 17:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422909AbXBGWJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 17:09:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422787AbXBGWJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 17:09:37 -0500
From: Neil Brown <neilb@suse.de>
To: "Kai" <epimetreus@fastmail.fm>
Date: Thu, 8 Feb 2007 09:08:58 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17866.19962.601479.638730@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Re: Bio device too big | kernel BUG at mm/filemap.c:537!
In-Reply-To: message from Kai on Wednesday February 7
References: <1170734919.15636.1173102761@webmail.messagingengine.com>
	<20070205203750.7be7f772.akpm@linux-foundation.org>
	<17864.4339.925700.626157@notabene.brown>
	<17865.3776.511594.763544@notabene.brown>
	<1170865619.16808.1173403963@webmail.messagingengine.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday February 7, epimetreus@fastmail.fm wrote:
> 
> On Wed, 7 Feb 2007 10:26:56 +1100, "Neil Brown" <neilb@suse.de> said:
> > On Tuesday February 6, neilb@suse.de wrote:
> > > 
> > > This patch should fix the worst of the offences, but I'd like to
> > > experiment and think a bit more before I submit it to stable.
> > > And probably test it too - as yet I have only compile and brain
> > > tested.
> > 
> > Ok, I've experimented and tested and now I know what was causing the
> > double-unlock.
> > 
> > The following patch is suitable for 2.6.20.1 and mainline.  There is
> > room for a bit more improvement, but only for performance, not
> > correctness.  I'll look into that later.
> > 
> > Thanks,
> > NeilBrown
> 
> I figure I should test this on my hardware, but since the RAID array
> resynched itself when I rebooted back into an earlier kernel version,
> I'm guessing it means this bug introduced some corruption into the
> array, when it occurred, so I'd like some pointers on how I can test it
> out without compromising my data.

This bug should not introduce any data corruption.
It causes some read requests to get a failure from the device, which
will cause raid5 to remove the device from the array (Though the data
will still be intact).
On restart a resync will put everything back as it was.

It is quite possible (this happened to me in my testing) for several
devices to get these errors and for several or even all of these
device to get failed.  However even in this case the data is still
intact and "mdadm --assemble --force ..." will put everything back
together.

So there should be no risk of data corruption.

NeilBrown
