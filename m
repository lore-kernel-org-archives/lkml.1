Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbYKQVGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbYKQVGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbYKQVEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:04:41 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48356 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbYKQVEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:04:37 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zachary Amsden <zach@vmware.com>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 00/12] x86: disable virt on kdump and emergency_restart (v4)
Date: Mon, 17 Nov 2008 19:03:12 -0200
Message-Id: <1226955804-16802-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo,

This is yet another spin of the series to disable vmx on kdump and on
emergency_restart, after some feedback from Avi.

The only change from v3 is that vmx.h and svm.h were moved from
arch/x86/kvm to arch/x86/include/asm, instead of moving code
from those headers to asm/virtext.h.

I haven't tested the SVM changes on AMD CPUs. The changes are really
simple, but some testing is welcome.

This series is against tip.git#master, that already contains the
nmi_shootdown_cpus() changes I've submitted previously.


For reference, this is the history of the patchset:

v1: Implemented the changes using a function pointer registering interface
    where KVM could hook the virt-disable functions
v2: Style fixes
v3: Implemented the changes by moving the virt-disable code from KVM
    to inline functions on asm/virtext.h
v4: Move KVM svm.h and vmx.h to include/asm, instead of moving
    pieces of their contents to asm/virtext.h

-- 
Eduardo
