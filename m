Return-Path: <linux-kernel-owner+w=401wt.eu-S937336AbZAPTN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937336AbZAPTN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 14:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937144AbZAPTLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 14:11:16 -0500
Received: from relay2.sgi.com ([192.48.179.30]:35261 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765969AbZAPTLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 14:11:10 -0500
Message-Id: <20090116191108.135927000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 16 Jan 2009 11:11:08 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>, Dave Jones <davej@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] cpu freq: fix problems with work_on_cpu usage in acpi-cpufreq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This set of patches improves the work_on_cpu() function to
eliminate circular lock dependencies from occurring by requiring
the caller to insure the cpu does not go offline.  This effectively
models the previous behaviour using set_cpus_allowed().

The other fix is to use a separate work queue for work_on_cpu so
it does not clash with kevent items that might already be on the
queue from the same caller.

This fixes the boot up and suspend/resume to disk problems previously
seen.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Dieter Ries <clip2@gmx.de>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: <cpufreq@vger.kernel.org>

-- 
