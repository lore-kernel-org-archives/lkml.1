Return-Path: <linux-kernel-owner+w=401wt.eu-S1761578AbYBBHNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761578AbYBBHNy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 02:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755811AbYBBHNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 02:13:45 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:28571 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbYBBHNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 02:13:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=l0piPaiFtRosQ20bMZpc+CqQt+Yo4S5dzfhtbnbGuudeGXnW2lxDB3lyaECA8JRJflo4bznhJDklMTVw2rj/J+UzQUqZVGgTQylUD+9KjPX5IFEBVoCBLhbE9N/U7yDtAftoz1GXrIOA/z0FJst2iyUN46YIgvIHeAMDiL3xPqw=
Message-ID: <47A41820.2070907@gmail.com>
Date: Sat, 02 Feb 2008 16:13:36 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Kasper Sandberg <lkml@metanurb.dk>
CC: Gene Heskett <gene.heskett@gmail.com>, Mikael Pettersson <mikpe@it.uu.se>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
References: <200801272122.21823.gene.heskett@gmail.com>	 <200801281135.14555.gene.heskett@gmail.com>	 <1201580616.12795.2.camel@localhost>	 <200801282349.11696.gene.heskett@gmail.com> <1201582875.12795.15.camel@localhost>
In-Reply-To: <1201582875.12795.15.camel@localhost>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kasper Sandberg wrote:
> to put some timeline perspective into this.
> i believe it was in 2005 i assembled the system, and when i realized it
> was faulty, on old ide driver, i stopped using it - that miht have been
> in beginning of 2006. then for almost a year i werent using it, hoping
> to somehow fix it, but in january 2007 i think it was, atleast in the
> very beginning of 2007, i hit upon the idea of trying libata, and ever
> since the system has been running 24/7 - doing these errors around 2
> times a day.
> 
> i have multiple times reported my problems to lkml, but nothing has
> happened, i also tried to aproeach jgarzik direcly, but he was not
> interested.
> 
> i really hope this can be solved now, its a huge problem
> 
> my fileserver has an asus k8v motherboard, with via chipset (k8t880 i
> think it is, or something like it). currently using the promise
> controller again(strangely enough all the timeouts seems to happen here,
> and when the ITE was on, there, not the onboard one), in conjunction
> with the onboard via.

Timeouts are nasty to debug.  It can be caused by whole range of
different problems including transmission errors, bad power, faulty
drive, mishandled media error, IRQ misrouting, dumb hardware bug.  It's
basically 'uh... I told the controller to do something but it never
called me back'.

If you see timeouts on multiple devices connected to different
controllers, the chance is that you have problem somewhere else.  The
most likely culprit is bad power.  Please...

* Post the result of 'lspci -nn' and kernel log including full boot log
and error messages.

* Try to isolate the problem.  ie. Does removing several number of
drives fix the problem?  If the problem is localized to certain device,
what happens if you move it?  Does the problem follow the drive or stay
with the port?  If the failing drives are SATA, it's a good idea to
power some of the failing drives with a separate PSU and see whether
anything is different.

By trying to isolate the hardware problem, more can be learned about the
error condition and even when the problem actually isn't hardware
problem, it gives us much deeper insight of the problem and clues
regarding where to look.

Thanks.

-- 
tejun
