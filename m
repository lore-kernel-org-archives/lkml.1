Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbYFMSBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbYFMSBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 14:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbYFMSBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 14:01:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbYFMSBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 14:01:33 -0400
Date: Fri, 13 Jun 2008 14:00:59 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm 1/2] kexec jump -v11: kexec jump
Message-ID: <20080613180059.GA4906@redhat.com>
References: <1213082104.22608.29.camel@caritas-dev.intel.com> <20080612192015.GH9654@redhat.com> <1213319040.20431.8.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213319040.20431.8.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 09:04:00AM +0800, Huang, Ying wrote:
> On Thu, 2008-06-12 at 15:20 -0400, Vivek Goyal wrote:
> > On Tue, Jun 10, 2008 at 03:15:04PM +0800, Huang, Ying wrote:
> > > This patch provides an enhancement to kexec/kdump. It implements
> > > the following features:
> > > 
> > > - Backup/restore memory used by the original kernel before/after
> > >   kexec.
> > > 
> > > - Save/restore CPU state before/after kexec.
> > > 
> > > The features of this patch can be used as a general method to call
> > > program in physical mode (paging turning off). This can be used to
> > > call BIOS code under Linux.
> > > 
> > > 
> > 
> > Hi Huang,
> > 
> > I was testing these patches and I get following error on my machine.
> > 
> > Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> > Suspending console(s) (use no_console_suspend to debug)
> > PM: Device i8042 failed to freeze: error -22
> > Restarting tasks ... done.
> > 
> > Any idea why keyboard controller would not freeze?
> 
> Which kernel version do you use?
> 

2.6.26-rc5-mm1.

> Does original hibernation work? It can be setup easily. Just add
> following parameters to kernel command line:
> 

Ok, I found that in my config CONFIG_HIBERNATION was not enabled. After
enabling CONFIG_HIBERNATION, both suspend to disk and kjump started
working.

Does that mean there is some dependency on code under CONFIG_HIBERNATION.
If yes, I think this dependency should be resolved during compile time.
May be addtional config option (CONFIG_KEXEC_JUMP), which also selects
the CONFIG_HIBERNATION automatically etc...

Thanks
Vivek
