Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411Ab0CMXpB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 18:45:01 -0500
Received: from mail-iw0-f176.google.com ([209.85.223.176]:63211 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab0CMXo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 18:44:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=T0Rl19wqQ76WKPP9un/6JEXpUpmXAtJkhpD2LCG+UUILkyoOOJXWGpTUOJNHNlOhrT
         YxIZa2Ml99ryZXXo5+bfDg9V1SMOoGr1vZ5GeFVS0dO60EmcllZOHcMvsTDnhNBUwoyi
         PnAEms07lkeQ77LxBL6vDua0f3gvWj5enyVgk=
Message-ID: <4B9C2376.9040309@gmail.com>
Date: Sat, 13 Mar 2010 17:44:54 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: s ponnusa <foosaa@gmail.com>
CC: Greg Freemyer <greg.freemyer@gmail.com>, Mark Lord <kernel@teksavvy.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       linux-mm@kvack.org
Subject: Re: Linux kernel - Libata bad block error handling to user mode 
 program
References: <f875e2fe1003032052p944f32ayfe9fe8cfbed056d4@mail.gmail.com>	 <20100303224245.ae8d1f7a.akpm@linux-foundation.org>	 <87f94c371003040617t4a4fcd0dt1c9fc0f50e6002c4@mail.gmail.com>	 <4B8FC6AC.4060801@teksavvy.com>	 <87f94c371003111029s7c7daebgf691ab11e6bdda25@mail.gmail.com> <f875e2fe1003131444p238ad546xdadb3fca530fb074@mail.gmail.com>
In-Reply-To: <f875e2fe1003131444p238ad546xdadb3fca530fb074@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2010 04:44 PM, s ponnusa wrote:
> Had some issues with the libata in 2.6.27 kernel's libata code, but
> believe the issues were fixed in the subsequent versions. Atleast one
> prominent issue was with a Western Digital HDD of 40 GB size. The
> manufacturer specific LBA was 78125000 and was reported as correctly
> in Win32 and DOS applications. But the 2.6.27 kernel was reporting
> ~40000 sectors more. But the problem dissappeared with the 2.6.3x
> kernel and I did not bother to check the patches due to lack of time.
> But still, the write's failure is not being seen by the application. I
> can understand the fact of not checking the media errors during the
> write operation, and had posted a request for a quick suggestions of
> the locations which needs to be changed / checked for the return
> value. ( Should it be handled at the vfs or at the libata code?). Will
> surely update the testing results with the new kernel (Well, not
> exactly as I am not using the latest version though! Currently trying
> with 2.6.31). Thank you all for suggestions.

It's quite likely for write errors not to be noticed by the application. 
Even if the drive does report a write error, the application that wrote 
the data could have completed the write and even closed the file or 
exited before the data actually gets written to disk. Only if fsync (or 
related functions) are called on the file is it guaranteed that the data 
has been written out to the drive (and any generated errors should be 
seen at that time).

> -
> SP
>
> On Thu, Mar 11, 2010 at 1:29 PM, Greg Freemyer<greg.freemyer@gmail.com>  wrote:
>>>
>>> But really.. isn't "hdparm --security-erase NULL /dev/sdX" good enough ???
>>>
>>
>> This thread seems to have died off.  If there is a real problem, I
>> hope it picks back up.
>>
>> Mark, as to your question the few times I've tried that the bios on
>> the test machine blocked the command.  So it may have some specific
>> utility, but it's a not a generic solution in my mind.
>>
>> Greg
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

