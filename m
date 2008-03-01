Return-Path: <linux-kernel-owner+w=401wt.eu-S1759743AbYCATvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743AbYCATvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 14:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbYCATvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 14:51:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:54051 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbYCATvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 14:51:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=XgTi+kuzYdyl3pPp81sHpyApyDqFvyebdarA/YNC3gPeFk28U+vpcNlveSaEQYX4FfEqYtIJDC8k+V5PswY4IfxQNzhGR22BhJvY/aUhK3AHFaRMA8cnmkj003jkqNqRsD75iWU5bPegAiPrhUnc3bdaNGD2Tw1rByHUEOaUiAE=
Date: Sat, 1 Mar 2008 21:47:52 +0200
To: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>, Paul Moore <paul.moore@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Audit-ML <linux-audit@redhat.com>,
       LSM-ML <linux-security-module@vger.kernel.org>
Subject: [PATCH-v2 -mm 0/9] LSM-neutral Audit (SELinux audit separation)
Message-ID: <20080301194752.GA19636@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

A series of 9 patches to let Audit be LSM netural. This is done 
for proper future audit<->SMACK integration which will also be
useful for any future LSM.

Basically, patches add below new LSM hooks:

1- secid extraction:
inode_getsecid(inode, secid)
ipc_getsecid(ipcp, secid)

2- LSM-specific Audit rules manipulation:
audit_rule_init(field, op, rulestr, lsmrule)
audit_rule_known(krule)
audit_rule_match(secid, field, op, rule, actx)
audit_rule_free(rule)

and remove ,now redundant, equivalent SELinux exported interfaces.

Initial work and idea by: Casey Schaufler <casey@schaufler-ca.com>
Thanks to Paul Moore <paul.moore@hp.com> for his deep review of first
version.

 include/linux/audit.h            |   29 ++++++++
 include/linux/security.h         |  102 +++++++++++++++++++++++++++++
 include/linux/selinux.h          |  134 ---------------------------------------
 kernel/audit.c                   |   24 ++----
 kernel/audit.h                   |   25 -------
 kernel/auditfilter.c             |   99 ++++++++++------------------
 kernel/auditsc.c                 |   74 +++++++++++----------
 net/netlink/af_netlink.c         |    3 +-
 security/dummy.c                 |   47 +++++++++++++
 security/security.c              |   35 ++++++++++
 security/selinux/exports.c       |   42 ------------
 security/selinux/hooks.c         |   27 +++++++
 security/selinux/include/audit.h |   65 ++++++++++++++++++
 security/selinux/ss/services.c   |   45 +++++++++----
 14 files changed, 420 insertions(+), 331 deletions(-)

Regards,

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

