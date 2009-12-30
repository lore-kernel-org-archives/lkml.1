Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906AbZL3Vp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbZL3Vp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 16:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbZL3Vp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 16:45:57 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:12270 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZL3Vp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 16:45:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YZEtNtCAMSsa7ju/NEpH0kNvQXhwoT+N9TpwRJraFiiUiGwofa5R5wtZ9ZGMmbhl6q
         kRp/nbre2llDBBAgwfl8Czd6LS/om2+mlDTIWltxOLF6NZYeySXnpOs0xXC8rt1zL0EA
         LW5C4Uw0H1kVIBiKS3oUFetXwHtu8qp4Z+KWE=
Date: Wed, 30 Dec 2009 22:45:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf tools: Prevent from BITS_PER_LONG redefinition
Message-ID: <20091230214549.GF6322@nowhere>
References: <1261173920-11320-1-git-send-regression-fweisbec@gmail.com> <1261214767.20899.697.camel@laptop> <20091219143425.GA5003@nowhere> <4B2DB1F8.2070006@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2DB1F8.2070006@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 19, 2009 at 09:11:20PM -0800, Jeremy Fitzhardinge wrote:
> On 12/19/2009 06:34 AM, Frederic Weisbecker wrote:
>> Yeah but we need it from the CPP level.
>> We include such code located in kernel headers:
>>
>> static __always_inline unsigned long __fls(unsigned long word)
>> {
>> 	int num = BITS_PER_LONG - 1;
>>
>> #if BITS_PER_LONG == 64
>> 	if (!(word&  (~0ul<<  32))) {
>> 		num -= 32;
>> 		word<<= 32;
>> 	}
>> #endif
>> 	if (!(word&  (~0ul<<  (BITS_PER_LONG-16)))) {
>> 		num -= 16;
>> 		word<<= 16;
>> 	}
>>
>>
>> And sizeof() is not defined :)
>>    
>
> You can use if() with a constant expression instead of #if.



I did not write this code. But yes you're right, although I
think CPP is more suitable here because fls() can be called
from fastpath and this conditional build makes one check less
and lesser i-cache footprint.

