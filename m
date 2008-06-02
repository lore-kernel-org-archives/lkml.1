Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbYFBNNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbYFBNNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbYFBNNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:13:06 -0400
Received: from gw.goop.org ([64.81.55.164]:41421 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbYFBNND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:13:03 -0400
Message-ID: <4843F1B9.7070108@goop.org>
Date: Mon, 02 Jun 2008 14:12:25 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       x86@kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [bisected] Re: [PATCH 05 of 12] xen: add p2m mfn_list_list
References: <patchbomb.1211550067@localhost> <a405e5f9ddf6f5f142ea.1211550072@localhost> <20080528122813.GA5502@elte.hu> <483D65E6.3020604@goop.org> <20080602101059.GB7459@elte.hu>
In-Reply-To: <20080602101059.GB7459@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Subject: make page-aligned data and bss less fragile
>>
>> Making a variable page-aligned by using 
>> __attribute__((section(".data.page_aligned"))) is fragile because if 
>> sizeof(variable) is not also a multiple of page size, it leaves 
>> variables in the remainder of the section unaligned.
>>
>> This patch introduces two new qualifiers, __page_aligned_data and 
>> __page_aligned_bss to set the section *and* the alignment of 
>> variables.  This makes page-aligned variables more robust because the 
>> linker will make sure they're aligned properly.  Unfortunately it 
>> requires *all* page-aligned data to use these macros...
>>     
>
> applied to -tip, thanks Jeremy. Created a new topic branch for the core 
> bits of it: tip/build. Sam might want to pull from that topic branch 
> eventually, once these changes pass testing in -tip.
>   

Can you also drop "xen: fix early bootup crash on native hardware" and 
replace it with "x86: use __page_aligned_data/bss"?  (Which seems to 
have been partially applied?)

Thanks,
    J
