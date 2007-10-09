Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454AbXJIXwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbXJIXwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 19:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbXJIXv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 19:51:56 -0400
Received: from namei.org ([69.55.235.186]:45432 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751632AbXJIXv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 19:51:56 -0400
Date: Wed, 10 Oct 2007 09:50:49 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 1/6] SELinux: change Kconfig to use select instead of
 depends
In-Reply-To: <20071009162812.00e80a0c.randy.dunlap@oracle.com>
Message-ID: <Xine.LNX.4.64.0710100937390.20449@us.intercode.com.au>
References: <Xine.LNX.4.64.0710100917010.14862@us.intercode.com.au>
 <Xine.LNX.4.64.0710100918520.14862@us.intercode.com.au>
 <20071009162812.00e80a0c.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2007, Randy Dunlap wrote:

> I doth protest.  Enabling the entire NET subsystem thru a hidden
> select is awful.  Select should be used (sparingly) to enable
> library code only.  If someone wants NET enabled, they should
> enable it overtly, not covertly.

Ok, fair enough.

I've dropped the patch and rebased the branch.  Please pull per:


The following changes since commit bbf25010f1a6b761914430f5fca081ec8c7accd1:
  Linus Torvalds (1):
        Linux 2.6.23

are available in the git repository at:

ssh://master.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git for-linus

Eric Paris (1):
      SELinux: policy selectable handling of unknown classes and perms

KaiGai Kohei (2):
      SELinux: improve performance when AVC misses.
      SELinux: kills warnings in Improve SELinux performance when AVC misses

Yuichi Nakamura (2):
      SELinux: tune avtab to reduce memory usage
      SELinux: Improve read/write performance

 fs/open.c                           |    4 +
 include/linux/security.h            |   18 +++
 security/dummy.c                    |    6 +
 security/selinux/avc.c              |    5 +
 security/selinux/hooks.c            |   53 +++++++-
 security/selinux/include/avc.h      |    2 +
 security/selinux/include/objsec.h   |    2 +
 security/selinux/include/security.h |    2 +
 security/selinux/selinuxfs.c        |   26 ++++
 security/selinux/ss/avtab.c         |   91 ++++++++----
 security/selinux/ss/avtab.h         |   16 ++-
 security/selinux/ss/conditional.c   |    4 +
 security/selinux/ss/ebitmap.c       |  282 +++++++++++++++++++---------------
 security/selinux/ss/ebitmap.h       |   89 +++++++++---
 security/selinux/ss/mls.c           |  156 +++++++++----------
 security/selinux/ss/policydb.c      |   11 +-
 security/selinux/ss/policydb.h      |    8 +
 security/selinux/ss/services.c      |   91 +++++++++---
 18 files changed, 582 insertions(+), 284 deletions(-)
 



-- 
James Morris
<jmorris@namei.org>
