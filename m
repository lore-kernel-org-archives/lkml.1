Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbZHTF71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbZHTF71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 01:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZHTF70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 01:59:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbZHTF70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 01:59:26 -0400
Message-ID: <4A8CE63E.9050702@suse.de>
Date: Thu, 20 Aug 2009 07:59:26 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, stable@kernel.org
Subject: Re: [REGRESSION] _end symbol missing from Symbol.map
References: <4A83B680.5000508@suse.de> <20090819093704.f1620baa.akpm@linux-foundation.org>
In-Reply-To: <20090819093704.f1620baa.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 13 Aug 2009 08:45:20 +0200 Hannes Reinecke <hare@suse.de> wrote:
> 
>> Hi all,
>>
>> with 2.6.31 'crash' on x86_64 falls flat on its face as the '_end' symbol
>> is missing from the System.map file.
>>
>> The culprit is commit 091e52c3551d3031343df24b573b770b4c6c72b6,
>> which moved the '_end' symbol into it's own section.
>> Apparently this causes kallsyms to not reference it properly.
>>
>> So either we'd need to revert part of the patch to not
>> include _end in it's own section:
>>
>> diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
>> index 59f31d2..1422df5 100644
>> --- a/arch/x86/kernel/vmlinux.lds.S
>> +++ b/arch/x86/kernel/vmlinux.lds.S
>> @@ -376,9 +376,7 @@ SECTIONS
>>                 __brk_limit = .;
>>         }
>>  
>> -       .end : AT(ADDR(.end) - LOAD_OFFSET) {
>> -               _end = .;
>> -       }
>> +       _end = .;
>>  
>>         /* Sections to be discarded */
>>         /DISCARD/ : {
>>
>> or someone has to fixup kallsyms. But this is far beyond my comfort zone.
>>
> 
> So System.map is part of the kernel API too?  Sigh.
> 
> Your email client replaces tabs with spaces.
> 
I know.

> The patch didn't have a signed-off-by:
> 
I know, too.
However, this is clearly a band-aid, and as such I reported
it more as an RFC.
One (Sam?) should really fix up kallsyms to extract the _end symbol.
Hence I didn't warrant it with a Signed-off line.

> I queued it up, and tagged it for -stable backporting.  Unless we come
> up with something better.
> 
I was sort of hoping Sam would speak up and present some better approach ...

> We might not get this into 2.6.31, in which case this fix or its
> replacement will need backporting to 2.6.30.x and 2.6.31.x (IMO).
> 
Thanks for the feedback.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
