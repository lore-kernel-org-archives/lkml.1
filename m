Return-Path: <linux-kernel-owner+w=401wt.eu-S1758216AbXHTNN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbXHTNN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 09:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbXHTNNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 09:13:17 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39115 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbXHTNNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 09:13:17 -0400
Message-ID: <46C99371.7070705@bull.net>
Date: Mon, 20 Aug 2007 15:13:21 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: [PATCH 0/4] Virtual Machine Time Accounting
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/08/2007 15:18:28,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/08/2007 15:18:30,
	Serialize complete at 20/08/2007 15:18:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The aim of these four patches is to introduce Virtual Machine time accounting.

_Ingo_, as these patches modify files of the scheduler, could you have a look to
them, please ?

[PATCH 1/4] as recent CPUs introduce a third running state, after "user" and
"system", we need a new field, "guest", in cpustat to store the time used by
the CPU to run virtual CPU. Modify /proc/stat to display this new field.

[PATCH 2/4] like for cpustat, introduce the "gtime" (guest time of the task) and
"cgtime" (guest time of the task children) fields for the
tasks. Modify signal_struct and task_struct. Modify /proc/<pid>/stat to display
these new fields.

[PATCH 3/4] modify account_system_time() to add cputime to cpustat->guest if we
are running a VCPU. We add this cputime to  cpustat->user instead of
cpustat->system because this part of KVM code is in fact user code although it
is executed in the kernel. We duplicate VCPU time between guest and user to
allow an unmodified "top(1)" to display correct value. A modified "top(1)" is
able to display good cpu user time and cpu guest time by subtracting cpu guest
time from cpu user time. Update "gtime" and "cgtime" in signal_struct and
task_struct accordingly.

[PATCH 4/4] Modify KVM to update guest time accounting.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
-- 
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth
