Return-Path: <linux-kernel-owner+w=401wt.eu-S1751689AbXBVQmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbXBVQmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 11:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbXBVQmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 11:42:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38683 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbXBVQmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 11:42:13 -0500
Subject: Re: NO_HZ: timer interrupt stuck [Re: Linux 2.6.21-rc1]
From: Arjan van de Ven <arjan@infradead.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: tglx@linutronix.de, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <45DDC488.1080008@drzeus.cx>
References: <20070221230409.GA1158@dreamland.darkstar.lan>
	 <1172099859.25076.132.camel@localhost.localdomain>
	 <Pine.LNX.4.61.0702221334460.28624@yvahk01.tjqt.qr>
	 <1172150712.3531.265.camel@laptopd505.fenrus.org>
	 <45DDA43A.4030509@drzeus.cx>
	 <1172154034.3531.270.camel@laptopd505.fenrus.org>
	 <45DDADEB.3030309@drzeus.cx>  <45DDB31C.8070306@drzeus.cx>
	 <1172160024.25076.188.camel@localhost.localdomain>
	 <45DDC488.1080008@drzeus.cx>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 22 Feb 2007 17:42:06 +0100
Message-Id: <1172162526.3531.275.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 17:27 +0100, Pierre Ossman wrote:
> Thomas Gleixner wrote:
> >
> > Here is the reason. The local APIC stops working in C3 state and we fall
> > back to the PIT in that case. Not really exciting for dynticks, but the
> > only way to keep the system alive. There is a patch coming up from
> > Intel, which finds out how to use HPET even if it is not enabled by the
> > BIOS. This will still end up on IRQ#0, but will give way longer idle
> > sleeps than the PIT.
> >
> >   
> 
> So then the next two questions are; is it possible to disable C3 

yeah there is a commandline thingy for it
> and is
> it a net power gain to get rid of the wakeups in favor of having C3.

no; c3 saves a TON more power. 

you can try enabling HPET in your BIOS...

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

