Return-Path: <linux-kernel-owner+w=401wt.eu-S1759113AbZGCUF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113AbZGCUF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 16:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757853AbZGCUFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 16:05:49 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:64873 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588AbZGCUFs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 16:05:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v1cjLa8PvjPSUWHCHsr8Mhab6Ct9sTqhYJxxpTtaIMLGygkjdkqIxB1UO7IK7mY+Ok
         ZGo/APxoobYvDpF2geaWrB6ZohtDI53FbJzHC6f9JY/6xSY8vwaHVCj2VYS94OYNAU+w
         TxnI3A3PBs04DsnYO8zxy5QlaPyFetWWN8PoQ=
MIME-Version: 1.0
In-Reply-To: <20090703174031.GA12410@cynthia.pants.nu>
References: <abe8a1fd0907022344k2eb9874ejdbda3209a7cadf40@mail.gmail.com>
	 <20090703174031.GA12410@cynthia.pants.nu>
Date: Sat, 4 Jul 2009 01:35:50 +0530
Message-ID: <abe8a1fd0907031305r5cb9e2e8pec170bffb1c497ff@mail.gmail.com>
Subject: Re: Inline assembly queries [2]
From: kernel mailz <kernelmailz@googlemail.com>
To: Brad Boyer <flar@allandria.com>
Cc: linuxppc-dev@ozlabs.org, gcc-help@gcc.gnu.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brad,
Thanks for responding.
My query was more on %U1%X1, I guess it is specifying U and/or X for %1 right ?
what does U/X stand for (is it similar to u - unsigned and x for a hex address)
are there any more literals like U/X/...

-Manish

On Fri, Jul 3, 2009 at 11:10 PM, Brad Boyer<flar@allandria.com> wrote:
> On Fri, Jul 03, 2009 at 12:14:41PM +0530, kernel mailz wrote:
>> Thanks for responding to my previous mail. A few more queries
>>
>> a. What is the use of adding format specifiers in inline assembly
>> like
>> asm volatile("ld%U1%X1 %0,%1":"=r"(ret) : "m"(*ptr) : "memory");
>
> The format specifiers limit which registers or addressing modes will
> be chosen to access that parameter. For example, if you're using an
> instruction that treats r0 as a literal 0 value, you can't use the
> "r" specifier for that or you may see problems if it happens to allocate
> r0 for that particular argument. For memory access, the "m" lets you
> use any of the normal load/store patterns (which is why this particular
> choice also requires the "%U1%X1" part to allow changing the instruction).
> The system was setup for an older style chip like x86 or 68k with many
> restrictions on which registers can be used where and large numbers of
> different addressing modes for accessing memory. It's a little clumsy
> for ppc by comparison to most other chips, but it's a fundamental part
> of inline assembly processing in gcc.
>
>> b. using m or Z  with a memory address. I tried replacing m/Z but no change
>> Is there some guideline ?
>> gcc documentation says Z is obsolete. Is m/Z replaceable ?
>
> No idea. I don't remember ever seeing 'Z' used in anything. Maybe somebody
> else remembers what it used to mean.
>
>        Brad Boyer
>        flar@allandria.com
>
>
