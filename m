Return-Path: <linux-kernel-owner+w=401wt.eu-S1751355AbXLCUOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbXLCUOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 15:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbXLCUOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 15:14:23 -0500
Received: from neopsis.com ([213.239.204.14]:41011 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750733AbXLCUOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 15:14:22 -0500
Message-ID: <47546385.1010708@dbservice.com>
Date: Mon, 03 Dec 2007 21:13:57 +0100
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071118)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: WARNING: smp_call_function_single() and smp_call_function_mask()
References: <4752703B.10305@dbservice.com> <20071201084833.63263489@laptopd505.fenrus.org>
In-Reply-To: <20071201084833.63263489@laptopd505.fenrus.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (score=-2.261,
	required 5, autolearn=spam, AWL 0.24, BAYES_00 -2.60,
	RDNS_DYNAMIC 0.10)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sun, 02 Dec 2007 09:43:39 +0100
> Tomas Carnecky <tom@dbservice.com> wrote:
> 
>> WARNING: at arch/x86/kernel/smp_64.c:427 smp_call_function_single()
>> WARNING: at arch/x86/kernel/smp_64.c:397 smp_call_function_mask()
>>
>> dmesg and config attached.
>>
>> I'm getting about three of each at boot. I'm running:
>> commit e1cca7e8d484390169777b423a7fe46c7021fec1
>> Date:   Thu Nov 29 16:25:29 2007 -0800
>> which is the latest git as of yesterday plus a one (unrelated) debug
>> statement patch in usb uhci.
>>
>> There was a similar bug report after 2.6.23-rc8-mm was released.
>> Though there seems to be a fundamental problem with how people use
>> smp_call_function*() [1]. And this can just as well be another
>> incarnation of it.
>>
>> Is that easy enough to fix or do I need to bisect (it didn't happen in
>> 2.6.24-rc3)?
>>
> 
> this appears to be a bug in the acpi code, to be exact in
> processor_throttling.c file, function
> acpi_processor_set_throttling_ptc(); it disables interrupts and then
> appears to do a cross-cpu IPI to set the state. Well... we can't do
> that due to deadlock reasons (you can't do IPI's with interrupts off or
> you can get a very nice deadlock with the cpu that you IPI trying to
> do the same thing to you).
> 

I updated the kernel today (to 1a2edea9aff48...) and the warnings are gone.

tom
