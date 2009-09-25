Return-Path: <linux-kernel-owner+w=401wt.eu-S1752887AbZIYOkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbZIYOkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 10:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZIYOkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 10:40:39 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:34340
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752421AbZIYOki convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 10:40:38 -0400
X-SpamScore: -18
X-BigFish: VPS-18(z34a4jz1432R98dN179dN873fizz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KQJ7FF-02-ENS-02
X-M-MSG: 
Date: Fri, 25 Sep 2009 16:40:38 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Arjan van de Ven <arjan@infradead.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
       bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 17/63] edac_mce: Add an interface driver to report mce
 errors via edac
Message-ID: <20090925144037.GA16340@aftab>
References: <20090924192727.212ce46f@pedra.chehab.org>
 <20090925094855.GA29551@aftab>
 <20090925091130.14135879@pedra.chehab.org>
 <20090925135626.GA8145@aftab>
 <20090925160501.03a0f37d@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090925160501.03a0f37d@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 25 Sep 2009 14:40:21.0865 (UTC) FILETIME=[1C3B7590:01CA3DEE]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 04:05:01PM +0200, Arjan van de Ven wrote:
> On Fri, 25 Sep 2009 15:56:26 +0200
> > > 1) edac_mce is not a module (see patch 18). So, just calling a
> > > routine on edac_mce should be safe, even at NMI;
> > 
> > no, I mean the ->check_error member - it could call into a module if
> > i7core_edac is compiled as such.
> 
> calling modular code from NMI is not a fatal event though.

No, not really. However, I remember Andi raising a stability concern one
time whether it'd be such a good idea to allow modules to hook into MCE
critical path when the system is already unstable and about to panic.

Therefore, we might want to decode critical MCEs in core kernel code and
non-critical later, at a more appropriate time (aka in modules).

Hmm?

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

