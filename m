Return-Path: <linux-kernel-owner+w=401wt.eu-S932258AbZHYW6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbZHYW6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 18:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932215AbZHYW6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 18:58:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:35201 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932166AbZHYW6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 18:58:13 -0400
From: Neil Brown <neilb@suse.de>
To: Theodore Tso <tytso@mit.edu>
Date: Wed, 26 Aug 2009 08:58:41 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19092.27809.480243.979274@notabene.brown>
Cc: Pavel Machek <pavel@ucw.cz>, Ric Wheeler <rwheeler@redhat.com>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
In-Reply-To: message from Theodore Tso on Monday August 24
References: <20090323104525.GA17969@elf.ucw.cz>
	<87ljqn82zc.fsf@frosties.localdomain>
	<20090824093143.GD25591@elf.ucw.cz>
	<82k50tjw7u.fsf@mid.bfk.de>
	<20090824130125.GG23677@mit.edu>
	<20090824195159.GD29763@elf.ucw.cz>
	<4A92F6FC.4060907@redhat.com>
	<20090824205209.GE29763@elf.ucw.cz>
	<4A930160.8060508@redhat.com>
	<20090824212518.GF29763@elf.ucw.cz>
	<20090824223915.GI17684@mit.edu>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday August 24, tytso@mit.edu wrote:
> On Mon, Aug 24, 2009 at 11:25:19PM +0200, Pavel Machek wrote:
> > > I have to admit that I have not paid enough attention to this specifics  
> > > of your ext3 + flash card issue - is it the ftl stuff doing out of order  
> > > IO's? 
> > 
> > The problem is that flash cards destroy whole erase block on unplug,
> > and ext3 can't cope with that.
> 
> Sure --- but name **any** filesystem that can deal with the fact that
> 128k or 256k worth of data might disappear when you pull out the flash
> card while it is writing a single sector? 

A Log structured filesystem could certainly be written to deal with
such a situation, providing by 'deal with' you mean 'only loses data
that has not yet been acknowledged to the application'.  Of course the
filesystem would need clear visibility into exactly how these blocks
are positioned.

I've been playing with just such a filesystem for some time (never
really finding enough time) with the goal of making it work over RAID5
with no data risk due to power loss.  One day it will be functional
enough for others to try....

It is entirely possible that NILFS could be made to meet that
requirement, but I haven't made time to explore NILFS so I cannot be
sure.

NeilBrown

