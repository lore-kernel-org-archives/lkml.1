Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbZAFKHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbZAFKHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 05:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbZAFKHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 05:07:13 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:20740 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbZAFKHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 05:07:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Y3M6UgpcyUPgLXcaDG3NROWbBKVog5Jk1iNeWV3UtE5RtTBNmavO2q/oMT2ztK1lWg
         ri7adX0Y825NsEEmvpuzl7vdRCkKh6bnVTDuR3UcOCxn6I+XcFR8OjwNsNZeuBwNuXyN
         d3bytVMMNt5HPQ9xj9mWOHhJeNbdhOkRO49G0=
Message-ID: <3f9a31f40901060207j24c580cfl1e8bc71ae486a4b9@mail.gmail.com>
Date: Tue, 6 Jan 2009 15:37:10 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH -tip] x86: setup.c fix style problems
Cc: "Jaswinder Singh Rajput" <jaswinder@infradead.org>,
       "x86 maintainers" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090104172114.GA32425@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231066898.27852.29.camel@jaswinder.satnam>
	 <20090104172114.GA32425@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2009 at 10:51 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> the x86-local declarations in smp.h should probably be moved into a
> separate smp_x86.h file - to avoid such trouble.
>

I think we do not need to make any new files only thing we need is to
rearrange stuff between existing files.

Currently there is no such protocol, If we follow this logic then it
will very easy for us to maintain things:

CONFIG_SMP -> asm/smp.h
CONFIG_X86_LOCAL_APIC -> asm/apic.h
CONFIG_X86_IO_APIC -> asm/io_apic.h

And if you want then I will give strict instructions so that we will
never face these problems again, like :-

asm/smp.h:

#ifndef CONFIG_SMP
#error "Including wrong file, why you need smp.h for Uniprocessor"
#else
...
#endif

Similarly for asm/apic.h and asm/io_apic.h

--
JSR
