Return-Path: <linux-kernel-owner+w=401wt.eu-S933260AbXIJPzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260AbXIJPzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 11:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932942AbXIJPzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 11:55:38 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:18111 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940AbXIJPzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 11:55:37 -0400
Date: Mon, 10 Sep 2007 08:53:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND 2][PATCH 3/4] modify account_system_time() to update
 guest time in cpustat and task_struct
Message-Id: <20070910085331.84dc1fb5.randy.dunlap@oracle.com>
In-Reply-To: <46E550EA.1030809@bull.net>
References: <46E550EA.1030809@bull.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 16:12:58 +0200 Laurent Vivier wrote:

> [PATCH 3/4] modify account_system_time() to add cputime to cpustat->guest if we
> are running a VCPU. We add this cputime to  cpustat->user instead of
> cpustat->system because this part of KVM code is in fact user code although it
> is executed in the kernel. We duplicate VCPU time between guest and user to
> allow an unmodified "top(1)" to display correct value. A modified "top(1)" is
> able to display good cpu user time and cpu guest time by subtracting cpu guest
> time from cpu user time. Update "gtime" in task_struct accordingly.
> 
> Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>


Hi,
Please use kernel-doc notation here:
(see Documentation/kernel-doc-nano-HOWTO.txt or source file examples
or ask)

easy fix:

 /*
+ * Account guest cpu time to a process.

/**
 * account_guest_time - Account guest cpu time to a process.

+ * @p: the process that the cpu time gets accounted to
+ * @cputime: the cpu time spent in virtual machine since the last update
+ */
+void account_guest_time(struct task_struct *p, cputime_t cputime)
+{

Thanks.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
