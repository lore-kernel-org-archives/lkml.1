Return-Path: <linux-kernel-owner+w=401wt.eu-S1759456AbZHRR0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbZHRR0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 13:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759406AbZHRR0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 13:26:50 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:39231 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbZHRR0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 13:26:50 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Amerigo Wang <amwang@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org,
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
	<87fxbq19qs.fsf@devron.myhome.or.jp>
	<87my5yxidt.fsf@devron.myhome.or.jp>
	<87y6pha7vv.fsf@devron.myhome.or.jp>
Date: Wed, 19 Aug 2009 02:26:47 +0900
In-Reply-To: <87y6pha7vv.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Tue, 18 Aug 2009 16:39:00 +0900")
Message-ID: <87ljlh119k.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[My ISP still seems to be stopping email server :-/]

>>> So if I read this correctly, (ATTR_FORCE| ATTR_KILL_SUID|ATTR_MODE) will 
>>> not return here, since 'ia_valid' will be ATTR_FORCE finally.
>>> 
>>> I think you forgot to clear ATTR_FORCE here...
>> 
>> Whoops, good catch. Fortunately, it doesn't seem to have actual problem,
>> but it's bug obviously, and sorry for that. Fixed patch was attached.
> 
> You can add my:
> Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>

Thanks.

Amerigo, could you handle that patch with his ack for the remaining work?

BTW, I think [Patch 2/2] of

-	newattrs.ia_valid |= should_remove_suid(dentry);
+	ret = should_remove_suid(dentry);
+	newattrs.ia_valid |= ret;
+	if (ret)
+		newattrs.ia_valid |= ATTR_FORCE;

should be

	killsuid = should_remove_suid(dentry);
	if (killsuid)
		newattrs.ia_valid |= killsuid | ATTR_FORCE;

or something (someone pointed out it) on earlier thread, IIRC.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
