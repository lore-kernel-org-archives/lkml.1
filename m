Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbZDUOQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbZDUOQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZDUOQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:16:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49979 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbZDUOQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:16:21 -0400
Date: Tue, 21 Apr 2009 10:16:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, nauman@google.com,
       fernando@oss.ntt.co.jp, linux-kernel@vger.kernel.org, jmoyer@redhat.com,
       jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com
Subject: Re: dm-ioband: Test results.
Message-ID: <20090421141607.GA22619@redhat.com>
References: <20090420.172959.193682665.ryov@valinux.co.jp> <e98e18940904200207y62eca680t7cf938049375f4b3@mail.gmail.com> <20090421.210614.112619728.ryov@valinux.co.jp> <20090421.211051.183023683.ryov@valinux.co.jp> <20090421135723.GA13953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421135723.GA13953@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 09:57:23AM -0400, Mike Snitzer wrote:
> On Tue, Apr 21 2009 at  8:10am -0400,
> Ryo Tsuruta <ryov@valinux.co.jp> wrote:
> 
> > Hi Nauman,
> > 
> > > > The real question is, once you create a version of dm-ioband that
> > > > co-operates with CFQ scheduler, how that solution would compare with
> > > > the patch set Vivek has posted? In my opinion, we need to converge to
> > > > one solution as soon as possible, so that we can work on it together
> > > > to refine and test it.
> > > 
> > > I think I can do some help for your work. but I want to continue the
> > > development of dm-ioband, because dm-ioband actually works well and
> > > I think it has some advantages against other IO controllers.
> > >   - It can use without cgroup.
> > >   - It can control bandwidth on a per partition basis.
> > >   - The driver module can be replaced without stopping the system.
> > 
> > In addition, dm-ioband can run on the RHEL5.
> 
> RHEL5 compatibility does not matter relative to merging an I/O bandwidth
> controller upstream.  So both the "can [be] use without cgroup" and "can
> run on RHEL5" features do not help your cause of getting dm-ioband
> merged upstream.  In fact these features serve as distractions.

Exactly. I don't think that "it can be used without cgroup" is a feature
or advantage. To me it is a disadvantage and should be fixed. cgroup is
standard mechanism to group tasks arbitrarily and we should use that to make
things working instead of coming up with own ways of grouping things and
terming it as advantage.

What do you mean by "The driver module can be replaced without stopping
the system"? I guess you mean that one does not have to reboot the system
to remove ioband device? So if one decides to not use the cgroup, then
one shall have to remove the ioband devices, remount the filesystems and
restart the application?

With cgroup approach, if one does not want things to be classified, a user
can simply move all the tasks to root group and things will be fine. No
remounting, no application stopping etc. So this also does not look like
an advantage instead sounds like an disadvantage.

Thanks
Vivek
