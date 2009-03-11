Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbZCKMBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbZCKMBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 08:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbZCKMBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 08:01:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:47841 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbZCKMBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 08:01:34 -0400
Subject: Re: [PATCH] x86: suggest running a 64bit kernel on LM capable
 machines with plenty memory.
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Ozan =?UTF-8?Q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090310062134.704d2c7e@infradead.org>
References: <49B254C6.8010507@pardus.org.tr>
	 <20090307193026.GA2165@x200.localdomain> <49B2CE44.4060305@pardus.org.tr>
	 <87r617ojfi.fsf@firstfloor.org> <1236606168.8389.512.camel@laptop>
	 <20090309191504.GB11935@one.firstfloor.org>
	 <1236677828.25234.9.camel@laptop>  <20090310062134.704d2c7e@infradead.org>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 13:01:25 +0100
Message-Id: <1236772885.8192.241.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 06:21 -0700, Arjan van de Ven wrote:
> On Tue, 10 Mar 2009 10:37:08 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> > diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> > index 34ef5c7..e759107 100644
> > --- a/arch/x86/mm/init_32.c
> > +++ b/arch/x86/mm/init_32.c
> > @@ -713,13 +713,19 @@ void __init lowmem_pfn_init(void)
> >  	"only %luMB highmem pages available, ignoring highmem size
> > of %luMB!\n" 
> >  #define MSG_HIGHMEM_TRIMMED \
> > -	"Warning: only 4GB will be used. Use a HIGHMEM64G enabled
> > kernel!\n"
> > +	"Warning: only 4GB will be used. Use a %s kernel!\n"
> > +
> > +#define MSG_LM_TRIMMED \
> > +	"Warning: instead of using a 32bit %s kernel, Use a 64bit
> > kernel!\n" +
> 
> I would like to avoid the prefix "Warning:" for something like this ;-)
> 
> lets keep that prefix for Real Warnings(tm) instead please.

It is a Real warning, its issued when memory gets trimmed because you
run a wrong kernel. The only change is suggesting to run a 64bit kernel
when possible instead of a HIGHMEM/PAE kernel.

Esp on x86_64 machines with >=4G of memory its insane to run i386-PAE.

