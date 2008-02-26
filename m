Return-Path: <linux-kernel-owner+w=401wt.eu-S1764675AbYBZXZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764675AbYBZXZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbYBZXZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:25:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:18854 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbYBZXZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:25:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=FZVQhCh+VH19Ds4UL92Nc6ecRGfnjx4e9CP7kfl+xy1H/oesVKSR5V6g7Y5YcyVm2vFwRVAkNDvLXJDRoVCDreXskOKKEt8XJ3EPk81auh9QLsZ1Yhzv06U6UtOovTqKor3ycwNSH6hYAnlTqK0GSO6765j/Xx1tE/teSDQKQXQ=
Date: Wed, 27 Feb 2008 01:22:29 +0200
To: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>
Cc: linux-security-module@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm 0/4] LSM interfaced Audit (SELinux audit separation)
Message-ID: <20080226232229.GA12059@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

This is a beginning of work (started and suggested by Casey Schaufler)
to let Audit be LSM neutral. This is done for proper audit<->SMACK 
integration which will also be useful for any future LSM.

What follows is four patches to remove the following exported 
SElinux interfaces:
selinux_get_inode_sid(inode, sid)
selinux_get_ipc_sid(ipcp, sid) 
selinux_get_task_sid(tsk, sid)
selinux_sid_to_string(sid, ctx, len)

and substitue them respectively with:
new LSM hook, inode_getsecid(inode, secid)
new LSM hook, ipc_getsecid*(ipcp, secid)
LSM hook, task_getsecid(tsk, secid)
LSM hook, sid_to_secctx(sid, ctx, len)

The work isn't complete yet, and those four patches are sent for
an early review. A new LSM interfaces/hooks will be created to
substitute the SELinux exported audit interfaces, thus completing
the separation.

It's worthy to note that those changes can be merged in
their current state. The tree is fully grepped to make sure
that no subsystem ,except the patched ones, will be affected
by this SELinux API breakage.

Diffstat:

 include/linux/security.h   |   23 +++++++++++++++-
 include/linux/selinux.h    |   62 ---------------------------------------------
 kernel/audit.c             |   14 +++++-----
 kernel/auditfilter.c       |    5 ++-
 kernel/auditsc.c           |   37 +++++++++++++-------------
 net/netlink/af_netlink.c   |    3 --
 security/dummy.c           |   16 ++++++++++-
 security/security.c        |   12 ++++++++
 security/selinux/exports.c |   42 ------------------------------
 security/selinux/hooks.c   |   19 ++++++++++++-
 10 files changed, 95 insertions(+), 138 deletions(-)

Thanks in advance for your reviews and comments.

-- 
Ahmed S. Darwish
Blog: http://darwish-07.blogspot.com
Homepage: http://darwish.07.googlepages.com

