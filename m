Return-Path: <linux-kernel-owner+w=401wt.eu-S1762480AbYENNOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762480AbYENNOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 09:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbYENNOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 09:14:03 -0400
Received: from www.tglx.de ([62.245.132.106]:54099 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574AbYENNOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 09:14:01 -0400
Date: Wed, 14 May 2008 15:07:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alok Kataria <akataria@vmware.com>
cc: johnstul@us.ibm.com, mingo@redhat.com, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, Dan Hecht <dhecht@vmware.com>,
       Tim Mann <mann@vmware.com>, Zachary Amsden <zach@vmware.com>
Subject: Re: Possible error in tsc frequency calibration
In-Reply-To: <1210719921.11510.157.camel@promb-2n-dhcp368.eng.vmware.com>
Message-ID: <alpine.LFD.1.10.0805141506010.3174@apollo.tec.linutronix.de>
References: <1210719921.11510.157.camel@promb-2n-dhcp368.eng.vmware.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008, Alok Kataria wrote:
> I was looking at the tsc calibration code (tsc_calibrate) in the recent
> kernels (2.6.26-rc1). With the newer code of calibrating against the
> pm_timer and with the added checks for SMI's the tsc_calibration code
> looks pretty robust, at least for x86_64 systems.
> 
> However, from the code, (tsc_calibrate) SMI_THRESHOLD is 50000, so in
> the worst case, values returned by tsc_read_refs, i.e. tsc1 & tsc2,
> could be off by 50000 ticks. On a 2Ghz processor this would mean an
> error of 25us. The tsc frequency is calibrated over a period of 50ms;
> hence the worst case error can be around 500ppm. 
> 
> In addition to that, the pmtimer hardware itself has some drift,
> typically in the range of 20 to 100ppm.  If this drift happens to be in
> the same direction as the error in measuring the tsc against the
> pmtimer, we could have a total error of more than 500ppm in the tsc
> frequency calibration code.  The maximum drift that NTP is willing to
> correct is 500ppm.  So we can have cases when we may end up
> mis-calibrating tsc frequency beyond the NTP threshold.
> 
> One thing that we can do to reduce this possible error is to
> double the calibration period from the current 50msec to 100msec.
> This halves the maximum error to 250ppm. 

Will have a look at the threshold when working on #2
 
> Comments?
> 
> Now looking at the 32bit code, the frequency calibration code looks
> really broken in the sense that we are not checking for SMI's at all.  
> The maximum error that can go undetected on these systems is very high.
> The best way to solve this would be to unify the calibration code for 32
> bit and 64bit. Is anybody already working on this?

#2 Yup, I'm merging tsc-32/64 and keep the 64 bit calibration for both.

Thanks,
	tglx
