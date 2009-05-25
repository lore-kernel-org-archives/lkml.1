Return-Path: <linux-kernel-owner+w=401wt.eu-S1751747AbZEYLCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbZEYLCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 07:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbZEYLCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 07:02:00 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:3393 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751059AbZEYLB7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 07:01:59 -0400
X-BigFish: VPS-6(zz1432R98dR1805Mzz1202hzz3198u327alz32i6bh6di61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KK75AW-02-0QT-01
Date: Mon, 25 May 2009 13:01:47 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu, norsk5@yahoo.com,
       tglx@linutronix.de, mchehab@redhat.com, aris@redhat.com, edt@aei.ca,
       linux-kernel@vger.kernel.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 01/22] x86: add methods for writing of an MSR on several
	CPUs
Message-ID: <20090525110147.GB8956@aftab>
References: <20090519172449.GB18874@aftab> <4A1392A9.9010609@zytor.com> <20090520144905.GA27991@aftab> <4A147891.5000906@zytor.com> <20090521140800.GA3462@aftab> <4A156361.2040507@zytor.com> <20090521162638.GA10824@aftab> <4A159179.6070607@zytor.com> <20090522143918.GA22850@aftab> <4A16D735.8090104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A16D735.8090104@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 25 May 2009 11:01:46.0423 (UTC) FILETIME=[32029470:01C9DD28]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 09:47:49AM -0700, H. Peter Anvin wrote:
> Borislav Petkov wrote:
> >>>
> >> If nothing else it might matter for boot time.  Serializing *anything*
> >> across a large number of CPUs can be very expensive.
> > 
> > well, upon a closer look, smp_call_function_many() skips over the CPU
> > it is executing on and there's currently work in that area to extend
> > that API: http://marc.info/?l=linux-kernel&m=123979231511594&w=2.
> > 
> > However, according to Linus' comments, it looks like this would need a
> > bit of work so I guess we should wait with the concurrency stuff a bit,
> > no?
> > 
> 
> Well, we can introduce the API now if that's where we intend it to go.

Ok, here it is (patches as a reply to that mail). I've added a temporary
workaround for smp_call_function_many() not running on the CPU we're on.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

