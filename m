Return-Path: <linux-kernel-owner+w=401wt.eu-S965887AbXCFOlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965887AbXCFOlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 09:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965889AbXCFOlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 09:41:13 -0500
Received: from www.osadl.org ([213.239.205.134]:36075 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965887AbXCFOlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 09:41:10 -0500
Subject: Re: 2.6.21-rc2-mm2
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Con Kolivas <kernel@kolivas.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>
In-Reply-To: <200703070024.51273.kernel@kolivas.org>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org>
	 <200703062258.19940.kernel@kolivas.org>
	 <1173185537.24738.323.camel@localhost.localdomain>
	 <200703070024.51273.kernel@kolivas.org>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 15:47:13 +0100
Message-Id: <1173192434.24738.333.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 00:24 +1100, Con Kolivas wrote:
> >         printk(KERN_INFO "Time: %s clocksource has been installed.\n",
> >                clock->name);
> > }
> >
> > So clock seems to be NULL, but was accessed before
> > clocksource_calculate_interval() as well.
> 
> It seems to be specifically tripping at c->mult after reading c->shift if I'm 
> reading it correctly.
> 
> Note again, this is qemu, not real hardware and it will likely be giving very 
> unrealistic values for timer calibrations.

I know, but this does not really explain why the 

	tmp += c->mult/2;

results in a NULL pointer access after 

	tmp <<= c->shift;

Does disassembling the code in question give some info ? You might also
try to look with GDB at it.

	tglx


