Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbZBGAfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbZBGAfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 19:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbZBGAfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 19:35:36 -0500
Received: from gw.goop.org ([64.81.55.164]:55384 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbZBGAff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 19:35:35 -0500
Message-ID: <498CD755.5030301@goop.org>
Date: Fri, 06 Feb 2009 16:35:33 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] x86/xen: Use xen-specific path for interrupt delivery
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than mapping event channels to vectors and then using the 
vector->irq mapping for interrupt delivery, just cut out the middleman 
and directly map event channels to irqs.  This allows for some more 
cleanups in the event handling code.

The following changes since commit 637f52a7cc5b3ae22354b7e45397375a17d626af:
  Jeremy Fitzhardinge (1):
        x86: unify do_IRQ()

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git jsgf/xen/irq

Jeremy Fitzhardinge (5):
      xen: set irq_chip disable
      xen: use our own eventchannel->irq path
      xen: pack all irq-related info together
      xen: remove irq bindcount
      xen: make sure that softirqs get handled at the end of event processing

 arch/x86/include/asm/xen/events.h |    6 -
 arch/x86/xen/irq.c                |   17 +---
 drivers/xen/events.c              |  224 +++++++++++++++++++++++++------------
 3 files changed, 155 insertions(+), 92 deletions(-)


