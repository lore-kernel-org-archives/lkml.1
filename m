Return-Path: <linux-kernel-owner+w=401wt.eu-S934818AbZAPNvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934818AbZAPNvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762764AbZAPNu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:50:59 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:54956 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762229AbZAPNu6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:50:58 -0500
Message-Id: <49709EF7.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 16 Jan 2009 13:51:35 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: fully honor "nolapic" (take 2)
References: <4970818A.76E4.0078.0@novell.com>
 <20090116124548.GC5421@elte.hu> <49709C94.76E4.0078.0@novell.com>
 <20090116134243.GC14874@elte.hu>
In-Reply-To: <20090116134243.GC14874@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 16.01.09 14:42 >>>
>
>* Jan Beulich <jbeulich@novell.com> wrote:
>
>> >>> Ingo Molnar <mingo@elte.hu> 16.01.09 13:45 >>>
>> >
>> >* Jan Beulich <jbeulich@novell.com> wrote:
>> >
>> >> +	if (disable_apic) {
>> >> +#ifdef CONFIG_X86_IO_APIC
>> >> +		disable_ioapic_setup();
>> >> +#endif
>> >> +		return;
>> >> +	}
>> >
>> > Shouldnt that #ifdef be avoided by always providing the function - 
>> > just it is a NOP inline in the !CONFIG_X86_IO_APIC case?
>> 
>> That would make for a much bigger patch, since the io_apic.h doesn't 
>> (and imo shouldn't) be included without that config option.
>
>But we are using io-apic functionality in that file, so we should include 
>io_apic.h, right?

I don't generally (i.e. when !X86_IO_APIC) think so - anything accessing
stuff from io_apic.c is guarded by a similar #ifdef.

Jan

