Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbYJUJ7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbYJUJ7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 05:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbYJUJ7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 05:59:04 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:41225 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbYJUJ7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 05:59:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=wtbFCi+JH6yMSmk5SvH79De1qo8rY0fkwIJDz27mSwPfmdI4K1OAllLfJznX8BMVGD
         Tj9NwQNzAWgzm6pF6rLySuxxUtUzdYeoMSpX5cgt9fPCIOxIdSfvr2MK8BxfCY8Oud3Z
         gmBvfs6Qd16iRTuWiBVATybzkK7rfT/Po68E4=
Message-ID: <c4e36d110810210259o38897783i2dc4bcb59e8d32e7@mail.gmail.com>
Date: Tue, 21 Oct 2008 11:59:00 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Scheduler on C2D CPU and latest 2.6.27 kernel
Cc: "Ingo Molnar" <mingo@redhat.com>, "Peter Zijlstra" <pzijlstr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Recently I'm noticing bad behavior of the CPU scheduler on my T61 (2GB, C2D)

It looks like Linux concentrates all running tasks on one CPU and the
second cpu is sleeping.

With recent changes to DRI - glxgears went up to 840FPS but also takes
100% (with Xorg) and when I run 'while :; do true; done' loop in
parallel frame rate drops to 300FPS.

But as I have C2D CPU I would expect that there should be no such
dramatic slowdown.

Xosview shows that only one CPU is fully loaded.

Here are my .config scheduler options:

CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
CONFIG_SCHED_HRTICK=y
# CONFIG_NET_SCHED is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_SCHED_TRACER=y


Am I missing something?


Zdenek
