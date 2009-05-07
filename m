Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbZEGQh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbZEGQh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 12:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbZEGQhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 12:37:50 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:46434 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754130AbZEGQht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 12:37:49 -0400
Subject: Re: [PATCH] x86: Reduce the default HZ value
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Lameter <cl@linux.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090507161440.5b9c067d@lxorguk.ukuu.org.uk>
References: <1241462661.412.8.camel@alok-dev1>	<4A00ADDE.9000908@zytor.com>
	 <1241560625.8665.17.camel@alok-dev1>
	 <alpine.DEB.1.10.0905071010170.24528@qirst.com>
	 <20090507161440.5b9c067d@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 07 May 2009 09:37:50 -0700
Message-Id: <1241714270.32495.6.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2009-05-07 at 08:14 -0700, Alan Cox wrote:
> On Thu, 7 May 2009 10:13:52 -0400 (EDT)
> Christoph Lameter <cl@linux.com> wrote:
> 
> > I think we need to reduce the general tick frequency to be as low as
> > possible. With high resolution timers the tick frequency is just the
> > frequency with which the timer interrupt disturbs a running application.
> > 
> > Are there any benefits remaining from frequent timer interrupts? I would
> > think that 60 HZ would be sufficient.
> 
> 50 works for various european video apps, 60 breaks, 60 works for various
> US video apps, 50 breaks. Now that may have changed with all the select
> stuff being hrtimer based (which I'd missed).

I would have assumed whatever timeout mechanism the video apps use
should have already been converted to hrtimers ? Or are you saying that
they use select stuff which is already hrtimer based and so there
shouldn't be any problem now for video apps ? 

> 
> The tick also still appears to be involved in ntp and in cpu stats where
> a 50Hz tick would mean only 25Hz accuracy on CPU usage etc
> 

