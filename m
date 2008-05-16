Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYEPEoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYEPEoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 00:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbYEPEoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 00:44:11 -0400
Received: from smtp2a.orange.fr ([80.12.242.139]:19500 "EHLO smtp2a.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbYEPEoL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 00:44:11 -0400
X-ME-UUID: 20080516044409503.7ACC27000090@mwinf2a07.orange.fr
Message-ID: <482D1110.2040604@cosmosbay.com>
Date: Fri, 16 May 2008 06:44:00 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] modules: Use a better scheme for refcounting
References: <482C9FC5.2070508@cosmosbay.com> <87ej83z0va.fsf@basil.nowhere.org>
In-Reply-To: <87ej83z0va.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen a écrit :
> Eric Dumazet <dada1@cosmosbay.com> writes:
>   
>> Instead of wasting NR_CPUS*128 bytes (on i386), we now use
>> num_possible_cpus*sizeof(local_t) bytes.
>>
>> On a typical distro, where NR_CPUS=8, 
>>     
>
> More typical would be NR_CPUS=128, with NR_CPUS=four digits 
> when Mike Travis et.al. are finished
>
>   
Yes. With NR_CPUS=4096, we save about half a megabyte per module. (!!!)

>> shiping 2000 modules, we reduce
>>     
>
> Surely only the loaded modules count? Perhaps 20-30.
>
>   
Well, I should have stated that this saving also takes place in the 
module disk file.
(The "struct module" is included in it, in the 
".gnu.linkonce.this_module" section)
Here on my distro, around 2000 modules are shiped.
> But it's a cool improvement. Very nice.
>   
Thanks




