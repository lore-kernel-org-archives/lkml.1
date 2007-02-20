Return-Path: <linux-kernel-owner+w=401wt.eu-S932599AbXBTHrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599AbXBTHrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 02:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932709AbXBTHrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 02:47:10 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:5314
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932599AbXBTHrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 02:47:09 -0500
Message-Id: <45DAB598.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Tue, 20 Feb 2007 07:47:20 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mtrr range check correction
References: <45D2CBEF.76E4.0078.0@novell.com> <45D8C620.2000009@redhat.com>
In-Reply-To: <45D8C620.2000009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Chuck Ebbert <cebbert@redhat.com> 18.02.07 22:33 >>>
>Jan Beulich wrote:
>> Whether a region is below 1Mb is determined by its start rather than
>> its end.
>> 
>> This hunk got erroneously dropped from a previous patch.
>> 
>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>> 
>> --- linux-2.6.20/arch/i386/kernel/cpu/mtrr/generic.c	2007-02-04 19:44:54.000000000 +0100
>> +++ 2.6.20-x86-mtrr-range-check/arch/i386/kernel/cpu/mtrr/generic.c	2007-02-09 10:17:26.000000000 +0100
>> @@ -428,7 +428,7 @@ int generic_validate_add_page(unsigned l
>>  		}
>>  	}
>>  
>> -	if (base + size < 0x100) {
>> +	if (base < 0x100) {
>>  		printk(KERN_WARNING "mtrr: cannot set region below 1 MiB (0x%lx000,0x%lx000)\n",
>>  		       base, size);
>>  		return -EINVAL;
>> 
>
>What about wraparound?

Should be caught by the subsequent checking of upper bits of first and last byte
being identical.

Jan

