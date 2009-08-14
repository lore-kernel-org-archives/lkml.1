Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbZHNXVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbZHNXVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 19:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311AbZHNXVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 19:21:33 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:65301 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbZHNXVb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 19:21:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YWlxevpUWZrgXgFp/xMQwsJQ4PVY7YNyaCSblsgua7M6VJVILH6zLELb6CX/vcKQTZ
         qEqvXpahnxuBJYoLuaWcEohASSiq/fRAZR/Au27YwPiQlvB/JveGHa/zaZL6CuAYqep4
         TyvkVy3/hZsut5o32AkRYKPXaaaIYF7UZCbn4=
MIME-Version: 1.0
In-Reply-To: <4A85E0DC.9040101@rtr.ca>
References: <200908122007.43522.ngupta@vflare.org>
	 <Pine.LNX.4.64.0908122312380.25501@sister.anvils>
	 <20090813151312.GA13559@linux.intel.com>
	 <20090813162621.GB1915@phenom2.trippelsdorf.de>
	 <alpine.DEB.1.10.0908130931400.28013@asgard.lang.hm>
	 <87f94c370908131115r680a7523w3cdbc78b9e82373c@mail.gmail.com>
	 <alpine.DEB.1.10.0908131342460.28013@asgard.lang.hm>
	 <3e8340490908131354q167840fcv124ec56c92bbb830@mail.gmail.com>
	 <4A85E0DC.9040101@rtr.ca>
Date: Fri, 14 Aug 2009 17:21:32 -0600
Message-ID: <f3177b9e0908141621j15ea96c0s26124d03fc2b0acf@mail.gmail.com>
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap 
	slot is freed)
From: Chris Worley <worleys@gmail.com>
To: Mark Lord <liml@rtr.ca>
Cc: Bryan Donlan <bdonlan@gmail.com>, david@lang.hm,
       Greg Freemyer <greg.freemyer@gmail.com>,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 4:10 PM, Mark Lord<liml@rtr.ca> wrote:
> Bryan Donlan wrote:
> ..
>>
>> Perhaps an interface (ioctl, etc) can be added to ask a filesystem to
>> discard all unused blocks in a certain range? (That is, have the
>> filesystem validate the request under any necessary locks before
>> passing it to the block IO layer)
>
> ..
>
> While possibly TRIM-specific, this approach has the lowest overhead
> and probably the greatest gain-for-pain ratio.
>
> But it may not be as nice for enterprise (?).
>
> On the Indilinx-based SSDs (eg. OCZ Vertex), TRIM seems to trigger an
> internal garbage-collection/erase cycle.  As such, the drive really prefers
> a few LARGE trim lists, rather than many smaller ones.
>
> Here's some information that a vendor has observed from the Win7 use of
> TRIM:
>
>> TRIM command is sent:
>> -       About 2/3 of partition is filled up, when file is deleted.
>>        (I am not talking about send file to trash bin.)
>> -       In the above case, when trash bin gets emptied.
>> -       In the above case, when partition is deleted.
>>
>> TRIM command is not sent:-
>> -       When file is moved to trash bin
>> -       When partition is formatted. (Both quick and full format)
>> -       When empty partition is deleted
>> -       When file is deleted while there is big remaining free space
>
> ..
>
> His words, not mine.  But the idea seems to be to batch them in large
> chunks.

Sooner is better than waiting to coalesce.  The longer an LBA is
inactive, the better for any management scheme.  If you wait until
it's reused, you might as well forgo the advantages of TRIM/UNMAP.  If
a the controller wants to coalesce, let it coalesce.

Chris
>
> My wiper.sh "trim script" is packaged with the latest hdparm (currently
> 9.24)
> on sourceforge, for those who want to try this stuff for real.  No special
> kernel support is required to use it.
>
> Cheers
>
> Mark
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
