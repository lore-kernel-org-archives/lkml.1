Return-Path: <linux-kernel-owner+w=401wt.eu-S1761535AbXFTEYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761535AbXFTEYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 00:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbXFTEYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 00:24:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbXFTEYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 00:24:41 -0400
Date: Wed, 20 Jun 2007 00:24:34 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Change in default vm_dirty_ratio
Message-ID: <20070620042434.GC12096@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <1182201271.4883.22.camel@localhost.localdomain> <20070618164711.9de1c38e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618164711.9de1c38e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 04:47:11PM -0700, Andrew Morton wrote:

 > Frankly, I find it very depressing that the kernel defaults matter.  These
 > things are trivially tunable and you'd think that after all these years,
 > distro initscripts would be establishing the settings, based upon expected
 > workload, amount of memory, number and bandwidth of attached devices, etc.

"This is hard, lets make it someone else's problem" shouldn't ever be the
answer, especially if the end result is that we become even more
dependant on bits of userspace running before the system becomes useful.

 > Heck, there should even be userspace daemons which observe ongoing system
 > behaviour and which adaptively tune these things to the most appropriate
 > level.
 > 
 > But nope, nothing.

See the 'libtune' crack that people have been trying to get distros to
adopt for a long time.
If we need some form of adaptive behaviour, the kernel needs to be
doing this monitoring/adapting, not some userspace daemon that may
not get scheduled before its too late.

If the kernel can't get the defaults right, what makes you think
userspace can do better ?    Just as the kernel can't get
"one size fits all" right, there's no silver bullet just by clicking
"this is a database server" button to have it configure random
sysctls etc.  These things require thought and planning that
daemons will never get right in every case.  And when they get
it wrong, the results can be worse than the stock defaults.

libtune is the latest in a series of attempts to do this dynamic
runtime adjustment (hell, I even started such a project myself
back circa 2000 which thankfully never really took off).
It's a bad idea that just won't die.

	Dave

-- 
http://www.codemonkey.org.uk
