Return-Path: <linux-kernel-owner+w=401wt.eu-S1764210AbXGZPoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764210AbXGZPoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756071AbXGZPoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:44:21 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:43489 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549AbXGZPoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:44:20 -0400
Date: Thu, 26 Jul 2007 21:14:15 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Takenori Nagano <t-nagano@ah.jp.nec.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, k-miyoshi@cb.jp.nec.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [patch] add kdump_after_notifier
Message-ID: <20070726154415.GB15969@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <469F55D0.4050203@ah.jp.nec.com> <20070726140702.GA8949@suse.de> <20070726153240.GA15969@in.ibm.com> <20070726153440.GA19095@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726153440.GA19095@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 05:34:40PM +0200, Bernhard Walle wrote:
> * Vivek Goyal <vgoyal@in.ibm.com> [2007-07-26 17:32]:
> > On Thu, Jul 26, 2007 at 04:07:02PM +0200, Bernhard Walle wrote:
> > > * Takenori Nagano <t-nagano@ah.jp.nec.com> [2007-07-19 14:15]:
> > > > 
> > > > In latest kernel, we can't use panic_notifier_list if kdump is enabled.
> > > > panic_notifier_list is very useful function for debug, failover, etc...
> > > > 
> > > > So this patch adds a control file /proc/sys/kernel/dump_after_notifier
> > > > and resolves a problem users can not use both kdump and panic_notifier_list
> > > > at the same time.
> > > > 
> > > > kdump_after_notifier = 0
> > > >  -> panic()
> > > >     -> crash_kexec(NULL)
> > > > 
> > > > kdump_after_notifier = 1
> > > >  -> panic()
> > > >     -> atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
> > > >     -> crash_kexec(NULL)
> > > 
> > > What's problematic about this patch? I also would like to see that
> > > feature.
> > 
> > I would like to see the code which will get executed after panic and 
> > before crash_kexec(). This potentially makes crash dump feature unreliable
> > in the sense one can now register on panic_notifier_list and try to
> > do whole lot of things and might get stuck there. After the system
> > has crashed, one is not supposed to do a whole lot.
> 
> Of course, but that's why the patch doesn't change this by default but
> gives the user the choice.
> 

I am skeptical that how many users will really know that whether to set
this option as 1 or 0. Telling them setting it zero is  more reliable as
compared to 1 is kind of vague. What value will distro set it to by default?

Can we be more specific in terms of functionality and code that exactly
what we are trying to do after panic?

Thanks
Vivek

> 
> Thanks,
>    Bernhard
