Return-Path: <linux-kernel-owner+w=401wt.eu-S1761004AbYHFPqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761004AbYHFPqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030217AbYHFPl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:41:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030211AbYHFPlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:41:55 -0400
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
	for on access scanning
From: Eric Paris <eparis@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: tvrtko.ursulin@sophos.com, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net
In-Reply-To: <20080806152555.GD13996@kroah.com>
References: <20080805201535.GC27192@kroah.com>
	 <20080806093800.1428B316899@pmx1.sophos.com>
	 <20080806152555.GD13996@kroah.com>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 11:41:47 -0400
Message-Id: <1218037307.27684.248.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 08:25 -0700, Greg KH wrote:
> On Wed, Aug 06, 2008 at 10:37:06AM +0100, tvrtko.ursulin@sophos.com wrote:
> > Greg KH wrote on 05/08/2008 21:15:35:
> > 
> > > > > > Perf win, why bothering looking for malware in /proc when it can't
> > > > > > exist?  It doesn't take longer it just takes time having to do
> > > > > > 
> > > > > > userspace -> kernel -> userspace -> kernel -> userspace
> > > > > > 
> > > > > > just to cat /proc/mounts, all of this could probably be alliviated 
> > if we
> > > > > > cached access on non block backed files but then we have to come 
> > up with
> > > > > > a way to exclude only nfs/cifs.  I'd rather list the FSs that 
> > don't need
> > > > > > scanning every time than those that do....
> > > > > 
> > > > > How long does this whole process take?  Seriously is it worth the 
> > added
> > > > > kernel code for something that is not measurable?
> > > > 
> > > > Is it worth having 2 context switches for every open when none are
> > > > needed?  I plan to get numbers on that.
> > > 
> > > Compared to the real time it takes in the "virus engine"?  I bet it's
> > > totally lost in the noise.  Those things are huge beasts with thousands
> > > to hundreds of thousands of context switches.
> > 
> > No, because we are talking about a case here where we don't want to do any 
> > scanning. We want to detect if it is procfs (for example) as quickly as 
> > possible and don't do anything. Same goes for any other filesystem where 
> > it is not possible to store arbitrary user data.
> 
> See previous messages about namespaces and paths for trying to figure this
> kind of information out in a sane way within the kernel.

Didn't I already go over this?  The patch for FS exclusions would not be
namespace based, rather  dentry->d_inode->i_sb->fstype->name matching.

Lets not start name based discussions at this point in time.  Those
patches weren't proposed on this go and reading the write up of both of
the name based items (I think number 11 and 12) one I outright reject
and the other will require future discussion.

-Eric

