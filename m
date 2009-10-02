Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbZJBS0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbZJBS0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 14:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbZJBS0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 14:26:53 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:35840 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943AbZJBS0w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 14:26:52 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz98dNzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KQWGKF-04-H3Y-02
X-M-MSG: 
Date: Fri, 2 Oct 2009 20:26:59 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] EDAC: carve out AMD MCE decoding logic
Message-ID: <20091002182659.GA16436@aftab>
References: <20090930230947.GA9346@elte.hu>
 <20091001141432.GA11410@aftab>
 <alpine.LFD.2.01.0910010731130.6996@localhost.localdomain>
 <20091001144637.GB11410@aftab>
 <20091001150046.GA21476@elte.hu>
 <20091001152140.GC11410@aftab>
 <20091001153250.GA25885@elte.hu>
 <20091002132101.GA28682@aftab>
 <20091002133148.GD28682@aftab>
 <20091002133954.GA29390@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20091002133954.GA29390@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 02 Oct 2009 18:26:30.0565 (UTC) FILETIME=[DCB30550:01CA438D]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 03:39:54PM +0200, Ingo Molnar wrote:
> I suspect this is fine currently because no two EDAC modules should be 
> active at the same time. A followup cleanup patch would be nice 
> nevertheless that uses a notifier chain here with proper 
> register/unregister locking.

Please do elaborate for I can't seem to follow.

AFAICT, we are going to have max one MCE decoder at any one time so no
need to notify it.

The x86_mce_decode_callback assignment probably needs locking just to be
on the safe side. We can do a

mce_set_decode_callback(void (*f)(struct mce*m))

helper which falls back to default_decode_mce() whenever its being
passed a NULL for *f using proper locking...

I'm pretty sure I'm missing something though...

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

