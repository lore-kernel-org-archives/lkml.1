Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbZCXW2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbZCXW2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZCXW15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:27:57 -0400
Received: from mail-gx0-f208.google.com ([209.85.217.208]:64979 "EHLO
	mail-gx0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbZCXW14 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:27:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QeHGrncHt6UhyzJIk2OLF/FodGBsPBkRG3cBFGKdzeeF1wxnHCAwmqJXbDlfDjve9l
         8FeVE5WU1j90WkDiV4IoBeE54gImsy8crWjPinAKm+FMIbLN6ql4B5O/CC96YWBKhOHL
         P/tdr+V3mloIezmiJ5X5aOfxDKUwydKP3rNZE=
MIME-Version: 1.0
In-Reply-To: <49C919B9.70302@msgid.tls.msk.ru>
References: <874ozu2hcl.fsf@divinity.mikat.iki.fi>
	 <20090310101807.GD20716@alberich.amd.com>
	 <20090311100525.GE20716@alberich.amd.com>
	 <49B7A79A.6090008@msgid.tls.msk.ru>
	 <87ocw8qfwg.fsf@divinity.mikat.iki.fi>
	 <49C919B9.70302@msgid.tls.msk.ru>
Date: Tue, 24 Mar 2009 15:27:53 -0700
X-Google-Sender-Auth: cec030fadcf92cd1
Message-ID: <1f1b08da0903241527y4191b504k1b5aa0a02f136f7e@mail.gmail.com>
Subject: Re: Slow clock on AMD 740G chipset
From: john stultz <johnstul@us.ibm.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Mika Tiainen <mikat@iki.fi>, Andreas Herrmann <andreas.herrmann3@amd.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 10:34 AM, Michael Tokarev <mjt@tls.msk.ru> wrote:
> [resurrecting (hopefully) an old thread.
>  Top-posting to keep old mess around for reference.]
>
> To refresh what has been said.  Several people observed slow clock
> on their - mostly AMD 780g, 740g and 690g-based systems with 2.6.28
> 2.6.27 kernels.  Slow to a point when ntpd wasn't successful to
> keep up with the drift.  It has been said that the motherboards are
> flaky or something and that the clocks has to be calibrated, for
> which there are known procedures available (adjtimex).  Which helped.
> Before the "calibration" the clock were off by ~15 minutes per day.
>
> But today I tried newly released 2.6.29 kernel on one of the affected
> systems - just because I wanted to test something else.  And noticed
> that the clock is running too fast.  After some calculation I see that
> it will run away for about 15 minutes per day, that is, exactly the
> number which was used to compensate for slow clock on 2.6.2[78].
>
> So it seems that with 2.6.29, all the motherboards suddenly become
> non-flaky and the timers need no calibration anymore, working just
> fine.  Other operating systems and kernel versions also agree with
> this conclusion of 2.6.29.
>
> Any comments on this strange phenomenon ? :)

This sounds like the Fast PIT TSC calibration fix that Linus included
fairly late in 2.6.29-rc (commit
a6a80e1d8cf82b46a69f88e659da02749231eb36). The Fast PIT method was
causing some error on some systems, such that the TSC calibrated more
then 500ppm off of its actual value, causing NTP to not be able to
compensate (the adjtimex tick manipulation folks in this thread are
doing just pulls that value back into range where NTP can correct).

See the "Linux 2.6.29-rc6" thread for details.

thanks
-john
