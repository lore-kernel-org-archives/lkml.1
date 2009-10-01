Return-Path: <linux-kernel-owner+w=401wt.eu-S932729AbZJAOqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729AbZJAOqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932714AbZJAOqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:46:36 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:25549 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613AbZJAOqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:46:34 -0400
X-SpamScore: -18
X-BigFish: VPS-18(z39eeh518kz1432R98dN179dN1442Jzz1202hzzz32i6bh43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KQUBOZ-04-6ES-02
X-M-MSG: 
Date: Thu, 1 Oct 2009 16:46:37 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <petkovbb@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: mce: Please revert
 22223c9b417be5fd0ab2cf9ad17eb7bd1e19f7b9
Message-ID: <20091001144637.GB11410@aftab>
References: <20090930140904.GA6150@one.firstfloor.org>
 <20090930194049.GA17712@liondog.tnic>
 <20090930204643.GA24862@elte.hu>
 <20090930214859.GA28638@elte.hu>
 <20090930223956.GE17712@liondog.tnic>
 <20090930230947.GA9346@elte.hu>
 <20091001141432.GA11410@aftab>
 <alpine.LFD.2.01.0910010731130.6996@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910010731130.6996@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 01 Oct 2009 14:46:10.0795 (UTC) FILETIME=[EAB073B0:01CA42A5]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 07:34:11AM -0700, Linus Torvalds wrote:
> > Ok, here it is, tested on two Fam10 machines here with injecting MCEs.
> > The decoding code is now built-in by default (early_initcall requires
> > !MODULE).
> 
> I don't think it has to require !MODULE. We could do what we do for the 
> other initcalls, ie if MODULE we turn it into just a regular initcall. If 
> that allows something like the EDAC MCE to be built as a module, and 
> people want to, then just go ahead and add the one-liner to <linux/init.h>
>
> Of course, if it _requires_ being loaded early for some other reason, then

the only reason I can think of is if you want to be able to decode MCEs
happening as early as possible before the modules have been init-ted.

Question really is, what is more important to us? But we definitely
can do the module stuff too and get rid of ~5K core kernel fat by
relocating the whole functionality completely into the module. Hmm...

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

