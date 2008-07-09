Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbYGII6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbYGII6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 04:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbYGII6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 04:58:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:6866 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbYGII6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 04:58:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pRXInKI+slAukf9XXR90HUZJInaAINIUwc90R6OdWDLTCsecRVW8meBSoOhDxbCXEL
         aTqT4SRLujgOGFH0lkt7o2k1he2Ow6zpIawbaNxVBsvvbbgBXIW0lxjkJR0Hw6pyFzNt
         V6UCarSnF82LVskPIdcBLYwIE6mGs9dE9+EQI=
Message-ID: <86802c440807090158p3728070cy2988beda20b451d4@mail.gmail.com>
Date: Wed, 9 Jul 2008 01:58:21 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: not overmap than end in init_memory_mapping - 64bit
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080709084600.GA4919@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807080141.05436.yhlu.kernel@gmail.com>
	 <200807080143.27997.yhlu.kernel@gmail.com>
	 <20080709073844.GB30428@elte.hu> <20080709083425.GA23952@elte.hu>
	 <86802c440807090137t41734ac3l25f565cf5efb3e7b@mail.gmail.com>
	 <20080709084600.GA4919@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2008 at 1:46 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> > reverting the commit solves the crash. The crash seems to be because
>> > ACPI is unable to access that memory range. (perhaps early_ioremap
>> > fails?)
>>
>> system with less than 4g?
>
> yeah.
>
>> please test attached patch
>> [PATCH] x86: make max_pfn cover acpi table below 4g
>
> that fixed it, thanks.

[    0.000000] kernel direct mapping tables up to 3fff0000 @ 8000-b000
[    0.000000] last_map_addr: 40000000 end: 3fff0000
[    0.000000] ACPI: RSDP 000F76F0, 0014 (r0 Nvidia)

last_map_addr is supposed to be 3fff0000.

so it means before init_memory_mapping, initial page table already
cover to 0x40000000 with 2M big page.
and init_memory_mapping can not do anything with that is already mapped.

it seems that need to make early_ioremap more smart...

YH
