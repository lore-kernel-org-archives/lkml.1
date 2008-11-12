Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbYKLNgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbYKLNgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 08:36:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYKLNfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 08:35:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45161 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbYKLNfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 08:35:45 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 0/8] Make nmi_shootdown_cpus() usable by non-kdump code
Date: Wed, 12 Nov 2008 11:34:36 -0200
Message-Id: <1226496884-24628-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo,

As tip/master is a moving target, I am splitting the previous kdump/reboot
virtualization-disable code series[1] into smaller series so the simpler
parts can be included sooner. This first series is just for making
nmi_shootdown_cpus() usable by non-kdump code, by moving their generic
parts to reboot.c.

They are exactly the same patches I've sent as 01-08 in the previous
series.

The NMI IPIs method used by nmi_shootdown_cpus() is the only way
we can make sure VMX is disabled on all CPUs before rebooting, on
emergency_restart(), because CPUs may have IRQs disabled. That's why I
will reuse nmi_shootdown_cpus() for the emergency_restart code when
VMX is enabled.

The virtualization-specific parts should come soon, after I implement
the suggestions by Eric and Avi, by making the virtualization-disabling
functions inline so they can be used directly by the core code (instead
of using the function pointer tricks from my previous series).

[1] http://marc.info/?l=linux-kernel&m=122591590923455&w=2

-- 
Eduardo
