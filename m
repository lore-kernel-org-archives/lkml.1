Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbZFPKGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbZFPKGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbZFPKGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 06:06:42 -0400
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:40092 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751604AbZFPKGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 06:06:41 -0400
X-Greylist: delayed 1936 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jun 2009 06:06:41 EDT
Date: Tue, 16 Jun 2009 12:34:01 +0300
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Greg KH <greg@kroah.com>, Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "corbet@lwn.net" <corbet@lwn.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "tshibata@ab.jp.nec.com" <tshibata@ab.jp.nec.com>,
       "mcgrof@gmail.com" <mcgrof@gmail.com>
Subject: Re: [RFC] Documentation: add documentation for rc-series and merge
	window
Message-ID: <20090616093401.GA11602@jm.kir.nu>
References: <1245096771-3966-1-git-send-email-lrodriguez@atheros.com> <20090615201934.GA12685@kroah.com> <20090615214735.GE23972@bombadil.infradead.org> <20090615223206.GA4966@kroah.com> <20090616004122.GC5492@tesla> <20090616021011.GF23972@bombadil.infradead.org> <20090616032034.GA17932@kroah.com> <20090616042113.GA5680@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616042113.GA5680@tesla>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 09:21:14PM -0700, Luis R. Rodriguez wrote:

> +2.0.2: RC-SERIES RULES
> +
> +Rules on what kind of patches are accepted after the merge window closes.
> +These are patches targeted for the kernel rc-series of a kernel prior
> +to its release.
> +
> + - it must fix a reported regression
> + - if must fix a reported security hole
> + - if must fix a reported oops/kernel hang


s/if/it/ twice..

Is there a good reason for documenting different rules for rc-series and
-stable releases? These three rules look stricter than the ones
described in stable_kernel_rules.txt:

 - It must fix a problem that causes a build error (but not for things
   marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
   security issue, or some "oh, that's not good" issue.  In short, something
   critical.

For example, a fix for data corruption that users can hit relatively
easily sounds like a good example of something that should really be
accepted during the rc-phase even if it is not really a regression or
does not cause a kernel oops/hang.

"oh, that's not good" issue is somewhat more difficult to comment on,
but I would expect that there could be some critical issues that really
would benefit from an exception. What exactly would qualify is something
that may be not be easily described in a sentence or two, though.


The main problem I see with having a very hard line on not allowing
critical fixes (however that would be defined) during the rc-phase is
that it will take quite a long time to get the fix eventually out. As an
example, a driver could have a bug that prevents it from working with
certain subset of devices, but this is noticed only couple of kernel
releases after the initial driver merge (e.g., for hardware that was not
yet available for end users at the time the driver was initially
submitted). In other words, the issue would not be a regression, not a
security hole, and not an oops/kernel hang. However, it could make the
driver unusable to large number of users (once the affected hardware
model becomes available; say in a new laptop).

If an issue is fixed just before a start of the next merge window the
patch may not have had enough time to go through the maintainers and end
up in linux-2.6.git in time before the merge window closes. If it
weren't now allowed in during the rc-phase, it may not go into a stable
release either (assuming the rc/stable rules are more or less the same)
and we would be looking something like five month time until the fix
would actually be released in a proper kernel release. Sure,
users/distros could take in some additional patches to fix issues they
care about, but worst case scenarios of close to half a year to fix an
issue in a kernel release does not sound quite ideal.

-- 
Jouni Malinen                                            PGP id EFC895FA
