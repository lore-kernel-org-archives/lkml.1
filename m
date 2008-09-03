Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbYICRbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbYICRbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYICRbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:31:12 -0400
Received: from inhex.net ([193.33.178.145]:51212 "EHLO inhex.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493AbYICRbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:31:11 -0400
X-Greylist: delayed 2795 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Sep 2008 13:31:11 EDT
Date: Wed, 3 Sep 2008 19:44:15 +0300
From: Dmitry Nezhevenko <dion@inhex.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       herton@mandriva.com.br,
       Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5 doesn't boot on a Pavilion laptop
Message-ID: <20080903164415.GA24442@laptop.local>
References: <20080902163532.436f8fbd@doriath.conectiva> <alpine.LFD.1.10.0809022208320.3243@apollo.tec.linutronix.de> <20080902175544.131bc54e@doriath.conectiva> <alpine.LFD.1.10.0809031202290.3243@apollo.tec.linutronix.de> <20080903104132.7a736282@doriath.conectiva> <alpine.LFD.1.10.0809031635260.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809031713040.3243@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809031713040.3243@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 05:15:40PM +0200, Thomas Gleixner wrote:
> On Wed, 3 Sep 2008, Thomas Gleixner wrote:
> > Dont think so. Your dmesg outputs do not show any sign of that
> > disease.
> > 
> > Can you try the patch below please ?

I'm not original problem reporter. However I'm experiencing possible same
problem with MSI M673 laptop. Here is link to bugzilla report (with
dmesgs and other info):
http://bugzilla.kernel.org/show_bug.cgi?id=11101

2.6.27-rc4 on this machine freezes with exactly same messages:

hpet0: at MMIO 0xfed00000, IRQ 2, 8, 31
hpet0: 3 32-bit timers, 25000000 Hz
ACPI: RTC can wake from S4

This patch do not help me

> @@ -228,6 +228,8 @@ static void tick_do_broadcast_on_off(voi
>  	if (!tick_device_is_functional(dev))
>  		goto out;
>  
> +	bc_stoppped = cpus_empty(tick_broadcast_mask);

btw little type here, should be "bc_stopped"

> +
>  	switch (*reason) {
>  	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
>  	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
 
-- 
WBR, Dmitry
