Return-Path: <linux-kernel-owner+w=401wt.eu-S1752521AbYGSFQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbYGSFQi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 01:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbYGSFQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 01:16:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:44402 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbYGSFQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 01:16:30 -0400
Date: Fri, 18 Jul 2008 22:16:30 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dwalker@mvista.com
Subject: Re: [patch 0/3] fastboot patches series 1
Message-ID: <20080718221630.2809abbd@infradead.org>
In-Reply-To: <488172E0.6050502@simon.arlott.org.uk>
References: <20080718151524.5ef9e29b@infradead.org>
	<488172E0.6050502@simon.arlott.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul 2008 05:51:44 +0100
Simon Arlott <simon@fire.lp0.eu> wrote:

> 
> This is a great idea... I was thinking about trying to run usb 
> initialisation in parallel because it takes so long. It would be more 
> useful to run usb init in parallel with ide/sata on my system, since
> they both take a while to run (I realise /dev/sd* will be in a
> unstable order).
> 
> Unfortunately this patch set has the opposite effect on my system...
> something appears to be going badly wrong (logs attached). The mouse 
> pointer was really erratic so I reconnected it (by turning the hub in 
> my display off/on)... that took a while:

is this repeatable? and was it repeatedly stable before?


> 
> Strangely, when this output appeared:
> [    1.370693] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00,
> driver 10 Dec 2004
> 
> I didn't see anything else until the next screenful of output, but
> the log shows this output before that:
> [    4.683674] usb usb1: default language 0x0409
> [    7.548621] usb usb1: uevent
> 
> There was another long pause with no output but I can't see where
> from reading back the log. The timestamps are a bit confused too,
> jumping +/-10s.

looks like you have a timing problem.. can you try booting with "notsc"
and see if that fixes it?


One possible theory is that we now run on both cpus and if they're out
of sync timewise, things like delays suddenly are shorter than expected
if time jumps around....

can you also post a dmesg of a successful boot?

(and I'm supposed to give you a hard time for using a proprietary
module, but something is clearly going wrong before it's even loaded so
for now I'll just ignore that ;-)
