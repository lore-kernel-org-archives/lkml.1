Return-Path: <linux-kernel-owner+w=401wt.eu-S1761228AbYDCDx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761228AbYDCDx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 23:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759749AbYDCDxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 23:53:49 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:34505 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759429AbYDCDxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 23:53:48 -0400
Date: Wed, 2 Apr 2008 22:53:47 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Paul Menage <menage@google.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] cgroups: introduce cft->read_seq()
Message-ID: <20080403035347.GB25873@sergelap.austin.ibm.com>
References: <20080403010130.GA20543@sergelap.austin.ibm.com> <47F4378A.2000008@cn.fujitsu.com> <47F440F7.6080308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F440F7.6080308@cn.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Li Zefan (lizf@cn.fujitsu.com):
> Li Zefan wrote:
> > Serge E. Hallyn wrote:
> >> Hi Paul,
> >>
> >> the following (against 2.6.25-rc8-mm1) is a first attempt
> >> at a simple seq_file usage in cgroups.  Comments much
> >> appreciated.
> >>
> >> thanks,
> >> -serge
> >>
> >> >From bd0977a5819dc43866fff325ae1e2726e747e2f4 Mon Sep 17 00:00:00 2001
> >> From: Serge E. Hallyn <serue@us.ibm.com>
> >> Date: Wed, 2 Apr 2008 17:54:21 -0700
> >> Subject: [PATCH 1/1] cgroups: introduce cft->read_seq()
> >>
> >> Introduce a read_seq() helper in cftype, which uses
> >> seq_file to print out lists.  Use it in the devices
> >> cgroup.  Also split devices.allow into two files, so
> >> now devices.deny and devices.allow are the ones to
> >> use to manipulate the whitelist, while devices.list
> >> outputs the cgroup's current whitelist.
> >>
> >> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> >> ---
> >>  include/linux/cgroup.h   |    6 ++++
> >>  kernel/cgroup.c          |   22 ++++++++++++-
> >>  security/device_cgroup.c |   74 ++++++++++++++-------------------------------
> >>  3 files changed, 49 insertions(+), 53 deletions(-)
> >>
> >> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> >> index 2d1d151..feb83dd 100644
> >> --- a/include/linux/cgroup.h
> >> +++ b/include/linux/cgroup.h
> >> @@ -227,6 +227,12 @@ struct cftype {
> >>  	 */
> >>  	int (*read_map) (struct cgroup *cont, struct cftype *cft,
> >>  			 struct cgroup_map_cb *cb);
> >> +	/*
> >> +	 * read_seq() is used for outputting a simple sequence
> >> +	 * using seqfile.
> >> +	 */
> >> +	int (*read_seq) (struct cgroup *cont, struct cftype *cft,
> >> +			 struct seq_file *m);
> >>  
> > 
> > Can't we remove read_map() ?
> > 
> > btw: s/cont/cgrp
> > 
> 
> It seems read_seq() is the general case of read_map(). A read_seq() method can
> produce the output freely, and read_map() strictly produces string->u64 maps.

Right, the memcontroller cgroup is using read_map(), and I seem to recall
it was intended to be of pretty general use so I was going to just
leave it there.

As for s/cont/cgrp I agree but that's for a separate pure renaming
patch.  In the meantime I just wanted to follow the existing style.
I could rebase this patch on top of a renaming patch but that's
definately wrong for just soliciting comments on this being the right
approach.

Thanks for taking a look.

-serge
