Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbYKDOzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbYKDOzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 09:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbYKDOxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 09:53:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60551 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579AbYKDOxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:53:42 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 00/14] x86: disable virt on kdump and emergency_restart
Date: Tue,  4 Nov 2008 12:52:28 -0200
Message-Id: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a new version of the series to disabling virtualization on kdump,
now extended to do the same tricks on emergency_restart() if needed.

This series is against linux-next-20081103.

Patches 01-07 simply move the non-kdump-specific parts
of nmi_shootdown_cpus() to reboot.c, so it can be used by
emergency_restart(). They should be a no-op in relation to existing code.

Patches 08 adds the virt_disable function registering interface, like
the previous series.

Patch 09 hooks emergency_virt_disable() into kdump crash_shutdown code.

Patch 10 hooks emergency_virt_disable() into emergency_restart() using
nmi_shootdown_cpus().

Patches 11-15 change KVM so that it registers a virt_disable function
when loading.

Finally, patch 16 restore the previous reboot=kbd default.

-- 
Eduardo
