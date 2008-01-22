Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbYAVRFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbYAVRFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 12:05:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbYAVREz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 12:04:55 -0500
Received: from waste.org ([66.93.16.53]:49020 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbYAVREz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 12:04:55 -0500
Subject: Re: Rescheduling interrupts
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?UTF-8?Q?S=2E=C3=87a=C4=9Flar?= Onur <caglar@pardus.org.tr>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <20080122160557.GA31831@elte.hu>
References: <200801220119.42312.caglar@pardus.org.tr>
	 <200801221455.16814.caglar@pardus.org.tr> <20080122152333.GB19590@elte.hu>
	 <200801221755.56470.caglar@pardus.org.tr>  <20080122160557.GA31831@elte.hu>
Content-Type: text/plain; charset=utf-8
Date: Tue, 22 Jan 2008 11:03:49 -0600
Message-Id: <1201021429.14436.45.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-22 at 17:05 +0100, Ingo Molnar wrote:
> * S.Çağlar Onur <caglar@pardus.org.tr> wrote:
> 
> > > My theory is that for whatever reason we get "repeat" IPIs: multiple 
> > > reschedule IPIs although the other CPU only initiated one.
> > 
> > Ok, please see http://cekirdek.pardus.org.tr/~caglar/dmesg.3rd :)
> 
> hm, the IPI sending and receiving is nicely paired up:
> 
> [  625.795008] IPI (@smp_reschedule_interrupt) from task swapper:0 on CPU#1:
> [  625.795223] IPI (@native_smp_send_reschedule) from task amarokapp:2882 on CPU#1:
> 
> amarokapp does wake up threads every 20 microseconds - that could 
> explain it. It's probably Xorg running on one core, amarokapp on the 
> other core. That's already 100 reschedules/sec.

That suggests we want an "anti-load-balancing" heuristic when CPU usage
is very low. Migrating everything onto one core when we're close to idle
will save power and probably reduce latencies.

-- 
Mathematics is the supreme nostalgia of our time.

