Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbZFXWVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbZFXWVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 18:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbZFXWVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 18:21:24 -0400
Received: from mail-yx0-f173.google.com ([209.85.210.173]:38318 "EHLO
	mail-yx0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbZFXWVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 18:21:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=VSBkdxa72hnx/n4oTpB07+dUEyGZuAlKpEexcssw4XpB91Zc8XatCcjEuU7wQQrhFS
         14PbOnfSfRiL7QwHrgPFm7I1+n75kLGDQ0XJqizdDqvLdxSO3Uike1s3dqls5ox/ijSm
         ldEGq0uVgMZBLkrk1rJqfC0hlVY/1wjdNIacA=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a0906240802ieec96fav2864fa199d3f1b90@mail.gmail.com>
References: <8bd0f97a0906231508s4c115d3dr2848626bc5a28c5e@mail.gmail.com> 
	<20090624131357.GA6224@elte.hu> <200906241602.38422.arnd@arndb.de> 
	<8bd0f97a0906240802ieec96fav2864fa199d3f1b90@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 24 Jun 2009 18:21:06 -0400
Message-ID: <8bd0f97a0906241521s23c0d3bes56398a3333d4ee57@mail.gmail.com>
Subject: Re: PREEMPT_ACTIVE too low error with all asm-generic headers for 
	some arches
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 11:02, Mike Frysinger wrote:
> On Wed, Jun 24, 2009 at 10:02, Arnd Bergmann wrote:
>> --- a/include/linux/hardirq.h
>> +++ b/include/linux/hardirq.h
>> @@ -62,6 +62,12 @@
>>  #define HARDIRQ_OFFSET (1UL << HARDIRQ_SHIFT)
>>  #define NMI_OFFSET     (1UL << NMI_SHIFT)
>>
>> +#ifndef PREEMPT_ACTIVE
>> +#define PREEMPT_ACTIVE_BITS    1
>> +#define PREEMPT_ACTIVE_SHIFT   (NMI_SHIFT + NMI_BITS)
>> +#define PREEMPT_ACTIVE (__IRQ_MASK(PREEMPT_ACTIVE_BITS) << PREEMPT_SHIFT)
>
> i think you meant "<< PREEMPT_ACTIVE_SHIFT" there.  once i make that
> change, it builds fine.

and like Ingo, with that fix, add my Acked-by

thanks !
-mike
