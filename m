Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab0CHLXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 06:23:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204Ab0CHLXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 06:23:19 -0500
Message-ID: <4B94DE1A.40807@redhat.com>
Date: Mon, 08 Mar 2010 13:23:06 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Intel microcode loader performance improvement
References: <20100305174203.GA19638@sgi.com> <b647ffbd1003080233y5f06797fucaca3cf839e4de57@mail.gmail.com>
In-Reply-To: <b647ffbd1003080233y5f06797fucaca3cf839e4de57@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2010 12:33 PM, Dmitry Adamushko wrote:
> On 5 March 2010 18:42, Dimitri Sivanich<sivanich@sgi.com>  wrote:
>    
>> We've noticed that on large SGI UV system configurations, running
>> microcode.ctl can take very long periods of time.  This is due to
>> the large number of vmalloc/vfree calls made by the Intel
>> generic_load_microcode() logic.
>>
>> By reusing allocated space, the following patch reduces the time
>> to run microcode.ctl on a 1024 cpu system from approximately 80
>> seconds down to 1 or 2 seconds.
>>
>> Signed-off-by: Dimitri Sivanich<sivanich@sgi.com>
>>      
> This approach seems reasonable in the scope of the current framework.
>
> Acked-by: Dmitry Adamushko<dmitry.adamushko@gmail.com>
>
> However, I think a better approach would be to have some kind of
> shared storage for loaded microcode updates. Given that for the
> majority of SMP systems all the cpus are normally updated to the very
> same new instance of microcode, it should be enough to do a search for
> the first cpu, cache the instance of microcode and then reuse it for
> others.
>
>    

And/or update processors in parallel.

-- 
error compiling committee.c: too many arguments to function

