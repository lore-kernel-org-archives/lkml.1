Return-Path: <linux-kernel-owner+w=401wt.eu-S1758343AbYG1Pa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343AbYG1Pa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340AbYG1Pag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:30:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:29901 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbYG1Pae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:30:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=QOH+6uZWnlmvPuBLpPlB/xz/j2afODAii+f4Q0TOFzNlMvY992BS5w40sk0Cyk/pLp
         ubqGuGOPdA+nD0S2x7uJdrJZgqwPnyTJVOvmjFEFzR2Hp/Hxy4XNp9jtMNoiu8lIAYmz
         UQ1A2nSg8qaaGng5dToVE/6+hL3fdYm47+aQI=
Message-ID: <2c0942db0807280830n621922vdb5e9fdb6c66d48f@mail.gmail.com>
Date: Mon, 28 Jul 2008 08:30:34 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: PERF: performance tests with the split LRU VM in -mm
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
In-Reply-To: <20080728105742.50d6514e@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080724222510.3bbbbedc@bree.surriel.com>
	 <20080728105742.50d6514e@cuia.bos.redhat.com>
X-Google-Sender-Auth: 9e4b4c149333894e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 7:57 AM, Rik van Riel <riel@redhat.com> wrote:
> On Thu, 24 Jul 2008 22:25:10 -0400
> Rik van Riel <riel@redhat.com> wrote:
>
>>   TEST 1: dd if=/dev/sda of=/dev/null bs=1M
>>
>> kernel  speed    swap used
>>
>> 2.6.26  111MB/s  500kB
>> -mm     110MB/s  59MB     (ouch, system noticably slower)
>> noforce       111MB/s  128kB
>> stream  108MB/s  0        (slight regression, not sure why yet)
>>
>> This patch shows that the split LRU VM in -mm has a problem
>> with large streaming IOs: the working set gets pushed out of
>> memory, which makes doing anything else during the big streaming
>> IO kind of painful.
>>
>> However, either of the two patches posted fixes that problem,
>> though at a slight performance penalty for the "stream" patch.
>
> OK, the throughput number with this test turns out not to mean
> nearly as much as I thought.
>
> Switching off CPU frequency scaling, pinning the CPUs at the
> highest speed, resulted in a throughput of only 102MB/s.
>
> My suspicion is that faster running code on the CPU results
> in IOs being sent down to the device faster, resulting in
> smaller IOs and lower throughput.

Or the IOs are getting sent in a different order, and so
coalescing/merging isn't occurring as often. Getting some
instrumentation (something as simple as a histogram) on the IO sizes
could be useful.
