Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbXJKTcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbXJKTcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 15:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbXJKTcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 15:32:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbXJKTcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 15:32:13 -0400
Date: Thu, 11 Oct 2007 15:19:17 -0400
From: Dave Jones <davej@redhat.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin <spaceman__spiff@cox.net>, Greg KH <greg@kroah.com>,
       Olof Johansson <olof@lixom.net>, Greg KH <gregkh@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>, Mark Lord <mlord@pobox.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org, alan@lxorguk.ukuu.org.uk,
       BDFL <volkerdi@slackware.com>, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: ARPM shutdown oops (Re: [stable] [patch 09/12] Fix SMP
	poweroff hangs)
Message-ID: <20071011191917.GA11732@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jeff Garzik <jgarzik@pobox.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kevin <spaceman__spiff@cox.net>, Greg KH <greg@kroah.com>,
	Olof Johansson <olof@lixom.net>, Greg KH <gregkh@suse.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Theodore Ts'o <tytso@mit.edu>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Justin Forbes <jmforbes@linuxtx.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Domenico Andreoli <cavokz@gmail.com>, Mark Lord <mlord@pobox.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>, akpm@linux-foundation.org,
	Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
	alan@lxorguk.ukuu.org.uk, BDFL <volkerdi@slackware.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
References: <20071008180406.052382073@mini.kroah.org> <200710092359.47144.spaceman__spiff@cox.net> <alpine.LFD.0.999.0710100747120.3838@woody.linux-foundation.org> <200710102005.02184.spaceman__spiff@cox.net> <alpine.LFD.0.999.0710110818580.20690@woody.linux-foundation.org> <470E6E79.6040908@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470E6E79.6040908@pobox.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 02:42:01PM -0400, Jeff Garzik wrote:
 > Linus Torvalds wrote:
 > > 
 > > And I think I see the problem: it's a config change. You don't have 
 > > PM_LEGACY enabled. Your config file diff shows:
 > > 
 > > 	-CONFIG_PM_LEGACY=y
 > > 	+# CONFIG_PM_LEGACY is not set
 > > 
 > > I suspect we should make CONFIG_APM either depend on, or select, 
 > > PM_LEGACY. But as far as I can see, nothing has actually changed in this 
 > > area in the kernel, and this bug has been there before - just your config 
 > > change made it appear. 
 > > 
 > > Rafael? Stephen? Opinions? I'd think that making APM depend on 
 > > CONFIG_PM_LEGACY is the right thing to do these days..
 > 
 > Speaking as the author of
 > 
 > 	[PATCH] move pm_register/etc. to CONFIG_PM_LEGACY, pm_legacy.h
 > 
 > I agree.  arch/i386/kernel/apm.c clearly requires 
 > include/linux/pm_legacy.h and the legacy PM API.
 > 
 > I would vote for a dependency rather than select, but don't have any 
 > strong feelings on the matter...

gti revert 987d4613e52e4f655278265aabbcc69237018b1d
should do the trick.

	Dave

-- 
http://www.codemonkey.org.uk
