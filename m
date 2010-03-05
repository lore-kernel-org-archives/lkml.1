Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab0CEQxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:53:19 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:52168 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab0CEQxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:53:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=CJk5NFK8c1Th5dqo8z5McUlArxyQhk4ldfvc+fKPehECmHQCIsrYsuBw2UszO2dy0r
         NlrxwMxaBRQjbnIUk6ZjYnScE9ChS43JWTml4PsEzu2XYv+ZPYMONMPtHUuf3+uq97RF
         WJs2MXhGeUCjyk2r42JVZ2BfcN6ZV4ly0Rogg=
Message-ID: <4B9136F4.4010007@gmail.com>
Date: Fri, 05 Mar 2010 17:53:08 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-11.2 Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>,
       Oleg Nesterov <oleg@redhat.com>
Subject: [git pull] pull request for writable limits for 2.6.34-rc0
References: <4B1D32D1.4090404@gmail.com>
In-Reply-To: <4B1D32D1.4090404@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

please pull the writable limits tree below.

I'm not sure why you didn't pull it in the .33 window. I just guess
there was no reasoning about why you would do so. So, what are the
writable limits good for and why we are about to ship it in the next
Suse enterprise?

Conceivably, there are companies out there (such as SAP) running their
large-scale products on Linux and eventually they need to change a limit
without restarting the service. It is because restarting is not an
option most of the time. The limits are needed to be changed usually
because (a) it is not known in advance that some limits will need to
have a different value; (b) some processes start to crash occasionally.
In both cases the only necessity is just to change the particular limit
(core size in case of (b)) in runtime.

Hence we provide the functionality in the tree below. Opposing to the
last merge, most of the cleanup stuff was already merged by respective
maintainers into their trees rather than being here and are on the way
to you. They are independent of this merge and just ensure that future
compiler releases won't do weird things with the code.

---
The following changes since commit 64ba9926759792cf7b95f823402e2781edd1b5d4:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.open-osd.org/linux-open-osd

are available in the git repository at:

  git://decibel.fi.muni.cz/~xslaby/linux writable_limits

Jiri Slaby (13):
      SECURITY: add task_struct to setrlimit
      core: add task_struct to update_rlimit_cpu
      core: split sys_setrlimit
      core: allow setrlimit to non-current tasks
      core: optimize setrlimit for current task
      FS: proc, switch limits reading to fops
      FS: proc, make limits writable
      core: do security check under task_lock
      core: implement getprlimit and setprlimit syscalls
      compat: use do_setrlimit in compat_sys_setrlimit
      COMPAT: add get/put_compat_rlimit
      x86: add ia32 compat prlimit syscalls
      Documentation: fs/proc, add limits documentation

Neil Horman (1):
      unistd: add __NR_[get|set]prlimit syscall numbers

Oleg Nesterov (1):
      sys_setrlimit: make sure ->rlim_max never grows

 Documentation/filesystems/proc.txt |   11 +++
 arch/x86/ia32/ia32entry.S          |    2 +
 arch/x86/include/asm/unistd_32.h   |    4 +-
 arch/x86/include/asm/unistd_64.h   |    4 +
 arch/x86/kernel/syscall_table_32.S |    2 +
 fs/proc/base.c                     |  101 ++++++++++++++++++++++--
 include/asm-generic/unistd.h       |    6 +-
 include/linux/posix-timers.h       |    2 +-
 include/linux/resource.h           |    2 +
 include/linux/security.h           |    9 ++-
 include/linux/syscalls.h           |    4 +
 kernel/compat.c                    |   98 +++++++++++++++++-------
 kernel/posix-cpu-timers.c          |   10 +-
 kernel/sys.c                       |  151
++++++++++++++++++++++++++++++------
 security/capability.c              |    3 +-
 security/security.c                |    5 +-
 security/selinux/hooks.c           |   10 ++-
 17 files changed, 346 insertions(+), 78 deletions(-)

thanks,
-- 
js
