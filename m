Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbZA1XRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbZA1XRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbZA1XR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:17:29 -0500
Received: from gw.goop.org ([64.81.55.164]:38099 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbZA1XR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:17:28 -0500
Message-ID: <4980E785.9010302@goop.org>
Date: Wed, 28 Jan 2009 15:17:25 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ian Campbell <Ian.Campbell@citrix.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC WIP] x86/paravirt: add register-saving thunks to	reduce
 caller register pressure
References: <4980A07D.3010008@goop.org> <1233183903.16317.242.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1233183903.16317.242.camel@bodhitayantram.eng.vmware.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
>> Standard calling convention is:
>>          arguments          return      scratch
>> x86-32   eax edx ecx        eax         ?
>>     
>
> ecx, edx
>   

OK, no scratch beyond the arg regs.

>> XXX Deal with VMI.  What's their calling convention?
>>     
>
> Enable/Disable have no clobbers at all.
> Save clobbers only return value, %eax
> Restore also clobbers nothing.
>   

OK, they can be plugged in directly then.  Use __PV_IS_CALLEE_SAVE(func) 
to wrap it up in the right type.

> The patching code has gotten quite complex with the 32/64 union; let me
> apply it first and see before I comment on the patch.
>   

OK.  I just posted updated versions of this series, so make sure you 
comment on that one.

    J
