Return-Path: <linux-kernel-owner+w=401wt.eu-S1764091AbZDAASR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764091AbZDAASR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756929AbZDAASA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:18:00 -0400
Received: from smtp-out.google.com ([216.239.45.13]:13536 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbZDAAR7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:17:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=SfjbA4/LhOr1VrYGjrbSYGzqyunjFdvNBGu7vbOvM6BKsGcFTFDrpERAgpYBSvY5/
	QxqBS0pXRf7AiS1LkLqqA==
MIME-Version: 1.0
In-Reply-To: <20090331150046.16539218.akpm@linux-foundation.org>
References: <604427e00812051140s67b2a89dm35806c3ee3b6ed7a@mail.gmail.com>
	 <20090331150046.16539218.akpm@linux-foundation.org>
Date: Tue, 31 Mar 2009 17:17:52 -0700
Message-ID: <604427e00903311717u20633bara3feca0c4f30e570@mail.gmail.com>
Subject: Re: [RFC v2][PATCH]page_fault retry with NOPAGE_RETRY
From: Ying Han <yinghan@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       mikew@google.com, rientjes@google.com, rohitseth@google.com,
       hugh@veritas.com, a.p.zijlstra@chello.nl, hpa@zytor.com,
       edwintorok@gmail.com, lee.schermerhorn@hp.com, npiggin@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Andrew. I have the patches for all the arches and i just need
to clean them up a little bit. I will send them to you ASAP.

--Ying

On Tue, Mar 31, 2009 at 3:00 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 5 Dec 2008 11:40:19 -0800
> Ying Han <yinghan@google.com> wrote:
>
>> changelog[v2]:
>> - reduce the runtime overhead by extending the 'write' flag of
>>   handle_mm_fault() to indicate the retry hint.
>> - add another two branches in filemap_fault with retry logic.
>> - replace find_lock_page with find_lock_page_retry to make the code
>>   cleaner.
>>
>> todo:
>> - there is potential a starvation hole with the retry. By the time the
>>   retry returns, the pages might be released. we can make change by holding
>>   page reference as well as remembering what the page "was"(in case the
>>   file was truncated). any suggestion here are welcomed.
>>
>> I also made patches for all other arch. I am posting x86_64 here first and
>> i will post others by the time everyone feels comfortable of this patch.
>
> I'm about to send this into Linus.  What happened to the patches for
> other architectures?
>
> Please send them over when convenient and I'll work on getting them
> trickled out to arch maintainers, thanks.
>
>
