Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbZFBO7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbZFBO7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbZFBO7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:59:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63617 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbZFBO67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:58:59 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jun 2009 10:58:59 EDT
From: Karsten Keil <isdn@linux-pingi.de>
Reply-To: isdn@linux-pingi.de
To: Andreas Mohr <andi@lisas.de>
Subject: Re: [PATCH] mISDN GIT: hfcpci cleanup failure on IRQ weirdness
Date: Tue, 2 Jun 2009 16:53:35 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
References: <20090602140250.GA3607@rhlx01.hs-esslingen.de>
In-Reply-To: <20090602140250.GA3607@rhlx01.hs-esslingen.de>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906021653.36152.isdn@linux-pingi.de>
X-Provags-ID: V01U2FsdGVkX186SNSrmww3ywZYmD8ByaQuR+e4IIf4SRtDVAE
 UnsRbdxZpck/NSeCQNmXHA3hyNM/gYmeI5aBEx15fQzz8ybOrV
 Qy+KlvK9+IDk7eQz4pbuPAPN76Mgcad
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dienstag, 2. Juni 2009 16:02:50 you wrote:
> Hi,
>
> > I have the suspicion that maybe I shouldn't be loading hisax upon boot
> > (and then immediately removing it before launching mISDN stuff),
> > since hfcpci acts very weird - perhaps it cannot recover card state fully
> > after hisax fumbling.
>
> Indeed, manually killed all hisax modules on the system, rebooted, and -
> it worked, immediately!
> (test call SIP -> Asterisk -> LCR -> ISDN -> out -> ISDN)
>
> IOW, we've got an unfortunate driver init state handling issue which one
> should perhaps investigate to make the driver more robust against
> varying hardware state.
> (my IRQ patch was a first step I guess ;)
>

Yes from mISDN side, but I do not see what inside hisax prevent mISDN from
getting IRQs after hisax was unloaded. And it works here on my test setup, I 
can load mISDN without an error, after unloading hisax.
One other issue with the HiSax  HFC PCI code is the FIFO DMA memory
allocation, this code is wrong  and broken (patch is under test).

> misdn_log still acts weird, though...
>
What does be weird here ?

> Thanks for all your important ISDN work! (given the sizeable number of
> commits mISDN will rather soon get there I think)
>
> BTW, could isdnlog be adapted to support mISDN relatively easily?
> (since adding CAPI support would take longer I guess)

isdnlog (beside that the isdnlog code is ugly enough) should be not a big 
issue, mISDN supports logging in parallel to the normal work, look at the
tools/loghex.c  code how to create a logging socket.
It should make things easier as with HiSax, since it will get the data as 
binary and not as hexdump.

> My guys are going semi-ballistic with their isdnlog taken out and shot ;)
>
> Andreas Mohr
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

