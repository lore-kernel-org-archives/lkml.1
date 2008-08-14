Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbYHNNp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbYHNNp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 09:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbYHNNpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:45:17 -0400
Received: from tundra.namei.org ([65.99.196.166]:53855 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbYHNNpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:45:16 -0400
Date: Thu, 14 Aug 2008 23:45:00 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: [GIT] capability fix for 2.6.27
Message-ID: <alpine.LRH.1.10.0808142328260.31210@tundra.namei.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this fix from David Howells:

    Fix the setting of PF_SUPERPRIV by __capable() as it could corrupt the 
    flags the target process if that is not the current process and it is 
    trying to change its own flags in a different way at the same time.

The approach taken involves cleanly separating the way capabilities are 
checked so that capable() now only refers to the current task and assumes 
the capability is about to be used, while has_capability() is used to 
probe generally other tasks without setting PF_SUPERPRIV on those tasks.  
This change is also then reflected in the LSM hooks.


The following changes since commit 8d0968abd03ec6b407df117adc773562386702fa:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../herbert/crypto-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

David Howells (1):
      security: Fix setting of PF_SUPERPRIV by __capable()

 include/linux/capability.h |   15 +++++++++++-
 include/linux/security.h   |   39 ++++++++++++++++++++++------------
 kernel/capability.c        |   21 +++++++++++-------
 kernel/ptrace.c            |    5 +--
 mm/oom_kill.c              |    6 +++-
 security/capability.c      |    3 +-
 security/commoncap.c       |   24 +++++++++++++++------
 security/root_plug.c       |    3 +-
 security/security.c        |   10 ++++++--
 security/selinux/hooks.c   |   25 ++++++++++++++++------
 security/smack/smack_lsm.c |   49 ++++++++++++++++++++++++++++++-------------
 11 files changed, 137 insertions(+), 63 deletions(-)


-- 
James Morris
<jmorris@namei.org>
