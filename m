Return-Path: <linux-kernel-owner+w=401wt.eu-S933181AbYEUKeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181AbYEUKeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 06:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757829AbYEUKdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 06:33:55 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:64209 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463AbYEUKdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 06:33:54 -0400
In-Reply-To: <1211364266.6463.76.camel@lappy.programming.kicks-ass.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Subject: Re: [PATCH] consolidate all within() implementations
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFC011E4F1.61EF5440-ONC1257450.0038CB52-C1257450.003A0375@de.ibm.com>
From: Peter 1 Oberparleiter <Peter.Oberparleiter@de.ibm.com>
Date: Wed, 21 May 2008 12:33:40 +0200
X-MIMETrack: Serialize by Router on D12ML066/12/M/IBM(Release 7.0.2FP2HF322 | September
 26, 2007) at 21/05/2008 12:33:51,
	Serialize complete at 21/05/2008 12:33:51
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> wrote on 21.05.2008 12:04:26:
> > +static inline int addr_within_len(const void *addr, const void 
*start,
> > +              size_t len)
> > +{
> > +   return ((unsigned long) addr >= (unsigned long) start) &&
> > +          ((unsigned long) addr < ((unsigned long) start + len));
> > +}
> 
> might be my braindamage, but I'd have written it like:
> 
> static inline int 
> addr_within_len(const void *addr, const void *start, size_t len)
> {
>    return (unsigned long)addr - (unsigned long)start < len;
> }

Definitely another way to put it. In my opinion the intention of the
implementation is more easily understood though when spelling it out
as (a>=b) && (a<c).

> static inline int
> addr_within(const void *add, const void *start, const void *end)
> {
>    return addr_within_len(addr, start, 
>          (unsigned long)end - (unsigned long)start);
> }

For empty ranges (start > end), this produces different (less expected)
results than the previous version.


Regards,
  Peter
