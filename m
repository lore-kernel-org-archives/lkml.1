Return-Path: <linux-kernel-owner+w=401wt.eu-S1763492AbXGZPeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763492AbXGZPeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbXGZPen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:34:43 -0400
Received: from mx1.suse.de ([195.135.220.2]:59954 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbXGZPem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:34:42 -0400
Date: Thu, 26 Jul 2007 17:34:40 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Takenori Nagano <t-nagano@ah.jp.nec.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, k-miyoshi@cb.jp.nec.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] add kdump_after_notifier
Message-ID: <20070726153440.GA19095@suse.de>
Mail-Followup-To: Vivek Goyal <vgoyal@in.ibm.com>,
	Takenori Nagano <t-nagano@ah.jp.nec.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, k-miyoshi@cb.jp.nec.com,
	Andrew Morton <akpm@linux-foundation.org>
References: <469F55D0.4050203@ah.jp.nec.com> <20070726140702.GA8949@suse.de> <20070726153240.GA15969@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726153240.GA15969@in.ibm.com>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@in.ibm.com> [2007-07-26 17:32]:
> On Thu, Jul 26, 2007 at 04:07:02PM +0200, Bernhard Walle wrote:
> > * Takenori Nagano <t-nagano@ah.jp.nec.com> [2007-07-19 14:15]:
> > > 
> > > In latest kernel, we can't use panic_notifier_list if kdump is enabled.
> > > panic_notifier_list is very useful function for debug, failover, etc...
> > > 
> > > So this patch adds a control file /proc/sys/kernel/dump_after_notifier
> > > and resolves a problem users can not use both kdump and panic_notifier_list
> > > at the same time.
> > > 
> > > kdump_after_notifier = 0
> > >  -> panic()
> > >     -> crash_kexec(NULL)
> > > 
> > > kdump_after_notifier = 1
> > >  -> panic()
> > >     -> atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
> > >     -> crash_kexec(NULL)
> > 
> > What's problematic about this patch? I also would like to see that
> > feature.
> 
> I would like to see the code which will get executed after panic and 
> before crash_kexec(). This potentially makes crash dump feature unreliable
> in the sense one can now register on panic_notifier_list and try to
> do whole lot of things and might get stuck there. After the system
> has crashed, one is not supposed to do a whole lot.

Of course, but that's why the patch doesn't change this by default but
gives the user the choice.


Thanks,
   Bernhard
