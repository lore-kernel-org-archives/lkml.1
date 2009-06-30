Return-Path: <linux-kernel-owner+w=401wt.eu-S1756704AbZF3Ooy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbZF3Ooy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 10:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZF3Ooq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 10:44:46 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:34656 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbZF3Oop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 10:44:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CIzZV8uspiauS3/eHZrYzU0fKxga0XM16rg8Xig/3Sh0hbiQgZIaifTBp8mhM2Imp1
         a8tzDWJ1R2R4M4IYStZO0uzd08yHPCpVnKvodBCUwxbuGgF7AhIjratwy4j09OGDTScM
         irqotNWe9GreS1hl5Fbwq3JYGrNrcbJywd718=
MIME-Version: 1.0
In-Reply-To: <20090630062939.4878fcbe@infradead.org>
References: <817ecb6f0906290816t2537e5des3b78b32c6fd16700@mail.gmail.com>
	 <20090629083051.232bac68@infradead.org>
	 <817ecb6f0906300611s3b21b85by54e689e073bd2012@mail.gmail.com>
	 <20090630062939.4878fcbe@infradead.org>
Date: Tue, 30 Jun 2009 10:44:46 -0400
Message-ID: <817ecb6f0906300744i4f11d7faldd10ef3834582812@mail.gmail.com>
Subject: Re: [PATCH v2] RO/NX protection for loadable kernel modules
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 9:29 AM, Arjan van de Ven<arjan@infradead.org> wrote:
> On Tue, 30 Jun 2009 09:11:33 -0400
> Siarhei Liakh <sliakh.lkml@gmail.com> wrote:
>
>> > (and one can still argue that making this an option is not even
>> > worth that, and just always do it unconditional)
>> >
>>
>> I can make NX unconditional. However, it will not reduce the number
>> of #ifdefs. There are two of them in the patch right now: one
>> controls the inclusion of two extra fields (init_ro_size,
>> core_ro_size) in struct module, and the other one controls the
>> inclusion of ALL patch code. The *_ro_size fields are used only for
>> RO, and are not used to set NX. Therefore, this #ifdef will stay even
>> if NX is unconditional. Since the second #ifdef controls ALL of the
>> patch's code it will also stay (to control RO part) when NX becomes
>> unconditional.
>>
>> Given that it will not reduce the number of #ifdefs, do you still
>> think that NX should be made unconditional?
>
> I think that not only NX should be made unconditional, I also think
> that the RO code should be unconditional.

So, the only conditional part would be the page-alignment of each of the
three parts of a module. Is that correct understanding?
