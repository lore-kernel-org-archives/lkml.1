Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbXEITKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbXEITKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 15:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755072AbXEITKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 15:10:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:17873 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351AbXEITKJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 15:10:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,510,1170662400"; 
   d="scan'208";a="85397611"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH -mm] timer: parenthesis fix in tbase_get_deferrable() etc.
Date: Wed, 9 May 2007 12:10:06 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F55DFC44@scsmsx415.amr.corp.intel.com>
In-Reply-To: <a781481a0705091129t6a348fb7ya2a225123fca3f6@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -mm] timer: parenthesis fix in tbase_get_deferrable() etc.
thread-index: AceSaAJtlx8rYO3zS2WVNcPhsAcSxQABVWZg
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
CC: "Jarek Poplawski" <jarkao2@o2.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "Oleg Nesterov" <oleg@tv-sign.ru>
X-OriginalArrivalTime: 09 May 2007 19:10:06.0784 (UTC) FILETIME=[A7CF9C00:01C7926D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Satyam Sharma [mailto:satyam.sharma@gmail.com] 
>Sent: Wednesday, May 09, 2007 11:30 AM
>To: Pallipadi, Venkatesh
>Cc: Jarek Poplawski; Andrew Morton; 
>linux-kernel@vger.kernel.org; Oleg Nesterov
>Subject: Re: [PATCH -mm] timer: parenthesis fix in 
>tbase_get_deferrable() etc.
>
>On 5/9/07, Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:
>>
>> >-----Original Message-----
>> >From: Jarek Poplawski [mailto:jarkao2@o2.pl]
>> >Sent: Tuesday, May 08, 2007 10:32 PM
>> >To: Andrew Morton
>> >Cc: Pallipadi, Venkatesh; linux-kernel@vger.kernel.org; 
>Oleg Nesterov
>> >Subject: Re: [PATCH -mm] timer: parenthesis fix in
>> >tbase_get_deferrable() etc.
>> >
>> >On Tue, May 08, 2007 at 04:33:58PM -0700, Andrew Morton wrote:
>> >> On Tue, 8 May 2007 12:33:48 +0200
>> >> Jarek Poplawski <jarkao2@o2.pl> wrote:
>> >>
>> >> >
>> >> > Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
>> >> >
>> >> > ---
>> >> >
>> >> > diff -Nurp 2.6.21-mm1-/kernel/timer.c 2.6.21-mm1/kernel/timer.c
>> >> > --- 2.6.21-mm1-/kernel/timer.c     2007-05-08
>> >11:54:48.000000000 +0200
>> >> > +++ 2.6.21-mm1/kernel/timer.c      2007-05-08
>> >12:05:11.000000000 +0200
>> >> > @@ -92,24 +92,24 @@ static DEFINE_PER_CPU(tvec_base_t *, tve
>> >> >  /* Functions below help us manage 'deferrable' flag */
>> >> >  static inline unsigned int 
>tbase_get_deferrable(tvec_base_t *base)
>> >> >  {
>> >> > -  return ((unsigned int)(unsigned long)base &
>> >TBASE_DEFERRABLE_FLAG);
>> >> > +  return (unsigned int)((unsigned long)base &
>> >TBASE_DEFERRABLE_FLAG);
>> >> >  }
>> >...
>> >> The change makes sense, but does it actually "fix" anything?
>> >>
>> >
>> >Yes - this first place fixes logical error, so it's a sin
>> >- even if not punishable in practice. (It's also unnecessary
>> >test for long to int conversion.)
>> >
>>
>> I am sorry, I don't understand. What is the logical error in 
>the first
>> one?
>>
>> Actually, your change makes it different from what was originally
>> indended.
>> Original intention was to type convert base to a 32 bit value and
>> bitwise& with FLAG.
>
>But that is not what the original code is doing. If you wanted to
>typecast "base" to "a 32 bit value" then you should've used u32
>instead.
>
>Anyway, if you originally intended to actually typecast "base" to
>unsigned int, then you could do that directly without typecasting it
>first to unsigned long (unnecessarily) and then to unsigned int. Of
>course, if your system implements a pointer as something bigger than
>unsigned int (which is what you eventually convert "base" to), then
>you're screwed anyway and the intermediate typecast to unsigned long
>doesn't buy you anything at all.

On a 64 bit system, converting pointer to int causes unnecessary
compiler
warning, and intermediate long conversion was to avoid that. I will have
to rephrase my comment to remove 32 bit value and use int, as that is
what
the function returns.

Thanks,
Venki
