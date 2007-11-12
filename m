Return-Path: <linux-kernel-owner+w=401wt.eu-S1759152AbXKLSF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152AbXKLSF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 13:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbXKLSFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 13:05:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56622 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbXKLSFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 13:05:17 -0500
Message-ID: <47389448.4050107@zytor.com>
Date: Mon, 12 Nov 2007 09:58:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Robert Richter <robert.richter@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/6] x86: apicdef unification: some constants made unsigned
References: <20071106183645.951275000@amd.com> <20071106183646.064906000@amd.com> <Pine.LNX.4.64N.0711121229360.30102@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0711121229360.30102@blysk.ds.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> On Tue, 6 Nov 2007, Robert Richter wrote:
> 
>> -#define			GET_APIC_VERSION(x)	((x)&0xFF)
>> -#define			GET_APIC_MAXLVT(x)	(((x)>>16)&0xFF)
>> -#define			APIC_INTEGRATED(x)	((x)&0xF0)
>> +#define			GET_APIC_VERSION(x)	((x)&0xFFu)
>> +#define			GET_APIC_MAXLVT(x)	(((x)>>16)&0xFFu)
>> +#define			APIC_INTEGRATED(x)	((x)&0xF0u)
> 
>  No point in doing this -- hexadecimal literals are unsigned by 
> definition.  File a compiler bug if you see them interpreted otherwise.
> 

Not unless they have to be (see C99 if you don't believe me... on a 
I32LP64 system for example, 0x7fffffff is signed int, 0x80000000 is 
unsigned int, 0x100000000 is signed long).

What is this supposed to solve in the first place?

	-hpa

