Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091AbYKFHp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbYKFHp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYKFHpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:45:46 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:41710 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153AbYKFHpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:45:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AksFANMuEklMQWxa/2dsb2JhbACBdcg1g1U
Date: Thu, 6 Nov 2008 02:45:43 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: LTTng 0.51, improved timestamping
Message-ID: <20081106074543.GA18558@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 02:40:36 up 154 days, 12:21,  4 users,  load average: 1.43, 1.01,
	1.14
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

LTTng 0.51 for 2.6.27.4 does the following :

It improves timestamping on architectures with non-synchronized TSCs in
LTTng 0.51. I also now use per-cpu timers to do some time-related stuff
I previously used IPIs for. It involves being more closely tied to the
CPU hotplug callbacks.

I also replaced x86 tsc_sync.c test by LTTng architecture independent
test. (this will be posted separately on LKML for 2.6.28-rc3 tomorrow
along with the "tracer clock" patchset).

The event trap_entry, syscall_entry, irq_entry, softirq entry, exit and
raise now use smaller fields (2 bytes), which should be enough to encode
the IDs for all architectures. This will principally make a difference
with non-aligned tracing for most of those events.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
