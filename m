Return-Path: <linux-kernel-owner+w=401wt.eu-S1762770AbYCFJQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762770AbYCFJQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 04:16:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761773AbYCFJPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 04:15:51 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:14498 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757914AbYCFJPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 04:15:48 -0500
Date: Thu, 6 Mar 2008 12:15:05 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Greg KH <gregkh@suse.de>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Holger Kiehl <Holger.Kiehl@dwd.de>, linux-kernel@vger.kernel.org,
       vatsa@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: sysfs: duplicate filename '74' can not be created
Message-ID: <20080306091505.GC2560@localhost.sw.ru>
References: <20080304160940.GC19059@localhost.sw.ru> <20080304163339.GA11160@linux.vnet.ibm.com> <20080304192435.GA5525@suse.de> <20080305085922.GA8951@linux.vnet.ibm.com> <20080306060038.GA5574@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306060038.GA5574@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 10:00:38PM -0800, Greg KH wrote:
> On Wed, Mar 05, 2008 at 02:29:22PM +0530, Dhaval Giani wrote:
> > On Tue, Mar 04, 2008 at 11:24:36AM -0800, Greg KH wrote:
> > > On Tue, Mar 04, 2008 at 10:03:39PM +0530, Dhaval Giani wrote:
> > > > On Tue, Mar 04, 2008 at 07:09:40PM +0300, Alexey Dobriyan wrote:
> > > > > [Cc'ing /sys/kernel/uids guys]
> > > > > 
> > > > 
> > > > [Also adding gregkh to the cc :)]
> > > > 
> > > > > > Mar  3 13:50:01 helena kernel: sysfs: duplicate filename '74' can not be created
> > > > > > Mar  3 13:50:01 helena kernel: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> > > > > > Mar  3 13:50:01 helena kernel: Pid: 21911, comm: sshd Not tainted 2.6.24.3 #1
> > > 
> > > What kernel version is this?  2.6.24 had lots of "issues" with the uids
> > > code, I'm amazed it worked at all :)
> > > 
> > 
> > :). Seems to be a stable series kernel (2.6.24.3). Can you please tell
> > me some of the issues, so that I can try to go fix it up.
> 
> Ick, there were a lot of them.  Take a look at the changes to
> kernel/user.c (I think that was the file).  A lot of the work was
> reworking it due to the kobject changes, but at the same time lots of
> code was fixed.
> 
> It is a harmless warning, everything should still work properly, right?

The whole existence of uids_mutex should guarantee that duplicate name
can't happen, and that logic with async kobject removal is still in
place. And there was an oops afterwards:
http://marc.info/?l=linux-kernel&m=120455796407423&w=2

