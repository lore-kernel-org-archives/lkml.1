Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbYDNIcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbYDNIcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756538AbYDNIcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:32:11 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:18344 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbYDNIcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:32:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dPLJoAEaa00Pu0McVYJgroKLjbDFTWE/u0NMyW44NL5Rqzt2M/gjSpBY1vWz5ygDC37kZikWJU6oXhQRSJb2U8klbUZvWBAeEA4A8OoCKuJ1PQKz5x4zFHeELEsUGDqhA3SYs+r1Q2o+rca2DVJkm2IeMAgdevNw/kEvVoEoRP8=
Message-ID: <d55656c10804140132l6be8dd21s1a073efc3ce0b956@mail.gmail.com>
Date: Mon, 14 Apr 2008 10:32:08 +0200
From: "Peter Gervai" <grinapo@gmail.com>
To: trenn@suse.de
Subject: Re: sata_via
Cc: "Tejun Heo" <htejun@gmail.com>, "Rich West" <Rich.West@wesmo.com>,
       "Jeff Garzik" <jeff@garzik.org>,
       "Wander Winkelhorst" <w.winkelhorst@gmail.com>,
       linux-kernel@vger.kernel.org,
       "Linux IDE mailing list" <linux-ide@vger.kernel.org>,
       "Marin Mitov" <mitov@issp.bas.bg>
In-Reply-To: <1208160803.1784.14.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47F694C8.8020507@wesmo.com> <47F6BD55.3090708@wesmo.com>
	 <5699f8f00804050015kb1ebb1cpf3ab8b587580fffd@mail.gmail.com>
	 <47F7982E.5080701@wesmo.com> <47F7F463.2060402@garzik.org>
	 <480173CB.5070805@gmail.com> <480189DB.9050900@wesmo.com>
	 <48018DC0.6080407@wesmo.com> <1208133587.2755.8.camel@htj.dyndns.org>
	 <1208160803.1784.14.camel@queen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 10:13 AM, Thomas Renninger <trenn@suse.de> wrote:

>  > IRQ routing seems hosed on your machine.  Thomas any ideas?
>
>  Not really.
>  First, I'd try to be able to reproduce this more quickly, an IO
>  benchmark or similar (bonnie?).
>
>
>  ----------------------------------------------
>  Peter Gervai posted a similar report recently, Elias Oltmanns had an
>  idea (on linux-ide or linux-acpi list):
>  Subject: Re: Hard freeze / interrupt-related death / instability
>  Wed, 09 Apr 2008
>
>  (but Tejun was already involved into that, at least in the link posted
>  there, but reading it up might be worth it).
>  Is this the same problem?

Mmhm, as I was (kindly) cc'd I reply my results so far, but since
there was a mention of IRQBALANCE, I checked myself, since I was
pretty sure I have switched that off:
# zegrep IRQ /proc/config.gz
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQBALANCE=y
CONFIG_HT_IRQ=y
CONFIG_IDEPCI_SHARE_IRQ=y
CONFIG_HPET_RTC_IRQ=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_DEBUG_SHIRQ is not set

Darn, I'd say. I go and switch balancer off, it doesn't really do much
good for me anyway. (What about userland balancer, does it hose things
as well?)

But apart from that I'm runnig under " pci=nomsi " for the last 4 days
without a freeze (which usually occured every 1-2 days, but I'll wait
for more, and I will try to bonnie++ myself in the meantime). It did
not freeze under "acpi_irq_balance" either for 6 days, but the machine
overall felt a bit jerky (pretty ugly irq overlaps I guess).

If any of you prefer me to run under other options, or to apply that
patch I was advised to, I'll just do that. Just voice yourself.  (I
have an open request for "noapic acpi_irq_nobalance" and the patch.)

Thanks for your time, as always (and I try to share mine :)).

-- 
 byte-byte,
 grin
