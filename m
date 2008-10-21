Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbYJUSEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbYJUSEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 14:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYJUSDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 14:03:55 -0400
Received: from lazybastard.de ([212.112.238.170]:47985 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbYJUSDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 14:03:54 -0400
Date: Tue, 21 Oct 2008 20:03:41 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>, akpm@linux-foundation.org,
       linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, tim.bird@am.sony.com
Subject: Re: Subject: [PATCH 01/16] Squashfs: inode operations
Message-ID: <20081021180340.GA11588@logfs.org>
References: <E1KqrTW-0001xC-9M@dylan> <20081017165300.GA8076@logfs.org> <1224605666.31157.71.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1224605666.31157.71.camel@moss-terrapins.epoch.ncsc.mil>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 October 2008 12:14:26 -0400, David P. Quigley wrote:
> On Fri, 2008-10-17 at 18:53 +0200, Jörn Engel wrote:
> > None of the comments below are a reason against mainline inclusion, imo.
> > They should get handled, but whether that happens before or after a
> > merge doesn't really matter.
> > 
> > On Fri, 17 October 2008 16:42:50 +0100, Phillip Lougher wrote:
> > > 
> > > +#include <linux/squashfs_fs.h>
> > > +#include <linux/squashfs_fs_sb.h>
> > > +#include <linux/squashfs_fs_i.h>
> > 
> > Current verdict seems to be that these files should live in fs/squashfs/,
> > not include/linux/.  No kernel code beside squashfs needs the headers
> > and userspace tools should have a private copy.
> > 
> [Snip]
> 
> I looked at where filesystems such as ext3 store these and it seems to
> be in include/linux. I'm assuming this is because usespace utilities
> like fsck need them. It seems wrong for userspace tools to have their
> own private copy since you can potentially have them out of sync with
> the kernel you are running and it provides more chance for you
> forgetting to update a structure somewhere. 

Existing headers remain where they are.  New headers are supposed to
go... or at least that's what I was told to do.

And being out of sync is definitely not an argument you can use with a
filesystem.  The data on your disk doesn't magically change when you
upgrade a kernel.  Nor can you assume that any given filesystem is
accessed only by Linux.  If you change the format, then locating
external copies of the header will be the least of your problems.

Jörn

-- 
Do not stop an army on its way home.
-- Sun Tzu
