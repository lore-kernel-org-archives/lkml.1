Return-Path: <linux-kernel-owner+w=401wt.eu-S1757008AbZFIAVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008AbZFIAVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 20:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbZFIAVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 20:21:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:54988 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbZFIAVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 20:21:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,327,1241420400"; 
   d="scan'208";a="419968519"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "Tang, Feng" <feng.tang@intel.com>
CC: "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>
Date: Mon, 8 Jun 2009 17:21:37 -0700
Subject: RE: [PATCH] tick: add check for the existence of broadcast clock
 event device
Thread-Topic: [PATCH] tick: add check for the existence of broadcast clock
 event device
Thread-Index: AcnoPu0vuZKmAqtMRvmE3EmbwwAoSQATZX7g
Message-ID: <43F901BD926A4E43B106BF17856F07556340868E@orsmsx508.amr.corp.intel.com>
References: <20090605112711.67e7d5cb@feng-desktop>
 <alpine.LFD.2.00.0906061121330.3419@localhost.localdomain>
 <20090606204736.00700bd0@feng-desktop>
 <alpine.LFD.2.00.0906061450220.3419@localhost.localdomain>
 <alpine.LFD.2.00.0906061815460.3419@localhost.localdomain>
 <20090608095730.0c945e78@feng-desktop>
 <alpine.LFD.2.00.0906080739020.3419@localhost.localdomain>
 <20090608141250.6a5735fa@feng-desktop>
 <alpine.LFD.2.00.0906080828021.3419@localhost.localdomain>
 <20090608144740.62f2ed95@feng-desktop>
 <alpine.LFD.2.00.0906080857260.3419@localhost.localdomain>
 <EADF0A36011179459010BDF5142A457501C9CD39CC@pdsmsx502.ccr.corp.intel.com>
 <alpine.LFD.2.00.0906081109080.3419@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0906081109080.3419@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>I understand that, but HPET does not rely on some magic events
>happening. That's what I'm worried about. The boot code is fragile and
>I prefer some explicit setup call over a fragile solution which
>happens to work.
>
>There is not much to complain about a platform specific function call
>to set up special devices if there is a requirement for a call order.
>
>In fact you can avoid setting up the local APIC timer at all. So what
>you want is something like the patch below. You can set the
>setup_secondary_clock pointer in the quirks structure when you detect
>that you are running on such a system.
>
[[JPAN]] Hi Thomas, I have been developing the APB timer driver as Feng mentioned, thank you for the suggestions. 
I agree with you that direct setting up secondary clockevent is a better solution.

But maybe I misunderstand the HPET code, isn't it true that per CPU HPET timer also rely on IPI? In hpet_cpuhp_notify().

Also for using x86_quirks, I think the default quirks are more generic in the sense of x86 platform, but here we are really choosing timer device, so can we switch based on availability of the timer devices instead of quirks? Otherwise, if more platforms share the same setup_secondary_clock() quirk, we would have to check for timer devices anyway.

Jacob
