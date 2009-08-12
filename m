Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbZHLPom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbZHLPom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbZHLPol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:44:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:12980 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbZHLPok convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:44:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,368,1246863600"; 
   d="scan'208";a="716167015"
From: "Wang, Shane" <shane.wang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
CC: "Cihula, Joseph" <joseph.cihula@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>
Date: Wed, 12 Aug 2009 23:42:56 +0800
Subject: RE: [RFC v6][PATCH 0b/4] intel_txt: Intel(R) Trusted Execution
	Technology support for Linux - Details
Thread-Topic: [RFC v6][PATCH 0b/4] intel_txt: Intel(R) Trusted Execution
	Technology support for Linux - Details
Thread-Index: AcobX11CNsR9jTjBSIitKEnpev/kpQAA7u+A
Message-ID: <037F493892196B458CD3E193E8EBAD4F01EAB641FD@pdsmsx502.ccr.corp.intel.com>
References: <4A4ACA60.1000209@intel.com> <20090807072752.GA12119@elte.hu>
 <20090812145321.GA11347@elte.hu> <4A82DBA2.2000509@zytor.com>
In-Reply-To: <4A82DBA2.2000509@zytor.com>
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

H. Peter Anvin wrote:
> On 08/12/2009 07:53 AM, Ingo Molnar wrote:
>> * Ingo Molnar <mingo@elte.hu> wrote:
>> 
>>> i reviewed & tried the latest patches. Structure of v6 looks now
>>> looks pretty good, but there are some build problems:
>>> 
>>> arch/x86/kernel/tboot.c: In function 'tboot_probe':
>>> arch/x86/kernel/tboot.c:76: error: implicit declaration of function
>>> 'set_fixmap' arch/x86/kernel/tboot.c:76: error: 'FIX_TBOOT_BASE'
>>> undeclared (first use in this function) arch/x86/kernel/tboot.c:76:
>>> error: (Each undeclared identifier is reported only once
>>> arch/x86/kernel/tboot.c:76: error: for each function it appears
>>> in.) arch/x86/kernel/tboot.c:77: error: implicit declaration of
>>> function 'fix_to_virt' arch/x86/kernel/tboot.c:77: warning: cast to
>>> pointer from integer of different size  
>>> 
>>> config attached.
>> 
>> ok, hpa fixed this bug - i tested it some more and here's the next
>> issue:
>> 
>> arch/x86/built-in.o: In function `tboot_shutdown':
>> (.text+0x2e3b5): undefined reference to
>> `acpi_wakeup_address'arch/x86/built-in.o: In function `tboot_sleep':
>> (.text+0x2e679): undefined reference to `acpi_wakeup_address' 
>> 
>> Config attached below.
>> 
> 
> tboot_sleep() references acpi_wakeup_address, which is only defined if
> CONFIG_ACPI_SLEEP is set.  We *could* make TBOOT require
> CONFIG_ACPI_SLEEP, but that looks like the wrong thing to do to me,
> unless TXT somehow depends on having S3 support.
> 
> 	-hpa

oh, S3 support by TXT is one of TXT support. We have code to secure S3 sleep and resume.
Without S3 support, TXT code is incomplete.

Shane