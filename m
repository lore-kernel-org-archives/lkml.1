Return-Path: <linux-kernel-owner+w=401wt.eu-S1758406AbXEIP7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406AbXEIP7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 11:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbXEIP7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 11:59:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:19384 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755105AbXEIP7Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 11:59:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,510,1170662400"; 
   d="scan'208";a="243831212"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH -mm] timer: parenthesis fix in tbase_get_deferrable() etc.
Date: Wed, 9 May 2007 08:59:27 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F55DF9FD@scsmsx415.amr.corp.intel.com>
In-Reply-To: <20070509053144.GA995@ff.dom.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -mm] timer: parenthesis fix in tbase_get_deferrable() etc.
thread-index: AceR+nJI6GkcIdzyRl+4v2vLIMzJhQAV1K+g
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Jarek Poplawski" <jarkao2@o2.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, "Oleg Nesterov" <oleg@tv-sign.ru>
X-OriginalArrivalTime: 09 May 2007 15:59:22.0711 (UTC) FILETIME=[029CA670:01C79253]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>-----Original Message-----
>From: Jarek Poplawski [mailto:jarkao2@o2.pl] 
>Sent: Tuesday, May 08, 2007 10:32 PM
>To: Andrew Morton
>Cc: Pallipadi, Venkatesh; linux-kernel@vger.kernel.org; Oleg Nesterov
>Subject: Re: [PATCH -mm] timer: parenthesis fix in 
>tbase_get_deferrable() etc.
>
>On Tue, May 08, 2007 at 04:33:58PM -0700, Andrew Morton wrote:
>> On Tue, 8 May 2007 12:33:48 +0200
>> Jarek Poplawski <jarkao2@o2.pl> wrote:
>> 
>> > 
>> > Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
>> > 
>> > ---
>> > 
>> > diff -Nurp 2.6.21-mm1-/kernel/timer.c 2.6.21-mm1/kernel/timer.c
>> > --- 2.6.21-mm1-/kernel/timer.c	2007-05-08 
>11:54:48.000000000 +0200
>> > +++ 2.6.21-mm1/kernel/timer.c	2007-05-08 
>12:05:11.000000000 +0200
>> > @@ -92,24 +92,24 @@ static DEFINE_PER_CPU(tvec_base_t *, tve
>> >  /* Functions below help us manage 'deferrable' flag */
>> >  static inline unsigned int tbase_get_deferrable(tvec_base_t *base)
>> >  {
>> > -	return ((unsigned int)(unsigned long)base & 
>TBASE_DEFERRABLE_FLAG);
>> > +	return (unsigned int)((unsigned long)base & 
>TBASE_DEFERRABLE_FLAG);
>> >  }
>...
>> The change makes sense, but does it actually "fix" anything?
>> 
>
>Yes - this first place fixes logical error, so it's a sin
>- even if not punishable in practice. (It's also unnecessary
>test for long to int conversion.)
>

I am sorry, I don't understand. What is the logical error in the first
one?

Actually, your change makes it different from what was originally
indended.
Original intention was to type convert base to a 32 bit value and
bitwise& with FLAG. Even though compiler may optimize both the above to
same code, I don't see what is the error.

Thanks,
Venki 
