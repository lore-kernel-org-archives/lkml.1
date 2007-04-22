Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbXDVBrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbXDVBrA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 21:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbXDVBrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 21:47:00 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:8170 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbXDVBq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 21:46:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hqPExQHq56MMUQ6jRykdVbVppH2DPffuoPtt/3AI01pWYZFpNpwnLoaIHVbyZ6KYF5QspHAtjxtvhfpfi1pTIxBBdrHmGULzm+K4QPmwnGM3tGJE8hHAbYd4RlPj+rtbq1A5gIMn8jtEZdzmbMObrAjKX+eIzxiUxYd+jeGXo0U=
Message-ID: <a36005b50704211846g4ed1256fpad6a3a5670318314@mail.gmail.com>
Date: Sat, 21 Apr 2007 18:46:58 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Cc: "Kyle Moffett" <mrmacman_g4@mac.com>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Willy Tarreau" <w@1wt.eu>, "Ingo Molnar" <mingo@elte.hu>,
       "Con Kolivas" <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>, "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Thomas Gleixner" <tglx@linutronix.de>, caglar@pardus.org.tr,
       "Gene Heskett" <gene.heskett@gmail.com>
In-Reply-To: <alpine.LFD.0.98.0704211634130.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu>
	 <20070421154614.GA26169@elte.hu> <20070421161818.GC7840@1wt.eu>
	 <alpine.LFD.0.98.0704210931370.9964@woody.linux-foundation.org>
	 <20070421164241.GF2986@holomorphy.com>
	 <E1192E83-5E64-4782-8F92-DDCA09CA2F55@mac.com>
	 <a36005b50704211249pb771b79k227914515b5f9906@mail.gmail.com>
	 <alpine.LFD.0.98.0704211634130.9964@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/21/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> And how the hell do you imagine you'd even *know* what thread holds the
> futex?

We know this in most cases.  This is information recorded, for
instance, in the mutex data structure.  You might have missed my "the
interface must be extended" part.  This means the PID of the owning
thread will have to be passed done.  For PI mutexes this is not
necessary since the kernel already has access to the information.


> The whole point of the "f" part of the mutex is that it's fast, and we
> never see the non-contended case in the kernel.

See above.  Believe me, I know how futexes work.  But I also know what
additional information we collect.  For mutexes and in part for
rwlocks we know which thread owns the sync object.  In that case we
can easily provide the kernel with the information.
