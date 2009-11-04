Return-Path: <linux-kernel-owner+w=401wt.eu-S933115AbZKDXoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbZKDXoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 18:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758018AbZKDXoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 18:44:23 -0500
Received: from claw.goop.org ([74.207.240.146]:60225 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757974AbZKDXoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 18:44:22 -0500
Message-ID: <4AF211DB.605@goop.org>
Date: Wed, 04 Nov 2009 15:44:27 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Stable Kernel <stable@kernel.org>
Subject: [GIT PULL] A couple of Xen bugfixes
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's a couple of Xen bugfixes:

    * Suppress the extended topology leaf in cpuid; such details are
      meaningless in a virtual cpu
    * Make hvc_xen poll when the output buffer is full rather than
      depend on a workqueue to do it.  Otherwise we can lose oops info
      on crashes when scheduling has been disabled.

Thanks,
    J

The following changes since commit 973df35ed9ff7806403e793a2ad7e9bd4c2fd2a9:
  Jeremy Fitzhardinge (1):
        xen: set up mmu_ops before trying to set any ptes

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git bugfix

Jeremy Fitzhardinge (2):
      xen/hvc: make sure console output is always emitted, with explicit polling
      xen: mask extended topology info in cpuid

 arch/x86/xen/enlighten.c |   11 ++++++++++-
 drivers/char/hvc_xen.c   |   25 ++++++++++++++++++++++++-
 2 files changed, 34 insertions(+), 2 deletions(-)



