Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbZGUKtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbZGUKtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbZGUKtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:49:39 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:56889
	"EHLO WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754308AbZGUKti convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:49:38 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zz1432R98dN1b0bMzz1202hzzz32i6bh6di43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KN4OQE-01-OY3-01
Date: Tue, 21 Jul 2009 12:49:24 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Doug Thompson <norsk5@yahoo.com>,
       mingo@elte.hu, tglx@linutronix.de, aris@redhat.com,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 07/14] mce3: pass mce info to EDAC for decoding
Message-ID: <20090721104924.GD32338@aftab>
References: <20090720180446.GB16072@basil.fritz.box>
 <935428.51568.qm@web50110.mail.re2.yahoo.com>
 <20090720192229.GC16072@basil.fritz.box>
 <4A64D0F2.7050009@zytor.com>
 <4A6538EE.6000903@jp.fujitsu.com>
 <20090721065128.GA29028@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090721065128.GA29028@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Jul 2009 10:49:24.0202 (UTC) FILETIME=[E92864A0:01CA09F0]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 08:51:28AM +0200, Andi Kleen wrote:
> On Tue, Jul 21, 2009 at 12:41:34PM +0900, Hidetoshi Seto wrote:
> > H. Peter Anvin wrote:
> > >  If you want modules to change the behavior, you're talking about a
> > > *dynamic* change -- the call will point to different things at different
> > > points in time -- so you need another mechanism, i.e. function pointers.
> > 
> > Just FYI, machine check handler on ia64 has such function pointer.
> > 
> > [arch/ia64/kernel/mca.c]
> >     826 /* Function pointer for extra MCA recovery */
> >     827 int (*ia64_mca_ucmc_extension)
> >     828         (void*,struct ia64_sal_os_state*)
> >     829         = NULL;
> 
> A notifier would be a much more flexible solution. Function pointers
> don't really work well with multiple users, which might well happen
> here.
> 
> However on the other hand I have some doubts it's really a good 
> idea to expose fatal MCEs to modules. MCE is a rather critical
> code path (a bit similar to an oops), with the machine
> already somewhat instable in many cases and if you allow
> arbitary modules to hook into that you risk long term
> instability.
> 
> So if a notifier is done I would recommend to only limit
> it to corrected MCEs (machine_check_poll), not fatal ones.

However, the idea is to decode _all_ MCEs so we could look into moving
the decoding bits into the EDAC core or some other more appropriate
place. Ingo?

We could then reroute the non fatals to EDAC for further decoding.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

