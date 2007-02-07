Return-Path: <linux-kernel-owner+w=401wt.eu-S1161446AbXBGRK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161446AbXBGRK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 12:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161436AbXBGRK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 12:10:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:1387 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161435AbXBGRK4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 12:10:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,296,1167638400"; 
   d="scan'208"; a="196881727:sNHT687840377"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] [IA64] Include kexec.h in arch/ia64/kernel/process.c
Date: Wed, 7 Feb 2007 09:07:40 -0800
Message-ID: <617E1C2C70743745A92448908E030B2A0117C67C@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070207064935.GB726@verge.net.au>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] [IA64] Include kexec.h in arch/ia64/kernel/process.c
Thread-Index: AcdKhJhkjB+INUURQVeaU3a4Fa6bRAAVR6/Q
From: "Luck, Tony" <tony.luck@intel.com>
To: "Horms" <horms@verge.net.au>, <linux-ia64@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <fastboot@lists.osdl.org>
Cc: "Zou, Nanhai" <nanhai.zou@intel.com>, "Khalid Aziz" <khalid_aziz@hp.com>,
       "Adrian Bunk" <trivial@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Magnus Damm" <magnus.damm@gmail.com>
X-OriginalArrivalTime: 07 Feb 2007 17:07:42.0617 (UTC) FILETIME=[7AC16890:01C74ADA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> kexec.h is needed by arch/ia64/kernel/process.c so for the
> declaration of kexec_disable_iosapic() which is used in machine_shutdown().

> +#include <asm/kexec.h>

I merged this into your earlier change (moving machine_shutdown() into
process.c).  Linus pulled it last night.

I also added a "#ifdef CONFIG_KEXEC" around the call to kexec_disable_iosapic()
(because I first noticed that this was undefined when building non-KEXEC kernels).
But perhaps it might have been better to #define an empty stub for this function
inside kexec.h for the #ifndef CONFIG_KEXEC case?

-Tony
