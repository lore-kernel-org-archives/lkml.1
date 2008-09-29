Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbYI2Rgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbYI2Rgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 13:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYI2RgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 13:36:22 -0400
Received: from styx.suse.cz ([82.119.242.94]:58933 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751377AbYI2RgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 13:36:21 -0400
Date: Mon, 29 Sep 2008 19:36:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, agospoda@redhat.com,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, Karsten Keil <kkeil@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, chris.jones@canonical.com,
       arjan@linux.jf.intel.com
Subject: RE: e1000e NVM corruption issue status
In-Reply-To: <alpine.LNX.1.10.0809291917220.4022@jikos.suse.cz>
Message-ID: <alpine.LNX.1.10.0809291935360.4022@jikos.suse.cz>
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com> <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com> <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com> <Pine.WNT.4.63.0809251913300.1736@jbrandeb-desk.amr.corp.intel.com>
 <alpine.LNX.1.10.0809291740140.4022@jikos.suse.cz> <alpine.LNX.1.10.0809291817130.4022@jikos.suse.cz> <36D9DB17C6DE9E40B059440DB8D95F52064B1603@orsmsx418.amr.corp.intel.com> <alpine.LNX.1.10.0809291917220.4022@jikos.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008, Jiri Kosina wrote:

> > > We are missing 'break;' after the memset, and that is where the
> > > hanging machine comes from (the loop keeps spinning forever), right?
> > > I will verify this right away.
> > Yep, I think you're right.  I'm almost done prepping our current patch
> > series, I'll include that fix.  Please let me know if your test shows it
> > fixes it.
> Yes, it fixed the hang. It crashed later though
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
> IP: [<ffffffffa045211b>] inet6_net_init+0x98/0xf2 [ipv6]
> PGD 39d15067 PUD 39d14067 PMD 0
> Oops: 0000 [1] SMP
> last sysfs file: 
> /sys/devices/pci0000:00/0000:00:1e.0/0000:15:00.0/0000:16:00.0/local_cpus

Hmm, this happens even if I put the e1000e module completely out of way 
(and it happens when userspace is starting postfix), so it might be a 
completely separate issue.

-- 
Jiri Kosina
SUSE Labs
