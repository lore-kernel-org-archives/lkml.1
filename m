Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbYKEUDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbYKEUDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756398AbYKET6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:58:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41433 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553AbYKET6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:58:07 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 00/15] x86: disable virt on kdump and emergency_restart (v2)
Date: Wed,  5 Nov 2008 17:56:43 -0200
Message-Id: <1225915018-6548-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is an updated version of the reboot/kdump virtualization disable
series that I've sent previously.

In short, the x86 and kdump changes are the same as before, except for
EXPORT_SYMBOL_GPL, and the KVM parts are completely different.

Details of changes since the previous series:

- Style fixes suggested by checkpatch
- Added local_irq_disable() to nmi_shootdown_cpus() (patch 08)
- Use EXPORT_SYMBOL_GPL() on set_virt_disable_func() &
  clear_virt_disable_func()
- Add comments to source code on places where emergency_virt_disable()
  is called, explaining why.
- kvm: Move the set_virt_disable_func() call to vmx.c and svm.c.
  This made the patch series shorter and removing one level
  of abstraction.

This series is against linux-next-20081105.

Patches 01-07 simply move the non-kdump-specific parts
of nmi_shootdown_cpus() to reboot.c, so it can be used by
emergency_restart(). They should be a no-op in relation to existing code.

Patch 08 adds an additional local_irq_disable() to nmi_shootdown_cpus(),
in case it is called with IRQs enabled.

Patch 09 adds the virt_disable function registering interface, like
the previous series.

Patch 10 hooks emergency_virt_disable() into kdump crash_shutdown code.

Patch 11 hooks emergency_virt_disable() into emergency_restart() using
nmi_shootdown_cpus().

Patches 12-14 change KVM so that it registers a virt_disable function
when loading.

Finally, patch 15 restore the previous reboot=kbd default.

-- 
Eduardo
