Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbYDHI72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbYDHI72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 04:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbYDHI7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 04:59:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:24537 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbYDHI7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 04:59:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,622,1199692800"; 
   d="scan'208";a="228806450"
Date: Tue, 8 Apr 2008 10:59:06 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: andi-suse@firstfloor.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com, eranian@googlemail.com, juan.villacis@intel.com
Subject: [patch 0/1] x86, ptrace: execution trace support
Message-ID: <20080408105906.A9315@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Execution trace support for application debugging.


The following patch establishes the user interface and the low-level
hardware interface. What's missing is an intermediate layer based on
utrace.


The user interface uses ptrace to expose the feature to application
debuggers. From what I found on lwn.net, ptrace will remain as user
interface for utrace.

The low-level interface functions as resource allocator for the
hardware's IA32_DS_AREA MSR, which is used for PEBS performance
monitoring and for BTS execution tracing.

The low-level interface will be used by perfmon2 and is currently used
by this patch.


The patch currently implements execution trace support directly in
ptrace for the simple reason that utrace is not yet available.

>From the perspective of this patch, utrace is an intermediate layer
that will be introduced between ptrace and ds.c. As such, this layer
may be introduced at any time without affecting the other interfaces.


I fail to see a reason why we should not establish the two interfaces
that are meant to remain stable at this point in time.
- Intel is waiting for the user interface to support execution trace
  in their application debugger for MID.
- Perfmon2 is waiting for the low-level interface.
- Execution tracing is an extremely useful debugging feature that
  would greatly help application developers as well as kernel
  developers.


The patch does not depend on ptrace except for a small change to
ptrace_disable(); nor does it add dependencies to ptrace. It therefore
does not cause any additional effort in order to introduce the utrace
layer for the remainder of ptrace.

The two (three, if we consider perfmon2) projects would be able to
proceed independently and in parallel. Currently, we are preventing
progress on perfmon2 and on execution trace support for Moblin for no
apparent reason. 


regards,
markus.
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

