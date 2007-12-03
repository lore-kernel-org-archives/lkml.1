Return-Path: <linux-kernel-owner+w=401wt.eu-S1751814AbXLCUqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbXLCUqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 15:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866AbXLCUqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 15:46:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:29610 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbXLCUqD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 15:46:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,245,1194249600"; 
   d="scan'208";a="222661626"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: WARNING: smp_call_function_single() and smp_call_function_mask()
Date: Mon, 3 Dec 2007 12:46:02 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE2FB41A@orsmsx423.amr.corp.intel.com>
In-Reply-To: <47546385.1010708@dbservice.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: WARNING: smp_call_function_single() and smp_call_function_mask()
Thread-Index: Acg16W3yyVTGOgDsQDqB5Mp1GLDU3wAA2d6A
References: <4752703B.10305@dbservice.com> <20071201084833.63263489@laptopd505.fenrus.org> <47546385.1010708@dbservice.com>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Tomas Carnecky" <tom@dbservice.com>,
       "Arjan van de Ven" <arjan@infradead.org>
Cc: <linux-kernel@vger.kernel.org>, <lenb@kernel.org>
X-OriginalArrivalTime: 03 Dec 2007 20:45:43.0224 (UTC) FILETIME=[78EAE380:01C835ED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Tomas Carnecky
>Sent: Monday, December 03, 2007 12:14 PM
>To: Arjan van de Ven
>Cc: linux-kernel@vger.kernel.org; lenb@kernel.org
>Subject: Re: WARNING: smp_call_function_single() and 
>smp_call_function_mask()
>
>Arjan van de Ven wrote:
>> On Sun, 02 Dec 2007 09:43:39 +0100
>> Tomas Carnecky <tom@dbservice.com> wrote:
>> 
>>> WARNING: at arch/x86/kernel/smp_64.c:427 smp_call_function_single()
>>> WARNING: at arch/x86/kernel/smp_64.c:397 smp_call_function_mask()
>>>
>>> dmesg and config attached.
>>>
>>> I'm getting about three of each at boot. I'm running:
>>> commit e1cca7e8d484390169777b423a7fe46c7021fec1
>>> Date:   Thu Nov 29 16:25:29 2007 -0800
>>> which is the latest git as of yesterday plus a one (unrelated) debug
>>> statement patch in usb uhci.
>>>
>>> There was a similar bug report after 2.6.23-rc8-mm was released.
>>> Though there seems to be a fundamental problem with how people use
>>> smp_call_function*() [1]. And this can just as well be another
>>> incarnation of it.
>>>
>>> Is that easy enough to fix or do I need to bisect (it 
>didn't happen in
>>> 2.6.24-rc3)?
>>>
>> 
>> this appears to be a bug in the acpi code, to be exact in
>> processor_throttling.c file, function
>> acpi_processor_set_throttling_ptc(); it disables interrupts and then
>> appears to do a cross-cpu IPI to set the state. Well... we can't do
>> that due to deadlock reasons (you can't do IPI's with 
>interrupts off or
>> you can get a very nice deadlock with the cpu that you IPI trying to
>> do the same thing to you).
>> 
>
>I updated the kernel today (to 1a2edea9aff48...) and the 
>warnings are gone.

Yes. This was reported here earlier and fixed by this patch from Yakui.
http://www.ussg.iu.edu/hypermail/linux/kernel/0711.3/1596.html
which should now be merged upstream.

Thanks,
Venki
