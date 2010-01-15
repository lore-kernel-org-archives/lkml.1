Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab0AOVxM (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 16:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113Ab0AOVxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 16:53:11 -0500
Received: from mx2.compro.net ([12.186.155.4]:63672 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab0AOVxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 16:53:10 -0500
X-IronPort-AV: E=Sophos;i="4.49,284,1262581200"; 
   d="scan'208";a="4878304"
Message-ID: <4B50E3C4.2050305@compro.net>
Date: Fri, 15 Jan 2010 16:53:08 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alain Knaff <alain@knaff.lu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: [patch 0/4] Only use HPET MSI timers on systems with deep C-state
 support
References: <20100115013957.027452000@intel.com>
In-Reply-To: <20100115013957.027452000@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2010 08:39 PM, Venkatesh Pallipadi wrote:
> There is a functionality issue reported on some AMD platforms
> http://lkml.indiana.edu/hypermail/linux/kernel/0912.2/01118.html
> wherein, fdformat fails when HPET MSI based percpu timer is used.
> 
> We do not have the real root-cause for that problem. But, that
> report exposed an issue with our current usage HPET MSI timers.
> We use HPET MSI timers even on platforms that do not have
> support for C2/C3 states. On those systems we should rather be
> using LAPIC timers.
> 
> So, this series of patches does just that.
> * Use LAPIC timer when there is always running APIC timer
> * Use LAPIC timer on platforms that do not have support for deep C states
> * Only use HPET MSI timers as percpu timers on systems that have LAPICs
>   that stop in deep C-states _and_ system supports deep C-states
> 
> The change turned out to be more than what I expected, due to
> the current static nature of clockevent rating and unrelated
> issues in acpi processor driver resume path. I also ended up
> touching different subsystems to handle this.
> 
> If the patchset resolves the issue for Mark and if it looks sane
> can one of the maintainers queue it up for .34
> 
> Reported-by: Mark Hounschell <markh@compro.net>
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> 

It does resolve my problem

Mark
