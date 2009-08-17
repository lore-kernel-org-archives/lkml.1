Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbZHQUL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbZHQUL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 16:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbZHQUL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 16:11:26 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:57351 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbZHQULZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 16:11:25 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       esandeen@redhat.com, eteo@redhat.com, eparis@redhat.com,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: [Patch 1/2] selinux: ajust rules for ATTR_FORCE
References: <20090817071001.5913.94767.sendpatchset@localhost.localdomain>
	<20090817071011.5913.69970.sendpatchset@localhost.localdomain>
	<1250511313.3629.103.camel@moss-pluto.epoch.ncsc.mil>
	<87prau5ld1.fsf@devron.myhome.or.jp>
	<1250536052.3629.154.camel@moss-pluto.epoch.ncsc.mil>
	<873a7q441a.fsf@devron.myhome.or.jp>
	<1250538981.3629.184.camel@moss-pluto.epoch.ncsc.mil>
Date: Tue, 18 Aug 2009 05:11:23 +0900
In-Reply-To: <1250538981.3629.184.camel@moss-pluto.epoch.ncsc.mil> (Stephen
	Smalley's message of "Mon, 17 Aug 2009 15:56:21 -0400")
Message-ID: <87fxbq19qs.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> writes:

>> E.g. mode change has implicit ATTR_CTIME change. So it meant, we should
>> check the both of FILE__SETATTR and FILE__WRITE?
>
> No, just setattr.

Ok.

>> > ATTR_FORCE is supposed to suppress permission checking altogether, and
>> > shouldn't be mixed with multiple attribute changes if some should be
>> > subject to permission checks while others should not.
>> 
>> I disagree. In fact, ATTR_FORCE is just used for ATTR_KILL_S[UG]ID, and
>> notify_change() is disallowing the mixed ATTR_MODE and ATTR_KILL_*. I
>> think it should be enough.
>
> Ok, then we just need to adjust selinux_inode_setattr to understand that
> ATTR_FORCE only means to bypass checking on ATTR_MODE.

Ok, sure. I'll try it.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
