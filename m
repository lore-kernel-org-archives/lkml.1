Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbZAKVtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbZAKVtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 16:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbZAKVtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 16:49:01 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57510 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZAKVtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 16:49:00 -0500
Date: Sun, 11 Jan 2009 16:48:37 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Theodore Tso <tytso@mit.edu>, Dave Jones <davej@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, ccache@lists.samba.org
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
Message-ID: <20090111214837.GA21090@bombadil.infradead.org>
References: <E1LKDeQ-0002xz-7E@closure.thunk.org> <20090107131221.GA17110@mit.edu> <20090108191703.GA11273@redhat.com> <20090108213157.GB922@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090108213157.GB922@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 04:31:58PM -0500, Theodore Tso wrote:
> On Thu, Jan 08, 2009 at 02:17:03PM -0500, Dave Jones wrote:
> > 
> > Fedora rawhide users noticed this same problem this morning too,
> > when I pushed out a build that eats up a gig of diskspace thanks
> > to the number of modules we have, that are all afflicted by this problem.
> > 
> > I'll have to revert  ad7a953c for our builds to continue tracking mainline
> > without monopolising the diskspace in the Fedora build system.
> 
> Note: you'll probably also have revert 9bb48247 (allow stripping of
> generated symbols under CONFIG_KALLSYMS_ALL) since I believe it
> depends on ad7a953c.
> 

This doesn't appear to be the culprit. Or at least, doesn't fix the
problem.

	make INSTALL_MOD_PATH=mods/ modules_install

with a distro kernel config (ie: Fedora's[1]) still results in
1.8GB of modules (willy checked that it wasn't a Fedora toolchain
bug by reproducing on a Debian system.)

As near as I can ascertain, this is limited to x86_64, at least on
Fedora:

kyle@localhost ~/misc $ for i in *.rpm; do echo $i; rpm
	-qip $i | grep Size; done
kernel-2.6.29-0.25.rc0.git14.fc11.ppc64.rpm
Size        : 124858478                        License:
kernel-2.6.29-0.25.rc0.git14.fc11.ppc.rpm
Size        : 66313693                         License:
kernel-2.6.29-0.25.rc0.git14.fc11.x86_64.rpm
Size        : 1041480317                       License:
kernel-PAE-2.6.29-0.25.rc0.git14.fc11.i686.rpm
Size        : 56252360                         License:

x86_64 is an order of magnitude bigger than the rest, which have
identical debug options enabled.

regards, Kyle
