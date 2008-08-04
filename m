Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbYHDDYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbYHDDYa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 23:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbYHDDYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 23:24:23 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:14506 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbYHDDYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 23:24:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vOZ4FHNercVkF0VDDY074tu4n/8kn8+Unuk7wG2E9sIhkmASsgdXOoUPs2am5gP6mH
         onkzM2H3qQ+GsvL5l3VIdaH+VKIP0OOBW5MYBAxd1SEepj1uke7eLdETIZwwrxxWW1pb
         pSF/o2eDNDCECjAKM2PEgVT/7fScvMlm552kA=
Message-ID: <8bd0f97a0808032024x18a31d29tb44ebc6216a2aed@mail.gmail.com>
Date: Sun, 3 Aug 2008 23:24:21 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>, "Wu, Bryan" <Bryan.Wu@analog.com>
Subject: Re: [PATCH 2/3] binfmt_elf_fdpic: Convert initial stack alignment to arch_align_stack().
Cc: "David Howells" <dhowells@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080801214448.GA13448@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080728150501.GC16555@linux-sh.org>
	 <20080728150359.GA16555@linux-sh.org>
	 <20080728150430.GB16555@linux-sh.org> <27552.1217599279@redhat.com>
	 <20080801214448.GA13448@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2008 at 5:44 PM, Paul Mundt wrote:
> On Fri, Aug 01, 2008 at 03:01:19PM +0100, David Howells wrote:
>> Paul Mundt <lethal@linux-sh.org> wrote:
>> > +    * In some cases (e.g. Hyper-Threading), we want to avoid L1
>> > +    * evictions by the processes running on the same package. One
>> > +    * thing we can do is to shuffle the initial stack for them, so
>> > +    * we give the architecture an opportunity to do so here.
>> > +    */
>> >  #ifdef CONFIG_MMU
>> > -   sp = bprm->p;
>> > +   sp = arch_align_stack(bprm->p);
>> >  #else
>> > -   sp = mm->start_stack;
>> > +   sp = arch_align_stack(mm->start_stack);
>>
>> Ummm...  You're calling arch_align_stack() under NOMMU...  Is that really a
>> good idea?
>
> Not particularly, no.
>
>> You can't necessarily move the stack pointer without exiting the allocated
>> region or shrinking the amount of stack space the executable asked for.  If
>> you want to do this sort of thing, you need to tell the memory allocator what
>> you're up to - or at the very least allocate some slack.
>
> Yes, that's a good point, and one that probably ought to be documented
> alongside the initial alignment. I'll send an updated patch.

fs/binfmt_elf_fdpic.c: In function 'create_elf_fdpic_tables':
fs/binfmt_elf_fdpic.c:497: error: implicit declaration of function
'arch_align_stack'
make[1]: *** [fs/binfmt_elf_fdpic.o] Error 1
make: *** [fs] Error 2

Blackfin lacks a arch_align_stack(x) in asm-blackfin/system.h ... i
imagine a stub will work for us like every other arch though

feel like doing that Bryan ?  i'm guessing Paul doesnt want to ... ;)
-mike
