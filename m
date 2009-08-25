Return-Path: <linux-kernel-owner+w=401wt.eu-S932314AbZHYXHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbZHYXHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 19:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932260AbZHYXHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 19:07:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:35503 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241AbZHYXHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 19:07:33 -0400
From: Neil Brown <neilb@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Date: Wed, 26 Aug 2009 09:08:03 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19092.28371.793339.764701@notabene.brown>
Cc: Ric Wheeler <rwheeler@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
In-Reply-To: message from Pavel Machek on Tuesday August 25
References: <20090824195159.GD29763@elf.ucw.cz>
	<4A92F6FC.4060907@redhat.com>
	<20090824205209.GE29763@elf.ucw.cz>
	<4A930160.8060508@redhat.com>
	<20090824212518.GF29763@elf.ucw.cz>
	<20090824223915.GI17684@mit.edu>
	<20090824230036.GK29763@elf.ucw.cz>
	<20090825000842.GM17684@mit.edu>
	<20090825094244.GC15563@elf.ucw.cz>
	<4A93E908.6050908@redhat.com>
	<20090825211515.GA3688@elf.ucw.cz>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday August 25, pavel@ucw.cz wrote:
> 
> You can object any way you want, but running ext3 on flash or MD RAID5
> is stupid:
> 
> * ext2 would be faster
> 
> * ext2 would provide better protection against powerfail.
> 
> "ext3 works on flash and MD RAID5, as long as you do not have
> powerfail" seems to be the accurate statement, and if you don't need
> to protect against powerfails, you can just use ext2.
> 								Pavel

You are over generalising.
MD/RAID5 is only less than perfect if it is degraded.  If all devices
are present before the power failure and after the power failure,
then there is no risk.

RAID5 only promises to protect against a single failure.
Power loss plus device loss equals multiple failure.

And then there is the comment Ted made about probabilities.
While you can get data corruption if a RAID5 comes back degraded after
a power fail, I believe it is a lot less likely than the metadata
being inconsistent on an ext2 after a power fail.
So ext3 is still a good choice (especially if you put your journal on
a separate device).


While I think it is, in principle, worth documenting this sort of
thing, there are an awful lot of fine details and distinctions that
would need to be considered.

NeilBrown
