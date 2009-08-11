Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbZHKMqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbZHKMqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbZHKMqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:46:12 -0400
Received: from mail-yw0-f191.google.com ([209.85.211.191]:32841 "EHLO
	mail-yw0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbZHKMqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:46:09 -0400
X-Greylist: delayed 3231 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Aug 2009 08:46:09 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ayy2rbXErtIpISAnx3/YZAoPtg/jcVlTc4BtbUISpIfIV3H9CHw1XYFt7PHTatJK28
         t1QyaAeIpIFErJaN1ef6jq3yPiRWVacibrdEqebGRDR1wRHXU4XzAc6GHU+Ry7bG7wji
         oSQvWmdKYFTme1vmUJPwba72bRcpMjCc2cJpk=
Message-ID: <4A81331F.7010908@gmail.com>
Date: Tue, 11 Aug 2009 11:00:15 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-7.3 Thunderbird/3.0b3
MIME-Version: 1.0
To: roel kluin <roel.kluin@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] applicom: Prevent unsigned wrap in ac_interrupt()
References: <4A7D961A.1020303@gmail.com> <4A7F31F6.9000706@gmail.com> <25e057c00908110154g48241b85td089e6726109b581@mail.gmail.com>
In-Reply-To: <25e057c00908110154g48241b85td089e6726109b581@mail.gmail.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2009 10:54 AM, roel kluin wrote:
>>> unsigned i wraps if this occurs in the first iteration.
>>
>> Could you elaborate? I don't quite understand the point.
> 
> `i' is unsigned. The last test in the loop is:
> 
> if(readb(apbs[i].RamIO + RAM_IT_TO_PC)) {
>         /* There's another int waiting on this card */
>         spin_unlock(&apbs[i].mutex);
>         i--;
> } else {
>         spin_unlock(&apbs[i].mutex);
> }
> 
> In the first iteration `i' is 0, so if this condition evaluates to true
> then `i' becomes 0xffffffff (since it's unsigned), the for loop test
> fails and the i++ never occurs.

Hmm, no. This is not how three `for' expressions are evaluated. The CFG
of "for (a; b; c) d;" is "a->(b->d->c)*". Read 6.8.5.3 of ANSI C99.

I.e. 0xff increments back to 0.

Am I still missing something?
