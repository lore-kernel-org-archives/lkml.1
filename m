Return-Path: <linux-kernel-owner+w=401wt.eu-S1760493AbYCUS7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760493AbYCUS7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760636AbYCUS7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:59:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:42475 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392AbYCUS7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:59:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,536,1199692800"; 
   d="scan'208";a="308272614"
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 0/5] Generic smp_call_function(), improvements, and smp_call_function_single()
Date: Fri, 21 Mar 2008 11:56:42 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843ECE1387F@orsmsx424.amr.corp.intel.com>
In-reply-to: <20080321183149.GB15355@kernel.dk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/5] Generic smp_call_function(), improvements, and smp_call_function_single()
Thread-Index: AciLgeGmlJ9gLPKsRDayVF0qKv9/HwAASXbw
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com> <1FE6DD409037234FAB833C420AA843ECE137D9@orsmsx424.amr.corp.intel.com> <20080321183149.GB15355@kernel.dk>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Cc: <linux-kernel@vger.kernel.org>, <npiggin@suse.de>, <paulus@samba.org>,
       <tglx@linutronix.de>, <mingo@redhat.com>
X-OriginalArrivalTime: 21 Mar 2008 18:58:00.0902 (UTC) FILETIME=[7C198E60:01C88B85]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My thinking was that it may need a bit of help to ensure that the init
> function for single call data works,

The problem may be worse than that.  I see that you have a per-cpu
"call_single_queue" on which you do some list operations.  On ia64
the per-cpu variables live at the same virtual address on each processor
with a per-cpu TLB mapping directing them to a different physical
address on each.  This makes Linux lists very confused.

-Tony
