Return-Path: <linux-kernel-owner+w=401wt.eu-S1764670AbXHPP5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764670AbXHPP5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 11:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759322AbXHPP5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 11:57:31 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56746 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796AbXHPP53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 11:57:29 -0400
Message-ID: <46C473EC.8000309@bull.net>
Date: Thu, 16 Aug 2007 17:57:32 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: kvm-devel@lists.sourceforge.net
Cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH/RFC 0/4]Virtual Machine time accounting
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 16/08/2007 18:02:36,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 16/08/2007 18:02:38,
	Serialize complete at 16/08/2007 18:02:38
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The aim of these four patches is to introduce Virtual Machine time accounting.

[PATCH 1/4] as modern CPUs introduce a third running state, after "user" and
"system", we need a new field, "guest", in cpustat to store the time used by
the CPU to run virtual CPU. Modify /proc/stat to display this new field.

[PATCH 2/4] like for cpustat, introduce the "guest" and "cguest" fields for the
tasks. Modify signal_struct and task_struct. Modify /proc/<pid>/stat to display
these new field

[PATCH 3/3] introduce "account modifiers" mechanism in the kernel allowing a
module to modify the collected accounting for a given task. This implementation
is based on the "preempt_notifier". "account_system_time()" and
"account_user_time()" can call functions registered by a module to modify the
cputime value.

[PATCH 4/4] Modify KVM to use the "account modifiers". KVM can now measure time
consumed by a Virtual Machine on a per-cpu basis and modify kernel statistics to
report this value.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
-- 
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth

