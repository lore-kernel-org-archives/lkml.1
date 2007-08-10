Return-Path: <linux-kernel-owner+w=401wt.eu-S939194AbXHJP6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939194AbXHJP6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 11:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933195AbXHJP6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 11:58:45 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49088 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762545AbXHJP6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 11:58:44 -0400
Message-ID: <46BC8B39.6050202@bull.net>
Date: Fri, 10 Aug 2007 17:58:49 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: kvm-devel <kvm-devel@lists.sourceforge.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2][KVM] guest time accounting
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/08/2007 18:03:45,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/08/2007 18:03:46,
	Serialize complete at 10/08/2007 18:03:46
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The aim of these two patches is to measure the CPU time used by a virtual
machine. All comments are welcome... I'm not sure it's the good way to do that.

[PATCH 1/2] introduce a new field, "guest", in cpustat to store the time used by
the CPU to run virtual CPU. Modify /proc/stat to display this new field.

[PATCH 2/2] modify account_system_time() to add cputime to cpustat->guest if we
are running a VCPU. We add this cputime to  cpustat->user instead of
cpustat->system because this part of KVM code is in fact user code although it
is executed in the kernel. We duplicate VCPU time between guest and user to
allow an unmodified "top(1)" to display correct value. A modified "top(1)" is
able to display good cpu user time and cpu guest time by subtracting cpu guest
time from cpu user time.

Signed-Off-by: Laurent Vivier <Laurent.Vivier@bull.net>
-- 
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth

