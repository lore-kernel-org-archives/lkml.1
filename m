Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab0AOBxu (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755710Ab0AOBxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:53:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:10189 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab0AOBxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:53:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,279,1262592000"; 
   d="scan'208";a="484142770"
Message-Id: <20100115013957.027452000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jan 2010 17:39:57 -0800
From: "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, "Len Brown" <lenb@kernel.org>,
        "Mark Hounschell" <markh@compro.net>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Alain Knaff" <alain@knaff.lu>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: [patch 0/4] Only use HPET MSI timers on systems with deep C-state support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a functionality issue reported on some AMD platforms
http://lkml.indiana.edu/hypermail/linux/kernel/0912.2/01118.html
wherein, fdformat fails when HPET MSI based percpu timer is used.

We do not have the real root-cause for that problem. But, that
report exposed an issue with our current usage HPET MSI timers.
We use HPET MSI timers even on platforms that do not have
support for C2/C3 states. On those systems we should rather be
using LAPIC timers.

So, this series of patches does just that.
* Use LAPIC timer when there is always running APIC timer
* Use LAPIC timer on platforms that do not have support for deep C states
* Only use HPET MSI timers as percpu timers on systems that have LAPICs
  that stop in deep C-states _and_ system supports deep C-states

The change turned out to be more than what I expected, due to
the current static nature of clockevent rating and unrelated
issues in acpi processor driver resume path. I also ended up
touching different subsystems to handle this.

If the patchset resolves the issue for Mark and if it looks sane
can one of the maintainers queue it up for .34

Reported-by: Mark Hounschell <markh@compro.net>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

-- 

