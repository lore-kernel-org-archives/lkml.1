Return-Path: <linux-kernel-owner+w=401wt.eu-S1760791AbYDNOyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760791AbYDNOyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbYDNOyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:54:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195AbYDNOyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:54:11 -0400
Date: Mon, 14 Apr 2008 10:53:23 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Neil Horman <nhorman@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, nickpiggin@yahoo.com.au,
       k-miyoshi@cb.jp.nec.com, greg@kroah.com,
       Bernhard Walle <bwalle@suse.de>, kdb@oss.sgi.com,
       kexec@lists.infradead.org, Takenori Nagano <t-nagano@ah.jp.nec.com>,
       linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Keith Owens <kaos@ocs.com.au>
Subject: Re: [PATCH 0/2] add new notifier function ,take3
Message-ID: <20080414145323.GE6941@redhat.com>
References: <47FF190B.6030406@ah.jp.nec.com> <20080411210751.e4a468b2.akpm@linux-foundation.org> <20080414134622.GB6941@redhat.com> <20080414144228.GD1193@hmsendeavour.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414144228.GD1193@hmsendeavour.rdu.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 10:42:28AM -0400, Neil Horman wrote:
> On Mon, Apr 14, 2008 at 09:46:22AM -0400, Vivek Goyal wrote:
> > On Fri, Apr 11, 2008 at 09:07:51PM -0700, Andrew Morton wrote:
> > 
> > [..]
> > > > Kernel panic - not syncing: Panic by panic_module.
> > > > __tunable_atomic_notifier_call_chain enter
> > > > msg_handler:panic_event was called.
> > > > ipmi_wdog:wdog_panic_handler was called.
> > > > notifier_test: notifier_test_panic() is called.
> > > > notifier_test: notifier_test_panic2() is called.
> > > 
> > > OK.  But I don't see anywhere in here the most important piece of
> > > information: why do we need this feature in Linux?
> > > 
> > > What are the use-cases?  What is the value?  etc.
> > > 
> > > Often I can guess (but I like the originator to remove the guesswork).  In
> > > this case I'm stumped - I can't see any reason why anyone would want this.
> > > 
> > 
> > Hi Andrew,
> > 
> > To begin with, he wants kdb, kgdb etc to co-exist with kdump. He wants
> > to put all the RAS tools (who are interested in panic event) on a list
> > and export it to user space and let user decide in what order do the tool get
> > executed at panic time (based on priority).
> > 
> > This brings in little bit reliability concerns for kdump due to notifier
> > code being run after panic.
> > 
> > I think people want to use this infrastrutucure beyond RAS tools. I
> > remember somebody wanting to send a message to remote node after a
> > panic (before kdump kicks in)  so that remote node can initiate failover
> > etc.
> > 
> I know it doesn't particularly relate to this patch, but FWIW, for cases like
> failover, I've inserted infrastrucutre in the userspace part of kdump for
> Fedora/RHEL to support this sort of thing.  We can run arbitrary scripts righte
> before and after a capture so that notifications can be sent to remote nodes in
> a much safer fashion than using the notifier chain after a panic.
> Neil
> 

That's great. I did not know about these. So user can write custom
scripts/binaries which can be packed into kdump initrd and executed either
before or after dump capture? Any idea, if somebody has started using it
already?

If that's the case then only other serious user at this point of time
is kernel debugger (kdb, kgdb), which needs to run before kdump, in case
of panic. And Eric suggested for those cases debugger can just insert a 
break point at panic(), instead of introducing the tunable notifier list
infrastructure.

Thanks
Vivek
