Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbYJCVpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbYJCVpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 17:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbYJCVpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 17:45:10 -0400
Received: from styx.suse.cz ([82.119.242.94]:53898 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752834AbYJCVpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 17:45:09 -0400
Date: Fri, 3 Oct 2008 23:45:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: David Miller <davem@davemloft.net>, jesse.brandeburg@intel.com,
       linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org,
       kkeil@suse.de, agospoda@redhat.com, arjan@linux.intel.com,
       david.graham@intel.com, bruce.w.allan@intel.com, john.ronciak@intel.com,
       Thomas Gleixner <tglx@linutronix.de>, chris.jones@canonical.com,
       tim.gardner@intel.com, airlied@gmail.com, Olaf Kirch <okir@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 02/12] On Tue, 23 Sep 2008, David Miller wrote:
In-Reply-To: <200810031429.22598.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LNX.1.10.0810032338140.26779@jikos.suse.cz>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com> <200810021523.45884.jbarnes@virtuousgeek.org> <20081003.134634.240211201.davem@davemloft.net> <200810031429.22598.jbarnes@virtuousgeek.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008, Jesse Barnes wrote:

> Ok, thanks.  You'll have to check Linus' tree for sanity though, he just 
> merged a variant on my patch for 2.6.27.  See 
> b5ff7df3df9efab511244d5a299fce706c71af48 and yell if it broke something 
> for you.

Karsten has been testing kernel with these three patches from the series 
applied:

	e1000e: reset swflag after resetting hardware
	e1000e: fix lockdep issues
	e1000e: debug contention on NVM SWFLAG

This was done on a hardware which previously triggered the bug in just a 
few test iterations in quite a reliable way. Now, with these patches 
applied, the EEPROM corruption didn't happen after several tens of 
iterations.

Please note, that the patch that disables the writes to EEPROM on hardware 
level was *not* involved in this testing.

Therefore it currently seems that these three patches really address the 
race condition issue that was present in the e1000e driver.

It is still not clear why the bug started triggering all of a sudden for 
so many people though.

-- 
Jiri Kosina
SUSE Labs
