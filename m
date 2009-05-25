Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbZEYLiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbZEYLiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 07:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbZEYLiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 07:38:00 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:54475 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZEYLh7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 07:37:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rcN2XvOEWd6x6zwK0Iv0SJJd2KkPfmTurrsfiNTrluP5RPe/bEtDKkKYkO8h1gxYg+
         TAyH5wdhhzgd/PKo08vk0zXgPoxAkHbd8AId/SD4HYvS2nZyQO/5oiJgiTUhygQU7ULF
         ShxsFXaG7OMPy0UINdTp6sVzPr7uOvsimdMKc=
MIME-Version: 1.0
In-Reply-To: <20090525112504.GB24071@wotan.suse.de>
References: <20090518190320.GA20260@elte.hu> <20090518202031.GA26549@elte.hu>
	 <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain>
	 <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI>
	 <4A199327.5030503@kernel.org> <20090525025353.GA2580@elte.hu>
	 <4A1A2261.1000504@kernel.org> <20090525051521.GC23032@elte.hu>
	 <Pine.LNX.4.64.0905251142140.32568@melkki.cs.Helsinki.FI>
	 <20090525112504.GB24071@wotan.suse.de>
Date: Mon, 25 May 2009 14:37:59 +0300
X-Google-Sender-Auth: 70b77715f2fd4a41
Message-ID: <84144f020905250437x585e66a2oc1124a4f1f43059d@mail.gmail.com>
Subject: Re: [GIT PULL] scheduler fixes
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, cl@linux-foundation.org,
       mpm@selenic.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 2:25 PM, Nick Piggin <npiggin@suse.de> wrote:
>> @@ -576,6 +576,22 @@ asmlinkage void __init start_kernel(void)
>>       setup_nr_cpu_ids();
>>       smp_prepare_boot_cpu(); /* arch-specific boot-cpu hooks */
>>
>> +     build_all_zonelists();
>> +     page_alloc_init();
>> +
>> +     printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
>> +     parse_early_param();
>> +     parse_args("Booting kernel", static_command_line, __start___param,
>> +                __stop___param - __start___param,
>> +                &unknown_bootoption);
>> +     /*
>> +      * Setup kernel memory allocators
>> +      */
>> +     pidhash_init();
>> +     vmalloc_init();
>> +     vfs_caches_init_early();
>> +     mem_init();
>> +     kmem_cache_init();

On Mon, May 25, 2009 at 2:25 PM, Nick Piggin <npiggin@suse.de> wrote:
> Looks quite OK to me. The comment above maybe misleading?
>
> The bootmem allocations of course are required because some hashes may
> need to be larger than MAX_ORDER without using vmalloc.
>
> kmem_cache_init (and mem_init, partially) sets up the kernel memory
> allocators...

Which comment are you talking about? The "setup kernel memory
allocators" one? Yeah, I should probably move it couple of lines down.
It's just that we absolutely need to do the other ones before calling
mem_init() and then kmem_cache_init().

On Mon, May 25, 2009 at 2:25 PM, Nick Piggin <npiggin@suse.de> wrote:
> I can take a look at the SLQB side.

Great!

                        Pekka
