Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbZBZWHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbZBZWHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZBZWG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:06:59 -0500
Received: from www.tglx.de ([62.245.132.106]:40128 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbZBZWG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:06:59 -0500
Date: Thu, 26 Feb 2009 23:06:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
In-Reply-To: <1235685269.6811.11.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>  <49A6F39F.9040801@krogh.cc>  <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>  <49A6FEE2.90700@krogh.cc>  <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com> 
 <49A70B24.6090706@krogh.cc> <1235685269.6811.11.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009, john stultz wrote:
> On Thu, 2009-02-26 at 22:35 +0100, Jesper Krogh wrote:
> > > Also mind sending the full dmesg for both kernels?
> > 
> > http://krogh.cc/~jesper/dmesg-2.6.29-rc6.txt
> > http://krogh.cc/~jesper/dmesg-2.6.26.8.txt
> 
> So one interesting difference:
> 2.6.26.8:	TSC calibrated against PM_TIMER
> 2.6.29-rc6:	Fast TSC calibration using PIT
> 
> Thomas, any thoughts as to why we might be calibrating off the PIT
> instead of the PM_TIMER w/ 2.6.29?

Yup, because we introduced the Fast PIT calibration in 2.6.28.

Is the delta anything NTP might get upset about:

2.6.26: time.c: Detected 2311.847 MHz processor.
2.6.29: Detected 2310.029 MHz processor.

If yes, then we need to fix NTP not the calibration code :)
 
> Maybe does this line provide a hint?
> FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)

Red herring.
 
Thanks,

	tglx
