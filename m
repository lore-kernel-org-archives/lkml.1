Return-Path: <linux-kernel-owner+w=401wt.eu-S1753251AbZAKWMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbZAKWMB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 17:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbZAKWLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 17:11:52 -0500
Received: from thunk.org ([69.25.196.29]:46932 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbZAKWLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 17:11:52 -0500
Date: Sun, 11 Jan 2009 17:11:32 -0500
From: Theodore Tso <tytso@mit.edu>
To: Kyle McMartin <kyle@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Jan Beulich <jbeulich@novell.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       ccache@lists.samba.org
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
Message-ID: <20090111221132.GE29383@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Kyle McMartin <kyle@infradead.org>, Dave Jones <davej@redhat.com>,
	Jan Beulich <jbeulich@novell.com>, Sam Ravnborg <sam@ravnborg.org>,
	linux-kernel@vger.kernel.org, ccache@lists.samba.org
References: <E1LKDeQ-0002xz-7E@closure.thunk.org> <20090107131221.GA17110@mit.edu> <20090108191703.GA11273@redhat.com> <20090108213157.GB922@mit.edu> <20090111214837.GA21090@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111214837.GA21090@bombadil.infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 04:48:37PM -0500, Kyle McMartin wrote:
> > > I'll have to revert  ad7a953c for our builds to continue tracking mainline
> > > without monopolising the diskspace in the Fedora build system.
> > 
> > Note: you'll probably also have revert 9bb48247 (allow stripping of
> > generated symbols under CONFIG_KALLSYMS_ALL) since I believe it
> > depends on ad7a953c.
> 
> This doesn't appear to be the culprit. Or at least, doesn't fix the
> problem.
> 
> 	make INSTALL_MOD_PATH=mods/ modules_install
> 
> with a distro kernel config (ie: Fedora's[1]) still results in
> 1.8GB of modules (willy checked that it wasn't a Fedora toolchain
> bug by reproducing on a Debian system.)
> 
> As near as I can ascertain, this is limited to x86_64, at least on
> Fedora:

It shows up for me with x86_32, and it is fixed by reverting those two
commits.  Pre-2.6.28-rc6:

 74864 -rw-r--r-- 1 tytso tytso  76657780 2008-12-12 14:41 linux-image-2.6.28-rc8-00066-gc810663_tytso.SMP.1_i386.deb

Post 2.6.28:

146380 -rw-r--r-- 1 tytso tytso 149888992 2009-01-06 02:01 linux-image-2.6.28-05784-gd5b9778_tytso.SMP.1_i386.deb

After I revert the above two commits:

 76340 -rw-r--r-- 1 tytso tytso  78167848 2009-01-09 08:45 linux-image-2.6.28-07956-g2e69ab5_tytso.SMP.1_i386.deb

       		    	  	 	  	     	   - Ted
