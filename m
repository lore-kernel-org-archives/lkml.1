Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbZFQQb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbZFQQb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758054AbZFQQb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:31:27 -0400
Received: from claw.goop.org ([74.207.240.146]:50782 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758214AbZFQQb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:31:27 -0400
Message-ID: <4A391A54.7000109@goop.org>
Date: Wed, 17 Jun 2009 09:31:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: Greg Kroah-Hartman <greg@kroah.com>, Brian Swetland <swetland@google.com>,
       arve@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny	&&	usage
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>	 <4A380494.6030506@goop.org> <1245249469.5982.251.camel@desktop>	 <4A390B9A.40806@goop.org> <1245254936.5982.261.camel@desktop>
In-Reply-To: <1245254936.5982.261.camel@desktop>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/09 09:08, Daniel Walker wrote:
> On Wed, 2009-06-17 at 08:28 -0700, Jeremy Fitzhardinge wrote:
>    
>> I have a general code-cleanup rule to
>> convert:
>>
>> 	foo = false;
>> 	if (something_is_true())
>> 		foo = true;
>>
>> to
>>
>> 	foo = something_is_true();
>>      
>
> Above seems more like a speed up, rather than a clean up. I would think
> it's likely fine for a lot of cases tho.
>    

The compiler should be smart enough to generate identical code in both 
cases.  I think the second is better because it more directly expresses 
what you're trying to do: you have a boolean predicate, and you're 
assigning it to a boolean variable.  The if() form has the same effect, 
but couches it in terms of control flow which is just obfuscation.

> I was hoping Brian could explain this. I also added Arve (the author) to
> the CC list. Maybe they can explain the purpose of the subsystem.
>    

Also, what its usermode ABI is, how stable it is, whether its generally 
useful, does it have glibc/other library support, etc.  Would you ever 
want to use this in a non-Android context?

> Was this a recent change to C99, cause my compiler still doesn't know
> about it .. I also see a couple places in the kernel where bool is
> getting typedef'ed or somehow declared..
>    

The C99 type has some stupid name like "_Bool", but the kernel typedefs 
it to bool everywhere.

     J
