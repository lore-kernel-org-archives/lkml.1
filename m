Return-Path: <linux-kernel-owner+w=401wt.eu-S1757891AbZCQRPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891AbZCQRPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 13:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756501AbZCQRPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 13:15:38 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46748 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316AbZCQRPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 13:15:37 -0400
Date: Tue, 17 Mar 2009 13:10:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>
Subject: Re: 2.6.29-rc8: Reported regressions from 2.6.28
Message-ID: <20090317171047.GF6737@tuxdriver.com>
References: <1237143683.24621.7.camel@johannes.local> <20090315202603.GA9077@elte.hu> <b6a2187b0903160624gb9d207dv301506e589d93ed4@mail.gmail.com> <alpine.LFD.2.00.0903161250080.3082@localhost.localdomain> <b6a2187b0903161655q15437156qc926c8db37d8ba4b@mail.gmail.com> <20090317144802.GF3549@tuxdriver.com> <20090317152801.GA6737@tuxdriver.com> <20090317153924.GA21061@elte.hu> <20090317160527.GB6737@tuxdriver.com> <b6a2187b0903170924u72723220x4c0a717e3cfebf8d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b6a2187b0903170924u72723220x4c0a717e3cfebf8d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 12:24:33AM +0800, Jeff Chua wrote:
> On Wed, Mar 18, 2009 at 12:05 AM, John W. Linville <linville@tuxdriver.com>
> > the reverts.  But if you think it is helpful:
> >        http://bugzilla.kernel.org/attachment.cgi?id=20567&action=view
> 
> I tried applying the above patch against the latest linux git
> (18439c39e826191c0ef08c3a3271ce7ece46a860), but got a lot of rejects.
> Is this supposed to be?
> 
> 
> patch -p1 </tar/v2.6/revert-remove-ssid-knowledge-from-driver-series.patch
> 1 out of 1 hunk FAILED -- saving rejects to file
> drivers/net/wireless/adm8211.h.rej
> 1 out of 2 hunks FAILED -- saving rejects to file
> drivers/net/wireless/b43/main.c.rej
> 1 out of 2 hunks FAILED -- saving rejects to file
> drivers/net/wireless/b43legacy/main.c.rej
> 1 out of 1 hunk FAILED -- saving rejects to file
> drivers/net/wireless/iwlwifi/iwl-3945.h.rej
> 3 out of 4 hunks FAILED -- saving rejects to file
> drivers/net/wireless/iwlwifi/iwl-agn.c.rej
> 1 out of 1 hunk FAILED -- saving rejects to file
> drivers/net/wireless/iwlwifi/iwl-dev.h.rej
> 3 out of 5 hunks FAILED -- saving rejects to file
> drivers/net/wireless/iwlwifi/iwl3945-base.c.rej
> 1 out of 3 hunks FAILED -- saving rejects to file include/net/mac80211.h.rej

Works for me...I even re-downloaded the patch from bugzilla.

/home/linville/git/linux-2.6
[linville-t400.local]:> git show
commit 18439c39e826191c0ef08c3a3271ce7ece46a860
Merge: 9e8912e... b35f8ca...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Mar 17 08:59:33 2009 -0700

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-2.6-dm
    
    * git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-2.6-dm:
      dm crypt: wait for endio to complete before destruction
      dm crypt: fix kcryptd_async_done parameter
      dm io: respect BIO_MAX_PAGES limit
      dm table: rework reference counting fix
      dm ioctl: validate name length when renaming


/home/linville/git/linux-2.6
[linville-t400.local]:> patch -p1 < revert-remove-ssid-knowledge-from-driver-series.patch 
patching file drivers/net/wireless/adm8211.c
patching file drivers/net/wireless/adm8211.h
patching file drivers/net/wireless/b43/main.c
patching file drivers/net/wireless/b43legacy/main.c
patching file drivers/net/wireless/iwlwifi/iwl-3945.h
patching file drivers/net/wireless/iwlwifi/iwl-agn.c
patching file drivers/net/wireless/iwlwifi/iwl-dev.h
patching file drivers/net/wireless/iwlwifi/iwl-scan.c
patching file drivers/net/wireless/iwlwifi/iwl3945-base.c
patching file include/net/mac80211.h
patching file net/mac80211/ieee80211_i.h
patching file net/mac80211/main.c
patching file net/mac80211/mlme.c
patching file net/mac80211/wext.c

Perhaps you have a dirty tree?

	git checkout -f

Does that help?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
