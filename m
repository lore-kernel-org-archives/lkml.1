Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbZHMInm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbZHMInm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZHMInl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:43:41 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:49765 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbZHMInl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:43:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SmajYVXhZpXoTY2AqKazxVNiBvXUOuji3swlVU9leWF7y4HXi32WDljC9OEX0eIkkb
         x5bgTP+H3/AjUtVrzCx0Fp3EVC8oREpROggmU0S9bYF3owMlCYdiqircbxrHUB5dnMn3
         eKTZq/Cg9LLM2b5J/+fJjAWICKJ2RzxLFokxM=
Date: Thu, 13 Aug 2009 16:45:57 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Vincent Li <macli@brc.ubc.ca>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] fs/proc/task_mmu.c v1: fix clear_refs_write() input
	sanity check
Message-ID: <20090813084557.GB5663@cr0.nay.redhat.com>
References: <1250119794-8016-1-git-send-email-macli@brc.ubc.ca> <20090813020952.GA5031@cr0.nay.redhat.com> <alpine.DEB.1.00.0908122143060.22452@mail.selltech.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0908122143060.22452@mail.selltech.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 10:20:28PM -0700, Vincent Li wrote:
>On Thu, 13 Aug 2009, Amerigo Wang wrote:
>
>> On Wed, Aug 12, 2009 at 04:29:54PM -0700, Vincent Li wrote:
>> >v1 fix the compiling errors and keep the type variable name.
>> >
>> >Andrew Morton pointed out similar string hacking and obfuscated check for zero-length input
>> >at the end of the function, David Rientjes suggested to use strict_strtol to replace
>> >simple_strtol, this patch cover above suggestions, add removing of leading and trailing
>> >whitespace from user input. It does not change function behavious.
>> >
>> 
>> 
>> Sorry, what real benefits can we get from this patch?
>
>It removes the redundant and weird zero-length check at the end of the 
>function since the the function already check the returning value of 
>simple_strtol, if it is zero-length input, the function should already 
>return error -EINVAL. Also using strict_strtol would only accept ascii 
>numbers, not something like:
>>echo 1foo > /proc/pid/clear_refs
>

IIRC, many /proc files can accept input like this...

I sent a patch some time ago to "fix" this, but Andrew pointed out
that things like "1foo" can be hackish. :-/


>
>> 
>> If this is really necessary, why not other files similar to 'clear_refs'?
>> 
>
>I did the same to other functions, but Andrew pointed out making changes 
>without fully understanding the patch impact would be risky and break 
>existing applications, So I need to fully understand what those functions 
>do before I make any changes.
> 


I can't find any strong reason why this one is differernt from others
in accepting input like "1foo"...

