Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbZEVOkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbZEVOkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 10:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756116AbZEVOkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 10:40:22 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:59528 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915AbZEVOkR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 10:40:17 -0400
X-BigFish: VPS-6(zz1432R98dR1805Mzz1202hzz3198u327alz32i6bh6di61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KK1VEQ-01-OOB-01
Date: Fri, 22 May 2009 16:39:18 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu, norsk5@yahoo.com,
       tglx@linutronix.de, mchehab@redhat.com, aris@redhat.com, edt@aei.ca,
       linux-kernel@vger.kernel.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 01/22] x86: add methods for writing of an MSR on
	several CPUs
Message-ID: <20090522143918.GA22850@aftab>
References: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com> <1242390153-24493-2-git-send-email-borislav.petkov@amd.com> <20090519172449.GB18874@aftab> <4A1392A9.9010609@zytor.com> <20090520144905.GA27991@aftab> <4A147891.5000906@zytor.com> <20090521140800.GA3462@aftab> <4A156361.2040507@zytor.com> <20090521162638.GA10824@aftab> <4A159179.6070607@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A159179.6070607@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 22 May 2009 14:39:20.0440 (UTC) FILETIME=[17923F80:01C9DAEB]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 10:38:01AM -0700, H. Peter Anvin wrote:
> Borislav Petkov wrote:
> > 
> > Well, let's do the nonserializing thing and have it done right from the
> > beginning. We might not care now but who knows..?
> > 
> 
> If nothing else it might matter for boot time.  Serializing *anything*
> across a large number of CPUs can be very expensive.

well, upon a closer look, smp_call_function_many() skips over the CPU
it is executing on and there's currently work in that area to extend
that API: http://marc.info/?l=linux-kernel&m=123979231511594&w=2.

However, according to Linus' comments, it looks like this would need a
bit of work so I guess we should wait with the concurrency stuff a bit,
no?

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

