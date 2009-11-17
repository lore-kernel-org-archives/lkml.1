Return-Path: <linux-kernel-owner+w=401wt.eu-S1755064AbZKQR75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbZKQR75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbZKQR74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:59:56 -0500
Received: from mail-qy0-f174.google.com ([209.85.221.174]:57368 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbZKQR7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:59:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vTsezK9xfDKSjheSJc0q41I1ZKx09J5P5HN4FSW47OugtTJCHuJUnZcym8E2O1frD6
         ivNmdxucpoWJpX6fp8ELEkfuDmO1LKTqt+QxYskPO4zDw2zWvA7dzVS8wkEtEXHm1DB5
         vItaoaiu1jab20YJsTJOOVzpcNCy5cDXW7DgQ=
Date: Tue, 17 Nov 2009 20:59:47 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Mike Travis <travis@sgi.com>
Cc: David Miller <davem@davemloft.net>, hpa@zytor.com, mingo@elte.hu,
       tglx@linutronix.de, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, rdreier@cisco.com, rdunlap@xenotime.net,
       tj@kernel.org, andi@firstfloor.org, gregkh@suse.de,
       yhlu.kernel@gmail.com, rientjes@google.com, rostedt@goodmis.org,
       rusty@rustcorp.com.au, seto.hidetoshi@jp.fujitsu.com, steiner@sgi.com,
       fweisbec@gmail.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] INIT: Limit the number of per cpu calibration
	bootup messages
Message-ID: <20091117175947.GE5476@lenovo>
References: <20091116215052.GK5653@lenovo> <20091116.190922.182816918.davem@davemloft.net> <20091117155946.GA5476@lenovo> <20091117.082928.10537098.davem@davemloft.net> <20091117174204.GD5476@lenovo> <4B02E242.8040800@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B02E242.8040800@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 09:49:54AM -0800, Mike Travis wrote:
...
>>> And if we do need it generically, it's available there as
>>> hard_smp_processor_id() when start_kernel() is called.  So init/main.c
>>> could remember that value in an __initdata annotated static variable.
>>>
>>> But just using a boolean for this "did I print the bogomips message
>>> already?" thing seems more than sufficient.
>>>
>>
>> Yes. As I see Mike already pick it up. Thanks David!
>>
>> 	-- Cyrill
>
> I'd like to say that, but Peter wanted it to become an inlined function
> return value, and there are too many references in too many arches to
> a scalar value, so that moves it out of the scope of this patch set.

I meant only "local static variable being used for printing to suppress recursion"
idea rather then boot_cpu_id() inliner at moment [btw there was some thread
someday about printk_once (or something like that) though I'm not sure if patches
were merged] :) As only the inliner will be ready we will just switch to use it
eliminating this static variable. That is how I imagine it.

> Thanks,
> Mike
>
	-- Cyrill
