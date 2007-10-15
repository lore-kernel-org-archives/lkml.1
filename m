Return-Path: <linux-kernel-owner+w=401wt.eu-S1764758AbXJOTjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764758AbXJOTjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 15:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756701AbXJOTjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 15:39:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53648 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753975AbXJOTjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 15:39:13 -0400
Date: Mon, 15 Oct 2007 12:38:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Boaz Harrosh <bharrosh@panasas.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch] scsi: fix crash in gdth_timeout()
In-Reply-To: <20071015192703.GA7279@elte.hu>
Message-ID: <alpine.LFD.0.999.0710151232430.6887@woody.linux-foundation.org>
References: <20071015165534.GA17833@elte.hu>
 <alpine.LFD.0.999.0710151006400.6887@woody.linux-foundation.org>
 <4713A9FA.4050209@garzik.org> <4713B4E7.2050001@panasas.com>
 <20071015192703.GA7279@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Oct 2007, Ingo Molnar wrote:
> 
> heh. Incidentally i was thinking about using KVM for automated testing. 

Using emulators to test device drivers is almost certain to be pointless.

The problem with device drivers tends to be timing issues, odd hardware 
interactions, and lots of strange (and sometimes undocumented) behaviour 
and dependencies (eg things like "you have to wait 50us after setting the 
reset bit until the hardware has actually reset").

These are all things that you'd generally not catch in emulation - because 
the emulation by necessity is only going to be a very weak picture of the 
real thing.

So I suspect you can find the easy stuff, but only by writing insanely 
complex device model descriptions in the emulator environment itself, and 
only for those device models that have actually been written.

Can it be donein theory? Sure. Practically? Not so sure. Would it help? I 
suspect the effort to do the device model would be many times bigger than 
*any* conceivable effort to just fix the driver bugs as they get found 
through other means.

So we could perhaps have *really* good emulated hardware for a few models 
of hw out there, but likely they'd be fewer and less varied platforms than 
most kernel developers end up having hidden under their desk anyway.. 

			Linus
