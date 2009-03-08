Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbZCHRXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbZCHRXa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 13:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbZCHRXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 13:23:21 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45659 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753011AbZCHRXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 13:23:21 -0400
Subject: Re: [PATCH 01/13] [VOYAGER] x86: add {safe,hard}_smp_processor_id
	to smp_ops
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <49B3FD1F.9010000@goop.org>
References: <1236530906-7175-1-git-send-email-James.Bottomley@HansenPartnership.com>
	 <1236530906-7175-2-git-send-email-James.Bottomley@HansenPartnership.com>
	 <49B3FD1F.9010000@goop.org>
Content-Type: text/plain
Date: Sun, 08 Mar 2009 12:23:16 -0500
Message-Id: <1236532996.4861.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-08 at 10:15 -0700, Jeremy Fitzhardinge wrote:
> James Bottomley wrote:
> > Not having apics, Voyager can't use the default apic implementation of
> > these, it has to read from a special port in the VIC to get the
> > processor ID, so abstract these functions in smp_ops to allow voyager
> > to live simultaneously with the apic code.
> >   
> 
> These aren't performance-sensitive at all, are they?  smp_ops is not 
> subject to patching/inlining optimisations happen to more hotpath pvops.

No more than the function pointer indirection of smp_call_function().
Fortunately, the hard version is called in very few places, so the
overhead is minimal.

> Is safe_smp_processor_id needed at all?  It's only got two callers, and 
> x86-64 just implements it as smp_processor_id().

I can't see a reason, no.  If you look at voyager it uses the same
function for both, but x86 seems to have extra gunk in the safe path, so
I didn't feel entitled to remove it.

James


