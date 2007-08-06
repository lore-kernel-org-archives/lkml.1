Return-Path: <linux-kernel-owner+w=401wt.eu-S933444AbXHFSps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933444AbXHFSps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759043AbXHFSpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:45:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:41139 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbXHFSpb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:45:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,225,1183359600"; 
   d="scan'208";a="277462831"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [2/2] 2.6.23-rc2: known regressions with patches
Date: Mon, 6 Aug 2007 11:45:29 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A0218E076@scsmsx411.amr.corp.intel.com>
In-Reply-To: <1186331976.3858.39.camel@fanta4.site>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2/2] 2.6.23-rc2: known regressions with patches
Thread-Index: AcfXfxdf8XvKU1TmTwaY0KCco++8EwA2KxEA
From: "Luck, Tony" <tony.luck@intel.com>
To: <trenn@suse.de>, "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Peter Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Jan Dittmer" <jdi@l4x.org>, "Netdev" <netdev@vger.kernel.org>,
       "Joachim Deguara" <joachim.deguara@amd.com>,
       "Michael Chan" <mchan@broadcom.com>, <linux-scsi@vger.kernel.org>,
       "James Bottomley" <James.Bottomley@steeleye.com>,
       "Matthew Wilcox" <matthew@wil.cx>,
       "Seokmann Ju" <seokmann.ju@qlogic.com>,
       "Richard Lary" <rlary@us.ibm.com>
X-OriginalArrivalTime: 06 Aug 2007 18:45:29.0925 (UTC) FILETIME=[F64C8F50:01C7D859]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Caused-By       : Thomas Renninger <trenn@suse.de>
> >                   commit 29b71a1ca74491fab9fed09e9d835d840d042690

> A patch was sent to Tony. AFAIK it got accepted, not sure whether it
> already is in any and which git tree...

The suggested patch adds manual padding to the acpi_device_id structure
definition in include/linux/mod_devicetable.h  I didn't take it, and it
appears that nobody else did either.  It is not in Linus' tree (as of 2.6.23-rc2).

I expressed doubts about whether this is the right fix.  The problem
is that when cross-compiling a locally compiled utility makes a size &
alignment check.  This is bogus.  We shouldn't care whether this structure
compiles to the same size/alignment as the kernel that will use on the
target platform.

Is fixing this the right way (make the scripts/mod/file2alias.c understand
target alignment rules in a cross environment) just too hideous to
contemplate ... and we should just sacrifice 7 bytes of padding in
order to keep life simple?

-Tony
