Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbZJXBH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbZJXBH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbZJXBH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:07:56 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35873 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbZJXBHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:07:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=jcbZncCfdS2hWk/CTL7U/NZ47RtNCbLdvmjl26j5wAlj+evWmMPqAOjrGLh9n84Tvr
         ebWsBvwGoKyBUiGhm3TIw1CrQifd2Wpe7dR/oO6iy++S1Ca7+J7T5PMZCpFinRkyDWTz
         KwXOz31fc9KfR+wGkI+STwraedDdF4jENLEGc=
MIME-Version: 1.0
In-Reply-To: <1256334501-15755-1-git-send-email-marti@juffo.org>
References: <1256330234-14079-1-git-send-email-marti@juffo.org> 
	<20091023210231.GC8356@elte.hu> <1256334501-15755-1-git-send-email-marti@juffo.org>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Fri, 23 Oct 2009 23:07:38 -0200
Message-ID: <193b0f820910231807t35f8b462r1f92e28492b780e2@mail.gmail.com>
Subject: Re: [PATCH] perf tools: add compatibility with libelf 0.8 and 
	autodetect
To: Marti Raudsepp <marti@juffo.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 19:48, Marti Raudsepp <marti@juffo.org> wrote:
> On Sat, Oct 24, 2009 at 12:02 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> Mind doing a small change:
>>
>> I think we want a small cleanup here: a perf_elf_begin() wrapper in a
>> header file to hide this #ifdef. (That's how Git wraps environmental
>> libraries as well.)
>
Why don't you do something like?:

#ifdef LIBELF_NO_MMAP
#define ELF_C_READ_MMAP ELF_C_READ
#endif
+ changes to Makefile

or:

#ifndef ELF_C_READ_MMAP
#define ELF_C_READ_MMAP ELF_C_READ
#endif
