Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbZEUQ1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbZEUQ1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbZEUQ1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:27:36 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:34150
	"EHLO WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754483AbZEUQ1g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:27:36 -0400
X-BigFish: VPS-23(zz1432R98dR168aJ1805Mzz1202hzzz32i6bh6di43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KK05PL-01-4ZF-01
Date: Thu, 21 May 2009 18:26:38 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu, norsk5@yahoo.com,
       tglx@linutronix.de, mchehab@redhat.com, aris@redhat.com, edt@aei.ca,
       linux-kernel@vger.kernel.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 01/22] x86: add methods for writing of an MSR on several
	CPUs
Message-ID: <20090521162638.GA10824@aftab>
References: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com> <1242390153-24493-2-git-send-email-borislav.petkov@amd.com> <20090519172449.GB18874@aftab> <4A1392A9.9010609@zytor.com> <20090520144905.GA27991@aftab> <4A147891.5000906@zytor.com> <20090521140800.GA3462@aftab> <4A156361.2040507@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A156361.2040507@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 21 May 2009 16:26:40.0319 (UTC) FILETIME=[EBA00CF0:01C9DA30]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 07:21:21AM -0700, H. Peter Anvin wrote:
> Borislav Petkov wrote:
> >>>
> >> smp_call_function_many() does allow concurrent execution.
> > 
> > Well, IMHO, not an absolutely concurrent execution since you can't
> > control at what moment in time the IPIs will be executed on each core,
> > IOW, the respective call function IPIs will generally not coincide on
> > each core at a given moment in time. This is especially true if you're
> > sending IPIs to cores across nodes.
> > 
> > And there's hypothetically a small window where you might get an
> > inconsistent MSR content across cores. It's a whole another question
> > whether this is going to be relevant.
> > 
> 
> It *allows* concurrent execution.  It doesn't *guarantee* concurrent
> execution.

Exactly what I'm trying to say.

> > So, the actual question is do we need that done in msr.c? If there are
> > no potential users, I could easily do the whole thing in the driver and
> > do not touch x86 code.
> 
> Only if we care about the additional performance of having it be
> nonserializing.

Well, let's do the nonserializing thing and have it done right from the
beginning. We might not care now but who knows..?

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

