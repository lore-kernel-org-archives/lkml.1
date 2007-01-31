Return-Path: <linux-kernel-owner+w=401wt.eu-S1030378AbXAaRWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030378AbXAaRWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030331AbXAaRWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:22:37 -0500
Received: from www.osadl.org ([213.239.205.134]:60826 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030340AbXAaRWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:22:11 -0500
Subject: Re: [PATCH 23/23] clocksource tsc: add verify routine
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@osdl.org, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com
In-Reply-To: <1170262956.9781.117.camel@imap.mvista.com>
References: <20070131033710.420168478@mvista.com>
	 <20070131033810.319576375@mvista.com>  <20070131124300.GG1847@elte.hu>
	 <1170262956.9781.117.camel@imap.mvista.com>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 18:22:56 +0100
Message-Id: <1170264177.29240.184.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 09:02 -0800, Daniel Walker wrote:
> > well, this implementation is buggy in at least two ways:
> > 
> > firstly, it allows a circular verification dependency in highres+dyntick 
> > mode between the jiffies and tsc clocksources.
> 
> In the current implementation, it's only happens if the only clocks that
> exist are "tsc" and "jiffies" which makes verification impossible
> anyway .. It's unlikely, but it is possible , the fix is not that
> complex.

Wrong. You actually can verify against jiffies. Johns orginal code did
this and mine does too. Actually this _IS_ necessary otherwise you can
not detect that the BIOS changed the cpu freqeuncy behind the kernels
back. 

The circular problem is only relevant when you switch to highres/nohz.

	tglx


