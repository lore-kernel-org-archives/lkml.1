Return-Path: <linux-kernel-owner+w=401wt.eu-S1759852AbZFJRmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852AbZFJRmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 13:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbZFJRmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 13:42:39 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:47008 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbZFJRmi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 13:42:38 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz1432R98dR1805Mzz1202hzzz32i17ch6bh6di43j)
X-WSS-ID: 0KL1AIL-01-Z80-01
Date: Wed, 10 Jun 2009 19:42:23 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: cpu/proc.c adding extended_cpuid_level for
	/proc/cpuinfo
Message-ID: <20090610174223.GA2697@aftab>
References: <1242112482.3283.1.camel@localhost.localdomain> <20090512232122.61f2d7c5.akpm@linux-foundation.org> <1244227115.2507.3.camel@ht.satnam> <4A29862D.6030601@zytor.com> <1244262225.2449.22.camel@ht.satnam> <1244652044.3295.10.camel@ht.satnam> <4A2FE9E1.3020705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A2FE9E1.3020705@zytor.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-OriginalArrivalTime: 10 Jun 2009 17:42:26.0835 (UTC) FILETIME=[D1D25630:01C9E9F2]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 10:14:09AM -0700, H. Peter Anvin wrote:
> >>>>
> >>> The more I'm thinking about this I think it was a mistake to put cpuid
> >>> level: there in the first place, too.  My opinion is increasingly to
> >>> leave this to x86info or other user-space tools.
> >>>
> >> cpuid level is as important as cpu family, model and stepping.
> >>
> >> For Intel, in some cases cpuid level is more important then cpu family,
> >> model and stepping. Like you cannot tell by looking at cpu family, model
> >> and stepping which model is new and which is old like 05_01 or 06_1A or
> >> 0F_03H ?
> >>
> >> But by looking at cpuid level and extended cpuid level you can tell
> >> which is new and which is old and which supports more features.
> >>
> >> So cpuid level and extended cpuid level is better scale than cpu family,
> >> model and stepping. So I think hiding this valuable information is a
> >> crime.
> > 
> > cpuid level and extended cpuid level tells the information about Intel
> > processor model.  Do you still think it is useless and should not be present
> > in /proc/cpuinfo .
> > 
> 
> I think it's pointless, because if you're doing this kind of stuff you
> might as well talk to CPUID directly.  We have a CPUID interface
> already.  The kernel isn't meant to replicate x86info or any of those
> tools -- it really can't, and at that point why stop at x86info... we
> could replicate arbitrary applications at that point.
> 
> As far as extended CPUID, why only the 0x0000 and 0x8000 ranges?
> Transmeta used 0x8086 and VIA uses 0xC000, but we don't even cache those
> internally, nevermind display them.
> 
> I'm not really all that doctrinal about this, but I'd like to get a
> decent answer to the question "where does it stop, *and why*".  It's a
> slippery slope, and without a target, it goes on forever.

I still fail to see a real use case which requires adding that info to
the kernel and querying CPUID directly is _absolutely_ not an option.
This is what the decisive argument should be and not some "but we have
already this and that in there." Otherwise its like painting a broken
car pink - it's still broken.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

