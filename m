Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbZAKWvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbZAKWvx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 17:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbZAKWvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 17:51:44 -0500
Received: from thunk.org ([69.25.196.29]:46891 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbZAKWvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 17:51:43 -0500
Date: Sun, 11 Jan 2009 17:51:38 -0500
From: Theodore Tso <tytso@mit.edu>
To: Kyle McMartin <kyle@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Jan Beulich <jbeulich@novell.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       ccache@lists.samba.org
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
Message-ID: <20090111225138.GF29383@mit.edu>
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
> 
> with a distro kernel config (ie: Fedora's[1]) still results in
> 1.8GB of modules (willy checked that it wasn't a Fedora toolchain
> bug by reproducing on a Debian system.)

P.S.  I have a hacked make-kpkg which installs the modules via:

      make INSTALL_MOD_STRIP=1  modules_install

Unfortunately, I'm not using kbuild's make install builddeb since it
doesn't create the headers and debuginfo files; and the debian's
official kernel building scripts (make-kpkg has been deprecated)
doesn't correctly deal with creating debuginfo files, either. 

In any case, its make INSTALL_MOD_STRIP=1 which is getting busted by
the two commits, and which also spike out ccache and distcc.

    		     	   	      	  - Ted
