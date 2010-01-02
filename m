Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869Ab0ABRCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab0ABRCE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 12:02:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857Ab0ABRB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 12:01:59 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50830 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab0ABRB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 12:01:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bj755MgrGy/Dl1INjFuXEV7Mcb8NE87Hj1D9kcVG9XPjBWhRBBXyWNfP6kP+/11OiL
         YGGnt+59T4ykKpeXVEeWwEwydZ3LFCNjYl6HOC/AWf4d95vdTvSHG9HyYQK2XVp7WUtR
         XAJ7qudGUMQ9wnWI8ZUatmGw9psTSVGVu1+Xw=
Date: Sat, 2 Jan 2010 18:01:54 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf tools: Prevent from BITS_PER_LONG redefinition
Message-ID: <20100102170151.GB5076@nowhere>
References: <1261173920-11320-1-git-send-regression-fweisbec@gmail.com> <1261214767.20899.697.camel@laptop> <20091219143425.GA5003@nowhere> <4B2DB1F8.2070006@goop.org> <20091230214549.GF6322@nowhere> <4B3C8677.3030606@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B3C8677.3030606@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 10:09:43PM +1100, Jeremy Fitzhardinge wrote:
> On 12/31/2009 08:45 AM, Frederic Weisbecker wrote:
>>> You can use if() with a constant expression instead of #if.
>>>      
>>
>>
>> I did not write this code. But yes you're right, although I
>> think CPP is more suitable here because fls() can be called
>> from fastpath and this conditional build makes one check less
>> and lesser i-cache footprint.
>>    
>
> Constant if()s are removed at compile time, so there should be no  
> runtime overhead.  Constant if()s are generally preferable to #if  
> because the compile will statically check the other code branch, even if  
> it never gets executed, which helps prevent it from rotting.



Good point! I did not think about compile time optimizations.
I'll try that then. Thanks!

