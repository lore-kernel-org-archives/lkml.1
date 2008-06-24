Return-Path: <linux-kernel-owner+w=401wt.eu-S1761308AbYFXRRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761308AbYFXRRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760001AbYFXRQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:16:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:11831 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759913AbYFXRQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:16:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IWfgiWH/Ywcf1OxK/Cw13HGIObrw0Dq8zi3APO1S/dugXsNHvURm7+VdtttMRXD6mj
         +Dw6e69BnIEyoWLyBDJkd53rTY5OtQSQumsQdjei8EcfrflooqzkpyByoa9oUKwn15OT
         vt577dXJKbaEZzBWnzmgakSXEirsGUwtJtFiQ=
Message-ID: <86802c440806241016l2baf05b9le356fdc314a2af9@mail.gmail.com>
Date: Tue, 24 Jun 2008 10:16:29 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: introduce init_memory_mapping for 32bit
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080624113049.GA7731@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806231951.10898.yhlu.kernel@gmail.com>
	 <200806240410.47856.yhlu.kernel@gmail.com>
	 <20080624113049.GA7731@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 4:30 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> so could use mem below max_low_pfn as early. could move several
>> function more early instead of waiting after paging_init including
>> moving relocate_initrd early, and kva related early done in
>> initmem_init
>
> applied to tip/x86/setup-memory - thanks Yinghai.
>
> a sidenote:
>
>>  6 files changed, 128 insertions(+), 74 deletions(-)
>
> this patch is too large - if it causes any problems it will not be very
> easy to figure out which exact change caused the problems.
>
> Lets hope it goes all fine - but in the future lets try doing
> more+smaller patches, especially if they change some known-dangerous
> area of the kernel.
>
> For example here a better splitup would have been to do 5 or more
> patches:
>
>  1) first introduce init_memory_mapping() [but dont use it anywhere]
>  2) add the init_memory_mapping() call to setup_arch()
>  3) move remap_numa_kva()
>  4) move relocate_initrd()
>  5) remove the now unnecessary setup from paging_init()
>
> ... or something like that. The point is to manage risk: if there's
> multiple problem areas that a change is touching, try to isolate them
> from each other and introduce the change gradually.
>
> The end result is still exactly the same, but much more
> reviewable/debuggable/bisectable.

actually i added and tested that one by one. let me check if i split
that into 5.

YH
