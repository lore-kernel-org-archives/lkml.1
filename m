Return-Path: <linux-kernel-owner+w=401wt.eu-S1760348AbZEGPPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760348AbZEGPPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 11:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbZEGPP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 11:15:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57398 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752656AbZEGPP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 11:15:27 -0400
Date: Thu, 7 May 2009 16:14:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Lameter <cl@linux.com>
Cc: Alok Kataria <akataria@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Reduce the default HZ value
Message-ID: <20090507161440.5b9c067d@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.1.10.0905071010170.24528@qirst.com>
References: <1241462661.412.8.camel@alok-dev1>
	<4A00ADDE.9000908@zytor.com>
	<1241560625.8665.17.camel@alok-dev1>
	<alpine.DEB.1.10.0905071010170.24528@qirst.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009 10:13:52 -0400 (EDT)
Christoph Lameter <cl@linux.com> wrote:

> I think we need to reduce the general tick frequency to be as low as
> possible. With high resolution timers the tick frequency is just the
> frequency with which the timer interrupt disturbs a running application.
> 
> Are there any benefits remaining from frequent timer interrupts? I would
> think that 60 HZ would be sufficient.

50 works for various european video apps, 60 breaks, 60 works for various
US video apps, 50 breaks. Now that may have changed with all the select
stuff being hrtimer based (which I'd missed).

The tick also still appears to be involved in ntp and in cpu stats where
a 50Hz tick would mean only 25Hz accuracy on CPU usage etc

