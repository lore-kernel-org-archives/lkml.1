Return-Path: <linux-kernel-owner+w=401wt.eu-S938803AbXHIFtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938803AbXHIFtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 01:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbXHIFtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 01:49:10 -0400
Received: from gw.goop.org ([64.81.55.164]:59969 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760907AbXHIFtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 01:49:09 -0400
Message-ID: <46BAAA6E.2060208@goop.org>
Date: Wed, 08 Aug 2007 22:47:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4/25] [PATCH] Add debugreg/load_rsp native hooks
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865467662182-git-send-email-gcosta@redhat.com> <11865467702103-git-send-email-gcosta@redhat.com> <200708081116.43237.ak@suse.de>
In-Reply-To: <200708081116.43237.ak@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> @@ -264,13 +270,64 @@ struct thread_struct {
>>  	set_fs(USER_DS);							 \
>>  } while(0)
>>
>> -#define get_debugreg(var, register)				\
>> -		__asm__("movq %%db" #register ", %0"		\
>> -			:"=r" (var))
>> -#define set_debugreg(value, register)			\
>> -		__asm__("movq %0,%%db" #register		\
>> -			: /* no output */			\
>> -			:"r" (value))
>> +static inline unsigned long native_get_debugreg(int regno)
>> +{
>> +	unsigned long val;
>>     
>
> It would be better to have own functions for each debug register I think
>   

?  A separate pvop for each?  Seems excessive.  And surely this should
be identical to 32bit either way.

    J
