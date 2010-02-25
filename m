Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786Ab0BYBzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 20:55:55 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:35346 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758752Ab0BYBzw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 20:55:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FWcdjeg+oShzOey6IHy1crJjWdtqZoux46iWwH7kCorFKtra9bXERlysPX2/vonsOw
         GNQDC27r0P4DZmEZC2qjtGZ5BQUHTdYjnBJYKpktrs53/50akMUbdygUTsUIU/joHo5G
         koZHke9vmrPYIeCEmLYw6Tu8TcdqTCbs4MZFE=
MIME-Version: 1.0
In-Reply-To: <20100224213406.GA7491@nowhere>
References: <201002242107.o1OL7F6v020376@imap1.linux-foundation.org>
	 <20100224213406.GA7491@nowhere>
Date: Thu, 25 Feb 2010 09:55:51 +0800
Message-ID: <a8e1da1002241755j3cc1738agdb414b9572f48e95@mail.gmail.com>
Subject: Re: + kernelh-printk-panic-string-cleanup.patch added to -mm tree
From: Dave Young <hidave.darkstar@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: akpm@linux-foundation.org, Steven Rostedt <rostedt@goodmis.org>,
       mm-commits@vger.kernel.org, gregkh@suse.de,
       kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 5:34 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Wed, Feb 24, 2010 at 01:07:15PM -0800, akpm@linux-foundation.org wrote:
>>
>> The patch titled
>>      kernel.h: printk/panic/string cleanup
>> has been added to the -mm tree.  Its filename is
>>      kernelh-printk-panic-string-cleanup.patch
>>
>> Before you just go and hit "reply", please:
>>    a) Consider who else should be cc'ed
>>    b) Prefer to cc a suitable mailing list as well
>>    c) Ideally: find the original patch on the mailing list and do a
>>       reply-to-all to that, adding suitable additional cc's
>>
>> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>>
>> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
>> out what to do about this
>>
>> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
>
>
>
> Andrew, please don't merge this patch.
>
> I'm not against the idea kernel.h gets split up a bit, by having
> a prink.h and panic.h included from kernel.h for example.
>
> But this patch breaks bisection: some tracing general helpers are
> removed here but re-integrated in a different header only in a subsequent
> patch in the series. This should be done in the same patch, otherwise it
> breaks the build in the middle of the set.

Yeah, my wrong, I will send a update version of this patch. Thank you.

>
> The other problem, as Steve noticed, is that the tracing prototypes are
> moved in ring_buffer.h (in the subsequent patch), which is not the right
> place as the ring buffer is not only for tracing purpose. And also
> it moves functions out of kernel.h while these are really useful for
> general purposes.
>
> That said, it's probably sane to think about a new header to put
> these tracing prototypes, if it's included by kernel.h,
> linux/ftrace.h is already filled with non-general purpose things.
> So may be linux/trace.h ? Yeah this could be confusing, Steve what
> do you think?
>
> And all in one, it would probably better to split this in three
> patches: one that moves printk helpers out of kernel.h to printk.h,
> another following the same pattern for panic things and another one
> for tracing things.

Fine to me.

>
> Thanks.
>
>



-- 
Regards
dave
