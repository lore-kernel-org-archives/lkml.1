Return-Path: <linux-kernel-owner+w=401wt.eu-S1758518AbYJIGXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbYJIGXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 02:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbYJIGWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 02:22:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:1612 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbYJIGWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 02:22:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=hDBMz9YgGMbzVsfgBKy7p9+1kbo+DsmW6Ucu+pZTDkLgnSt6AyH3Xr11p04e90JWzP
         m3YYTcO9oYMPgrk/tf4+IUVik7ebAtRf3ssCpoRWNEa6YtD/6nBxlZNc8pnH7oou5x93
         K8u0cXyJffEkPGrP9u9xO3d1ZVfdl765CCbTg=
Message-ID: <86802c440810082322s4eb7e7e6ib60f68de316b06bc@mail.gmail.com>
Date: Wed, 8 Oct 2008 23:22:50 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Shaohua Li" <shaohua.li@intel.com>
Subject: Re: [patch]x86: arch_add_memory round up address
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@redhat.com>
In-Reply-To: <1223532485.7312.0.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223530290.30941.9.camel@sli10-desk.sh.intel.com>
	 <86802c440810082304j3274555etb7eca011f7459253@mail.gmail.com>
	 <1223532485.7312.0.camel@sli10-desk.sh.intel.com>
X-Google-Sender-Auth: 40de48177d8a6ecc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2008 at 11:08 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> On Thu, 2008-10-09 at 14:04 +0800, Yinghai Lu wrote:
>> On Wed, Oct 8, 2008 at 10:31 PM, Shaohua Li <shaohua.li@intel.com> wrote:
>> > Round up address to a page, otherwise the last page isn't mapped.
>> >
>> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>> > ---
>> >  arch/x86/mm/init_64.c |    3 ++-
>> >  1 file changed, 2 insertions(+), 1 deletion(-)
>> >
>> > Index: linux/arch/x86/mm/init_64.c
>> > ===================================================================
>> > --- linux.orig/arch/x86/mm/init_64.c    2008-10-09 11:42:33.000000000 +0800
>> > +++ linux/arch/x86/mm/init_64.c 2008-10-09 11:43:22.000000000 +0800
>> > @@ -721,7 +721,8 @@ int arch_add_memory(int nid, u64 start,
>> >        unsigned long nr_pages = size >> PAGE_SHIFT;
>> >        int ret;
>> >
>> > -       last_mapped_pfn = init_memory_mapping(start, start + size-1);
>> > +       last_mapped_pfn = init_memory_mapping(start,
>> > +               round_up(start + size-1, PAGE_SIZE));
>> >        if (last_mapped_pfn > max_pfn_mapped)
>> >                max_pfn_mapped = last_mapped_pfn;
>>
>> should use
>>
>> last_mapped_pfn = init_memory_mapping(start, start + size);
> No, this still can't guarantee page aligned, though this works in my
> test

who will call arch_add_memory? that should be start and size already
be page aligned.

YH
