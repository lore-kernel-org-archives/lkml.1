Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbZHQTE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbZHQTE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 15:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbZHQTE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 15:04:58 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:41986 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZHQTE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 15:04:58 -0400
Subject: Re: [Patch 1/2] selinux: ajust rules for ATTR_FORCE
From: Stephen Smalley <sds@tycho.nsa.gov>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       esandeen@redhat.com, eteo@redhat.com, eparis@redhat.com,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
In-Reply-To: <87prau5ld1.fsf@devron.myhome.or.jp>
References: <20090817071001.5913.94767.sendpatchset@localhost.localdomain>
	 <20090817071011.5913.69970.sendpatchset@localhost.localdomain>
	 <1250511313.3629.103.camel@moss-pluto.epoch.ncsc.mil>
	 <87prau5ld1.fsf@devron.myhome.or.jp>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 17 Aug 2009 15:07:32 -0400
Message-Id: <1250536052.3629.154.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-18 at 03:46 +0900, OGAWA Hirofumi wrote:
> Stephen Smalley <sds@tycho.nsa.gov> writes:
> 
> > On Mon, 2009-08-17 at 03:07 -0400, Amerigo Wang wrote:
> >> As suggested by OGAWA Hirofumi in thread: http://lkml.org/lkml/2009/8/7/132,
> >> we should let selinux_inode_setattr() to match our ATTR_* rules.
> >> ATTR_FORCE should not force things like ATTR_SIZE.
> 
> [...]
> 
> >
> > This will only apply the setattr check if ATTR_FORCE was specified,
> > which is not the current behavior nor what we want.
> >
> > NAK.
> 
> How about this? I tweaked Amerigo's patch, and it is based on the
> original code is doing. This is only compile-test though.
> 
> [I'm still not sure what selinux want to do. normally inode_permission()
> should check truncate() permission, and this FILE__SIZE checks something
> again...? And we want to check FILE__WRITE for ATTR_[AMC]TIME?]

Explicit setting of mode, owner, group, or timestamps is to be checked
by the setattr permission, while implicit setting of timestamps or size
is mediated by the write permission.  Permission needs to be revalidated
on use to address potential file relabeling or policy change.
ATTR_FORCE is supposed to suppress permission checking altogether, and
shouldn't be mixed with multiple attribute changes if some should be
subject to permission checks while others should not.

-- 
Stephen Smalley
National Security Agency

