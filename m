Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbZIALY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbZIALY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 07:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZIALY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 07:24:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbZIALYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 07:24:25 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com
Subject: [PATCH 0/2] Automatically grab wallclock time updates from hypervisor
Date: Tue,  1 Sep 2009 07:50:46 -0400
Message-Id: <1251805848-17451-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

In this proposed patch, I am introducing a worker fired by kvmclock that updates
guest wallclock periodically to reflect changes in the host's wallclock. With this
patch, a large pool of VMs will no longer have to run NTP in all of its guests.

The worker does that at a configurable interval, with a minimum granularity of 1
second. So, although not exactly cheap, the msr write needed to get an updated
wallclock value won't pose a heavy burden on the system.

It is also possible to disable it completely if this behaviour is undesired for
a specific scenario.

diffstat follows:

 arch/x86/include/asm/kvm_para.h |    6 +++
 arch/x86/kernel/kvmclock.c      |   77 ++++++++++++++++++++++++++++++++++-----
 kernel/sysctl.c                 |   13 +++++++
 3 files changed, 87 insertions(+), 9 deletions(-)

