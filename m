Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbXDBHUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbXDBHUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbXDBHUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:20:23 -0400
Received: from gw.goop.org ([64.81.55.164]:57192 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbXDBHUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:20:22 -0400
Message-ID: <4610AEA8.7010604@goop.org>
Date: Mon, 02 Apr 2007 00:20:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [patch 12/17] Consistently wrap paravirt ops callsites to make
 them patchable
References: <20070402055652.610711908@goop.org> <20070402055705.090656820@goop.org> <200704020911.50623.ak@suse.de>
In-Reply-To: <200704020911.50623.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Can you please add some comments to the code explaining this a little?
> Best would be perhaps a overview document in Documentation too.
>   

Yes, OK.

>> +#define PVOP_CALL0(__rettype, __op)					\
>>     
>
> The __s shouldn't be needed for the macro arguments because
> there is no shared name space with the caller.
>   

Yes.  I was more concerned about "op" clashing with variables used
within the macro, but that's not an issue now.

>> +	({								\
>> +		__rettype __ret;					\
>> +		if (sizeof(__rettype) > sizeof(unsigned long)) {	\
>> +			unsigned long long __tmp;			\
>> +			unsigned long __ecx;				\
>> +			asm volatile(paravirt_alt(PARAVIRT_CALL)	\
>>     
>
> Not having the volatile would probably generate better code, but it 
> seems much safer for now.
>   

I think it has to be there, though perhaps the "memory" is sufficient to
make sure all the calls get generated.  We don't want gcc to eliminate
any of these calls because it thinks they can be CSEd.

> And the cc clobber is also not needed
>   

I get conflicting advice about this.  I think Linus mentioned that the
gcc people would prefer it to be there explicitly, even though its
currently implied.


    J
