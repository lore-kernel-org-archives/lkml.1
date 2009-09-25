Return-Path: <linux-kernel-owner+w=401wt.eu-S1751783AbZIYF0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbZIYF0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 01:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbZIYF0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 01:26:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:41534 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbZIYF0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 01:26:45 -0400
From: Neil Brown <neilb@suse.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 25 Sep 2009 15:27:40 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19132.21708.867658.970822@notabene.brown>
Cc: lmb@suse.de, lars.ellenberg@linbit.com, arjan@infradead.org,
       jens.axboe@oracle.com, hch@infradead.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com,
       akpm@linux-foundation.org, bart.vanassche@gmail.com, davej@redhat.com,
       gregkh@suse.de, kosaki.motohiro@jp.fujitsu.com, kyle@moffetthome.net,
       torvalds@linux-foundation.org, nab@linux-iscsi.org, knikanth@suse.de,
       philipp.reisner@linbit.com, sam@ravnborg.org, Mauelshagen@redhat.com
Subject: Re: [GIT PULL] DRBD for 2.6.32
In-Reply-To: message from FUJITA Tomonori on Thursday September 24
References: <20090922062034.GE22732@suse.de>
	<20090923203531C.fujita.tomonori@lab.ntt.co.jp>
	<19130.43495.807916.962040@notabene.brown>
	<20090924083617J.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday September 24, fujita.tomonori@lab.ntt.co.jp wrote:
> On Thu, 24 Sep 2009 09:06:15 +1000
> Neil Brown <neilb@suse.de> wrote:
> 
> > On Wednesday September 23, fujita.tomonori@lab.ntt.co.jp wrote:
> > > On Tue, 22 Sep 2009 08:20:34 +0200
> > > Lars Marowsky-Bree <lmb@suse.de> wrote:
> > > 
> > > > On 2009-09-22T07:27:21, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > > > 
> > > > > > If it happens, once that happens, that _will_ be an ABI break.
> > > > > 
> > > > > You misunderstand the raid unification.
> > > > > 
> > > > > We will not unify the kernel<->userspace configuration interface
> > > > > because we can't break the kernel<->userspace ABI.
> > > > 
> > > > I disagree here. Who says we can't over time, and with due notice?
> > > > 
> > > > For sure, the new ABI needs to co-exist with the old ones for a while,
> > > > until it is proven and fully complete, but then, why can't the old one
> > > > be marked as depreciated and phased out over 1-2 years time?
> > > 
> > > Let me know If you find a Linux storage developer who say, "Yeah, we
> > > can remove the md ABI over 1-2 years time after the raid unification".
> > 
> > I would have said 3-5 years, that being about the time frame for
> > enterprise releases, and it would be best if every enterprise vendor
> 
> Enterprise vendors don't pick up the latest kernel. So I think that we
> need more.

I don't really follow your logic, but that isn't important.  I think
that we need to be open to deprecating old ABIs, particularly when the
ABI is largely used by just one or two programs or libraries.  This is
the case for md/dm/drbd and similar devices.

> 
> 
> > got to have a release that supported both the old and the new
> > interface.  But I don't have a problem with migrating to a better ABI
> > is we actually had a better ABI.
> > > 
> > > Seems that you have a very different idea from other kernel developers
> > > about the stable ABI.
> > 
> > CONFIG_SYSFS_DEPRECATED_V2  seems to suggest that other kernel
> > developers understand that we sometimes make mistakes and need to
> > deprecate them.
> 
> Yeah, however, we can try not to make mistakes.

In this case the mistakes are already made.   The main mistake was
that there was no credible model to follow for managing a virtual
block device.  There is still no generally good model to follow so
that mistake hasn't been fixed.

Merging perfectly working and widely used code, so that it will be
easier for the community to maintain, to learn from, and to help
improve is not a mistake.
Had the implementers deliberately ignored the established practice in
the kernel for doing things you might have a case.  But there was no
established practice to follow or to ignore.

> 
> 
> > However I think this is all very premature as there is even a coherent
> > proposal for what unification might look like, let alone broad
> > agreement or implementation.  I would *much* rather we spent our
> > energies debating that than debating whether or not DRBD should get
> > merged.... Maybe would should only accept votes on "Should DRBD get
> > merged" from people provide constructive input to the question "what
> > would a unified virtual block device model look like".
> > 
> > > 
> > > Improving the existing framework is a proper approach.
> > 
> > Yes.  So let's do it.
> 
> So we should implement something like drbd on the top of dm framework,
> one of the existing 'virtual device' frameworks. That would improve dm
> and we could get better ideas about "what would a unified virtual
> block device model look like".

dm is not an appropriate framework.  It is a walled garden that
follows its own rules rather than being consistent with the rest of
the kernel.
The clearest example is that individual drivers in dm don't present
block devices, they present dm-targets.  dm-targets do not fit in to
the device model and are not visible in sysfs.

NeilBrown
