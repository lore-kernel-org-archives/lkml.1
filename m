Return-Path: <linux-kernel-owner+w=401wt.eu-S932263AbZHCPL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbZHCPL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbZHCPLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:11:25 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:29096 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbZHCPLY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:11:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oy28OM85GnrDmeHZPERtdMFx04Cmuh5pAHAsDk9uB6iVWIaI+YChvGuzQ5ny4EEwgP
         GL4RqB7S1TjsOoMrSTKDVFLhzn4sh5Kr91qTV0BDjVCGH1nCx/NxnIIYr+CphmlOv3w5
         0aXjZ8cEdXxcstuuorJCGr1HNPqIwfzwh58O4=
MIME-Version: 1.0
In-Reply-To: <4A768339.9060904@zytor.com>
References: <20090718151219.GD11294@localhost.localdomain>
	 <tip-d520da1173abd1f918b7e690220e14ba0fc56cfc@git.kernel.org>
	 <20090803062024.GA22365@elte.hu> <4A768339.9060904@zytor.com>
Date: Tue, 4 Aug 2009 00:11:24 +0900
Message-ID: <961aa3350908030811n6467b2d7hf42dfd58e3a438e7@mail.gmail.com>
Subject: Re: [tip:x86/asm] x86: Introduce GDT_ENTRY_INIT()
From: Akinobu Mita <akinobu.mita@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/3 H. Peter Anvin <hpa@zytor.com>:
> Ingo Molnar wrote:
>>
>> * tip-bot for Akinobu Mita <akinobu.mita@gmail.com> wrote:
>>
>>> Commit-ID:  d520da1173abd1f918b7e690220e14ba0fc56cfc
>>> Gitweb:
>>> http://git.kernel.org/tip/d520da1173abd1f918b7e690220e14ba0fc56cfc
>>> Author:     Akinobu Mita <akinobu.mita@gmail.com>
>>> AuthorDate: Sun, 19 Jul 2009 00:12:20 +0900
>>> Committer:  Ingo Molnar <mingo@elte.hu>
>>> CommitDate: Sun, 19 Jul 2009 18:27:53 +0200
>>>
>>> x86: Introduce GDT_ENTRY_INIT()
>>>
>>> GDT_ENTRY_INIT is static initializer of desc_struct.
>>>
>>> We already have similar macro GDT_ENTRY() but it's static
>>> initializer for u64 and it cannot be used for desc_struct.
>>>
>>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>>> LKML-Reference: <20090718151219.GD11294@localhost.localdomain>
>>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>>
>
> OK, I spotted the following error, which certainly would explain a crash on
> an APM machine:
>
>        /* data */
> -       [GDT_ENTRY_APMBIOS_BASE+2]      = { { { 0x0000ffff, 0x00409200 } }
> },
> +       [GDT_ENTRY_APMBIOS_BASE+2]      = GDT_ENTRY_INIT(0x409a, 0, 0xffff),

Oops, I really should have checked the binary because the compiler should
generate same code with this patch.

> Also, we shouldn't be initializing the A bits to clear unless we actually
> plan to check the A (and D) bits... that's just a waste of CPU cycles.

I'll check it, too.
