Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbXC0Vn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbXC0Vn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 17:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbXC0Vn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 17:43:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:16977 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbXC0Vn6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 17:43:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,335,1170662400"; 
   d="scan'208"; a="203883465:sNHT21305473"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table
Date: Tue, 27 Mar 2007 14:43:55 -0700
Message-ID: <08FE5CC30C9A3F41BF819A502CF7BF6EF98580@fmsmsx411.amr.corp.intel.com>
In-Reply-To: <m1ps6uwfs8.fsf@ebiederm.dsl.xmission.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table
Thread-Index: AcdwtOa40FlgTSNNR6m4T0rXbjwjjAAArM4A
From: "Williams, Mitch A" <mitch.a.williams@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Grant Grundler" <grundler@parisc-linux.org>,
       <linux-pci@atrey.karlin.mff.cuni.cz>, <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
X-OriginalArrivalTime: 27 Mar 2007 21:43:57.0028 (UTC) FILETIME=[05B3D240:01C770B9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:

>> However the mask function is called at EVERY interrupt,
>> so this change would be VERY expensive.
>
>If true I think that would be bad.  However I don't see it.
>Where in handle_edge_irq do we mask the interrupt?
>The only place I see us calling ->mask is from move_native_irq
>and that only if IRQ_MOVE_PENDING is true.
>
>All I can see is us routinely calling is ack_APIC_edge.

Doh!  I was reading the code wrong.  We only mask if we're still
handling a previous interrupt on the same vector.  My bad.

However, I can't really see where mask() is used outside of that
instance.  Which then leads us back to the question:  do we need
a read flush on mask/unmask or just enable/disable?

