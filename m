Return-Path: <linux-kernel-owner+w=401wt.eu-S1755782AbZBCRXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbZBCRXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbZBCRXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:23:15 -0500
Received: from gw.goop.org ([64.81.55.164]:53303 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbZBCRXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:23:15 -0500
Message-ID: <49887D80.8090708@goop.org>
Date: Tue, 03 Feb 2009 09:23:12 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Zachary Amsden <zach@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ian Campbell <Ian.Campbell@citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC WIP] x86/paravirt: add register-saving thunks to	reduce
 caller register pressure
References: <4980A07D.3010008@goop.org> <20090130210625.GD1253@ucw.cz>
In-Reply-To: <20090130210625.GD1253@ucw.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>> This patch seeks to alleviate this pressure by introducing wrapper
>> thunks that will do the register saving/restoring, so that the
>> callsite doesn't need to worry about it, but the callee function can
>> be conventional compiler-generated code.  In many cases (particularly
>> performance-sensitive cases) the callee will be in assembler anyway,
>> and need not use the compiler's calling convention.
>>
>> Standard calling convention is:
>> 	 arguments	    return	scratch
>> x86-32	 eax edx ecx	    eax		?
>>     
>
> esi edi ebp ?
>   

Those are callee-save, so the caller doesn't need to worry about 
preserving their values.

> actually standard calling convention is all arguments on stack iirc
> but we use regparm=3 for kernel...?
>   

Yes.  "standard" = "standard kernel calling convention"


    J
