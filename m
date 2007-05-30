Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbXE3XTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbXE3XTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbXE3XTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:19:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:15895 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbXE3XTO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:19:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,595,1170662400"; 
   d="scan'208";a="251436318"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: BUG: sleeping function called from invalid context at kernel/fork.c:385
Date: Wed, 30 May 2007 16:19:11 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A01929C15@scsmsx411.amr.corp.intel.com>
In-Reply-To: <Pine.LNX.4.64.0705301537450.1529@schroedinger.engr.sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: BUG: sleeping function called from invalid context at kernel/fork.c:385
Thread-Index: AcejC1sbWAlRp/THTMu0gMjj+3I3vAABQ/Rw
From: "Luck, Tony" <tony.luck@intel.com>
To: "Christoph Lameter" <clameter@sgi.com>
Cc: "David Chinner" <dgc@sgi.com>, "Andrew Morton" <akpm@linux-foundation.org>,
       "lkml" <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
       "Sam Ravnborg" <sam@ravnborg.org>
X-OriginalArrivalTime: 30 May 2007 23:19:13.0804 (UTC) FILETIME=[EF9A9CC0:01C7A310]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> `.exit.text' referenced in section `.init.text' of drivers/built-in.o: 
> defined in discarded section `.exit.text' of drivers/built-in.o


This one is a fatal error ... the code is trying to call a function
that has been marked __exit in a driver that has been built-in, instead
of as a module.  Since a builtin driver can never be unloaded, the kernel
has thrown away all the __exit routines (at link time).

The error message appears less than helpful in tracking down which
routine in which driver is the problem though.

-Tony
