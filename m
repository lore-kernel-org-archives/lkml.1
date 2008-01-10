Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbYAJDR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbYAJDR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 22:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbYAJDRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 22:17:47 -0500
Received: from ns1.suse.de ([195.135.220.2]:45310 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbYAJDRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 22:17:46 -0500
Date: Wed, 9 Jan 2008 16:05:31 -0800
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, vatsa@linux.vnet.ibm.com,
       LKML <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, dmitry.adamushko@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/11] sched: rt-group: uid-group interface
Message-ID: <20080110000531.GA18069@suse.de>
References: <20080106161128.152634000@chello.nl> <1199703080.7143.24.camel@twins> <20080107122330.GB25945@linux.vnet.ibm.com> <1199725063.31975.53.camel@lappy> <20080108105733.GA2569@linux.vnet.ibm.com> <1199790150.7143.57.camel@twins> <3ae72650801080631p2b2c50a6q3d59badf06b62684@mail.gmail.com> <1199835332.31975.66.camel@lappy> <20080108235846.GA17067@suse.de> <20080108235750.GA27248@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108235750.GA27248@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 12:57:50AM +0100, Ingo Molnar wrote:
> 
> * Greg KH <gregkh@suse.de> wrote:
> 
> > On Wed, Jan 09, 2008 at 12:35:32AM +0100, Peter Zijlstra wrote:
> > > 
> > > On Tue, 2008-01-08 at 15:31 +0100, Kay Sievers wrote:
> > > > On Jan 8, 2008 12:02 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > > >
> > > > > On Tue, 2008-01-08 at 16:27 +0530, Dhaval Giani wrote:
> > > > > > On Mon, Jan 07, 2008 at 05:57:42PM +0100, Peter Zijlstra wrote:
> > > > > > >
> > > > > > > Subject: sched: rt-group: add uid-group interface
> > > > > > >
> > > > > > > Extend the /sys/kernel/uids/<uid>/ interface to allow setting
> > > > > > > the group's rt_period and rt_runtime.
> > > > > > >
> > > > > >
> > > > > > Hi Peter,
> > > > > >
> > > > > > Cool stuff! I will try out these patches and try to give you some
> > > > > > feedback.
> > > > >
> > > > > Thanks, much appreciated!
> > > > >
> > > > > > One request though, could you please add some documentation to
> > > > > > Documentation/ABI/testing/sysfs-kernel-uids?
> > > > >
> > > > > I already have documentation on the todo list, I'll add this file to
> > > > > that list :-)
> > > > 
> > > > Care to rebase the patch against -mm, we fixed the mixed-up usage
> > > > of ksets and kobjects, and this can not apply anymore:
> > > >   http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob;f=driver/struct-user_info-sysfs.patch;hb=HEAD
> > > > 
> > > > There is also an attribute group now which makes it much easier to add
> > > > new files.
> > > 
> > > Ingo, Greg,
> > > 
> > > What would be the easiest way to carry this forward? sched-devel and
> > > greg's tree would intersect at this point and leave poor akpm with the
> > > resulting mess. Should I just make an incremental patch akpm can carry
> > > and push? Or can we base one tree off the other?
> > 
> > If it's just a single patch for this, I'd be glad to take it.  But by 
> > looking at the [11/12] above, I doubt this is so...
> > 
> > If it's not that rough (12 patches is not a big deal), I'd be glad to 
> > take these through my tree, after you fix up Kay's requests above :)
> 
> hm, i'd really like to see this tested and go through sched.git. It's 
> only the few sysfs bits which interfere, right?

Yes, that should be it.

So why not put the majority of this through sched.git, then when my
sysfs changes go in at the beginning of the .25 merge cycle, you can
then add the sysfs changes through your tree or anywhere else.

Unless you are relying on the sysfs changes for this whole feature, and
without them it just doesn't make any sense at all?

thanks,

greg k-h
