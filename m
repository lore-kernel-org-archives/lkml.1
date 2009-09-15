Return-Path: <linux-kernel-owner+w=401wt.eu-S1758659AbZIOTyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659AbZIOTyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758058AbZIOTym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:54:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59571 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050AbZIOTym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:54:42 -0400
Subject: [BUG] compile error with edac_mce_amd.c as module
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 15 Sep 2009 15:54:39 -0400
Message-Id: <1253044479.20020.125.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file drivers/edac/edac_mce_amd.c references a kernel variable that
is not exported for modules.

 ERROR: "per_cpu__cpu_llc_id" [drivers/edac/edac_core.ko] undefined!


The variable in question is located in arch/x86/kernel/smpboot.c

/* Last level cache ID of each logical CPU */
DEFINE_PER_CPU(u16, cpu_llc_id) = BAD_APICID;

and is not exported to modules.

This is from the latest Linus repo. I can supply a config if requested.

-- Steve


