Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbZJAPV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbZJAPV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 11:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbZJAPV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 11:21:28 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:54963
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751271AbZJAPV2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 11:21:28 -0400
X-SpamScore: -18
X-BigFish: VPS-18(z39eeh518kz1432R98dN179dN1442Jzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KQUDBE-04-7WJ-02
X-M-MSG: 
Date: Thu, 1 Oct 2009 17:21:40 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: mce: Please revert
 22223c9b417be5fd0ab2cf9ad17eb7bd1e19f7b9
Message-ID: <20091001152140.GC11410@aftab>
References: <20090930140904.GA6150@one.firstfloor.org>
 <20090930194049.GA17712@liondog.tnic>
 <20090930204643.GA24862@elte.hu>
 <20090930214859.GA28638@elte.hu>
 <20090930223956.GE17712@liondog.tnic>
 <20090930230947.GA9346@elte.hu>
 <20091001141432.GA11410@aftab>
 <alpine.LFD.2.01.0910010731130.6996@localhost.localdomain>
 <20091001144637.GB11410@aftab>
 <20091001150046.GA21476@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20091001150046.GA21476@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 01 Oct 2009 15:21:13.0445 (UTC) FILETIME=[CFF76150:01CA42AA]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 05:00:46PM +0200, Ingo Molnar wrote:
> > > Of course, if it _requires_ being loaded early for some other reason, then
> > 
> > the only reason I can think of is if you want to be able to decode 
> > MCEs happening as early as possible before the modules have been 
> > init-ted.
> > 
> > Question really is, what is more important to us? But we definitely 
> > can do the module stuff too and get rid of ~5K core kernel fat by 
> > relocating the whole functionality completely into the module. Hmm...
> 
> I'd focus on the built-in-side initially, which is the most 
> practical/debuggable/serviceable solution. It's of course not a problem 
> (at all) if it is _also_ module loadable but that's not the primary 
> goal.

How about a CONFIG_EDAC_DECODE_MCE which depends on CONFIG_CPU_SUP_AMD and
defaults to yes with a config text saying something in the likes of

"... Select Y here if you want to decode MCEs happening early before the
modules framework has been initialized...."

?

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

