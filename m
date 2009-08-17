Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbZHQTxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbZHQTxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 15:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756503AbZHQTxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 15:53:09 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:33515 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297AbZHQTxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 15:53:07 -0400
Subject: Re: [Patch 1/2] selinux: ajust rules for ATTR_FORCE
From: Stephen Smalley <sds@tycho.nsa.gov>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       esandeen@redhat.com, eteo@redhat.com, eparis@redhat.com,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
In-Reply-To: <873a7q441a.fsf@devron.myhome.or.jp>
References: <20090817071001.5913.94767.sendpatchset@localhost.localdomain>
	 <20090817071011.5913.69970.sendpatchset@localhost.localdomain>
	 <1250511313.3629.103.camel@moss-pluto.epoch.ncsc.mil>
	 <87prau5ld1.fsf@devron.myhome.or.jp>
	 <1250536052.3629.154.camel@moss-pluto.epoch.ncsc.mil>
	 <873a7q441a.fsf@devron.myhome.or.jp>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 17 Aug 2009 15:56:21 -0400
Message-Id: <1250538981.3629.184.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-18 at 04:46 +0900, OGAWA Hirofumi wrote:
> Stephen Smalley <sds@tycho.nsa.gov> writes:
> 
> >> [I'm still not sure what selinux want to do. normally inode_permission()
> >> should check truncate() permission, and this FILE__SIZE checks something
> >> again...? And we want to check FILE__WRITE for ATTR_[AMC]TIME?]
> >
> > Explicit setting of mode, owner, group, or timestamps is to be checked
> > by the setattr permission, while implicit setting of timestamps or size
> > is mediated by the write permission.
> 
> E.g. mode change has implicit ATTR_CTIME change. So it meant, we should
> check the both of FILE__SETATTR and FILE__WRITE?

No, just setattr.

> > ATTR_FORCE is supposed to suppress permission checking altogether, and
> > shouldn't be mixed with multiple attribute changes if some should be
> > subject to permission checks while others should not.
> 
> I disagree. In fact, ATTR_FORCE is just used for ATTR_KILL_S[UG]ID, and
> notify_change() is disallowing the mixed ATTR_MODE and ATTR_KILL_*. I
> think it should be enough.

Ok, then we just need to adjust selinux_inode_setattr to understand that
ATTR_FORCE only means to bypass checking on ATTR_MODE.

> If ATTR_FORCE is confusable, I think we can just add new ATTR_FORCE_MODE
> or ATTR_FORCE_KILL, and replace with current ATTR_FORCE. I'm ok either
> way.  But, with this change, ATTR_FORCE has no users.

-- 
Stephen Smalley
National Security Agency

