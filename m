Return-Path: <linux-kernel-owner+w=401wt.eu-S1762427AbZAHTRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762427AbZAHTRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760258AbZAHTRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:17:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51182 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759952AbZAHTRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:17:40 -0500
Date: Thu, 8 Jan 2009 14:17:03 -0500
From: Dave Jones <davej@redhat.com>
To: Theodore Tso <tytso@mit.edu>, Jan Beulich <jbeulich@novell.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       ccache@lists.samba.org
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
Message-ID: <20090108191703.GA11273@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Jan Beulich <jbeulich@novell.com>,
	Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
	ccache@lists.samba.org
References: <E1LKDeQ-0002xz-7E@closure.thunk.org> <20090107131221.GA17110@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107131221.GA17110@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 08:12:21AM -0500, Theodore Tso wrote:
 > On Tue, Jan 06, 2009 at 10:15:26AM -0500, Theodore Ts'o wrote:
 > > The following commit, ad7a953c, "kbuild: strip generated symbols from
 > > *.ko" which was merged to the mainline last week (December 28th) has the
 > > unfortunate side effct of making ccache useless.
 > 
 > I've just discovered another problem with this commit.
 > 
 > % du -s /lib/modules/2.6.28
 > 63072	/lib/modules/2.6.28/
 >  du -s /lib/modules/2.6.28-git7
 > 221556	/lib/modules/2.6.28-git7/
 > 
 > The two configs are largely equal.  I'm building with
 > CONFIG_DEBUG_KERNEL=y, but then installing with "make
 > INSTALL_MOD_STRIP=1 modules_install".   

Fedora rawhide users noticed this same problem this morning too,
when I pushed out a build that eats up a gig of diskspace thanks
to the number of modules we have, that are all afflicted by this problem.

I'll have to revert ad7a953c for our builds to continue tracking mainline
without monopolising the diskspace in the Fedora build system.

	Dave

-- 
http://www.codemonkey.org.uk
