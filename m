Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbXE3ULc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbXE3ULc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbXE3ULX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:11:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:6095 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbXE3ULW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:11:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,594,1170662400"; 
   d="scan'208";a="249015440"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: BUG: sleeping function called from invalid context at kernel/fork.c:385
Date: Wed, 30 May 2007 13:11:17 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A019298C6@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070530044448.GK86004887@sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: BUG: sleeping function called from invalid context at kernel/fork.c:385
Thread-Index: AceidUxNxSoPh603TmuA63jfLFtPZgAgET+w
From: "Luck, Tony" <tony.luck@intel.com>
To: "David Chinner" <dgc@sgi.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "lkml" <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 30 May 2007 20:11:20.0011 (UTC) FILETIME=[AFE651B0:01C7A2F6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmmm - I wonder if my tree is screwed up in some weird way. I'm seeing link
> warnings as well:
>
> WARNING: init/built-in.o - Section mismatch: reference to .init.data: from .sdata after 'root_mountflags' (at offset 0x38)

I thought that I'd got the section mis-match warnings down to
just one (and that was in ACPI code, so I sent a patch to Len
for it).

Are you building from defconfig, or one of the standard ones? Changing
config options always has the possibility of unearthing new spots
where there are conflicts between __init, __cpuinit and __devinit.

But I've had other complaints that these Section mismatch warnings
are still showing up in kernels built from the "standard" config
files (arch/ia64/configs/*) ... which I'm not seeing.  So I'm more
than a little confused about this.

These errors are unlikely to be related to the strace bug that
you've reported.  I'll try to pound on this some more when I'm
back on the same continent as my test machines.


-Tony
