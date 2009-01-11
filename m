Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbZAKWz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbZAKWz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 17:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbZAKWzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 17:55:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38166 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbZAKWzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 17:55:20 -0500
Date: Sun, 11 Jan 2009 17:55:03 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Theodore Tso <tytso@mit.edu>, Kyle McMartin <kyle@infradead.org>,
       Dave Jones <davej@redhat.com>, Jan Beulich <jbeulich@novell.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       ccache@lists.samba.org
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
Message-ID: <20090111225503.GB21090@bombadil.infradead.org>
References: <E1LKDeQ-0002xz-7E@closure.thunk.org> <20090107131221.GA17110@mit.edu> <20090108191703.GA11273@redhat.com> <20090108213157.GB922@mit.edu> <20090111214837.GA21090@bombadil.infradead.org> <20090111225138.GF29383@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111225138.GF29383@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 05:51:38PM -0500, Theodore Tso wrote:
> On Sun, Jan 11, 2009 at 04:48:37PM -0500, Kyle McMartin wrote:
> > 
> > with a distro kernel config (ie: Fedora's[1]) still results in
> > 1.8GB of modules (willy checked that it wasn't a Fedora toolchain
> > bug by reproducing on a Debian system.)
> 
> P.S.  I have a hacked make-kpkg which installs the modules via:
> 
>       make INSTALL_MOD_STRIP=1  modules_install
> 
> Unfortunately, I'm not using kbuild's make install builddeb since it
> doesn't create the headers and debuginfo files; and the debian's
> official kernel building scripts (make-kpkg has been deprecated)
> doesn't correctly deal with creating debuginfo files, either. 
> 
> In any case, its make INSTALL_MOD_STRIP=1 which is getting busted by
> the two commits, and which also spike out ccache and distcc.
> 

Right, I had a braino and forgot that having 1.8GB of modules is
actually expected. The broken stage is the stripping of the debuginfo
into a seperate set of files, so it's likely Fedora-specific.

regards, Kyle
