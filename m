Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab0AORXj (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 12:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757884Ab0AORXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 12:23:38 -0500
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:51814 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757859Ab0AORXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 12:23:37 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtQEAHcwUEuuWOiG/2dsb2JhbACBRNg5hDEE
Date: Fri, 15 Jan 2010 12:23:35 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Jon Bernard <jbernard@debian.org>, Jan Blunck <jblunck@suse.de>,
        linux-kernel@vger.kernel.org, Pedro Alves <pedro@codesourcery.com>,
        ltt-dev@lists.casi.polymtl.ca,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        pierre-marc.fournier@polymtl.ca
Subject: Userspace RCU API (minor changes)
Message-ID: <20100115172335.GC30678@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:12:00 up 30 days,  1:30,  4 users,  load average: 0.16, 0.13,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd like to proceed to a minor API change in the next userspace RCU
release: moving from SIGURCU to SIGRCU for the signal name. This is part
of an effort to standardize the library prefix to "rcu_".  I plan to
add support for backward compatibility, so when we see that SIGURCU is
defined, then we use that value.

Also, I am planning to rename the urcu_init() constructor to rcu_init().
It should only affect the libust tracer, which need to call it
explicitly. Normal users don't have to bother with it, as it's a library
constructor.

Also, the urcu/config.h options are renamed to:

CONFIG_RCU_HAVE_FENCE
CONFIG_RCU_HAVE_FUTEX
CONFIG_RCU_SMP
CONFIG_RCU_COMPAT_ARCH
(moving from URCU -> RCU)

So an updated system installation will keep everything in sync.

I also plan to shuffle the library names a bit, but without breaking
anything. Basically, liburcu will become the "default" version, using
sys_membarrier() when available, and using liburcu-mb as a fallback.

The signal-based liburcu will be renamed from liburcu to liburcu-signal.
People previously using the signal-based "liburcu" will automatically be
moved to the "default" liburcu version.

You might want to have a look at the current git tree head to see if
everything is fine before the release. Given that I change the API
slightly, this will definitely be a 0.4.0.

Feedback is welcome,

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
