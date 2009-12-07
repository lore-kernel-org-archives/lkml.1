Return-Path: <linux-kernel-owner+w=401wt.eu-S965045AbZLGVaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965045AbZLGVaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 16:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935036AbZLGVa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 16:30:29 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:36014 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191AbZLGVa3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 16:30:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=K06c/VJL0nr/rb++j4Oz0MG2cNeW5uHSf/WFMp4mm5hyF/86DzUGlN5tzho9ernT2t
         u065S0Udy2+IRI6ykYK+FoX3uSK7w10jw3SnxTaatGDteyiQGHgzzcs7JPmdpcjQdKw/
         /j2IAJwIkgrw81B+UJ2w0Ge0nVdMqvuucfs/Y=
MIME-Version: 1.0
In-Reply-To: <SNT111-DS1957B574BA05A48FEDBFF0A7900@phx.gbl>
References: <Acp3UXhD1R6mbV5yTGykTs+HAU6bQg==>
	 <SNT111-DS1957B574BA05A48FEDBFF0A7900@phx.gbl>
Date: Mon, 7 Dec 2009 13:30:35 -0800
X-Google-Sender-Auth: 7698a8027b22f693
Message-ID: <1f1b08da0912071330i35808790r554f7a3a8d712ca7@mail.gmail.com>
Subject: Re: timer interrupt stucks using tickless kernel
From: john stultz <johnstul@us.ibm.com>
To: Ioannis Kyriakopoulos <johnkyr83@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 7, 2009 at 7:25 AM, Ioannis Kyriakopoulos
<johnkyr83@hotmail.com> wrote:
> I have configured my kernel (2.6.31.6) so that I get periodic ticks from
> the timer interrupt (i.e. tickless is not configured) with a rate determined
> by the HZ value. I've also checked the "high resolution timer support"
> and also SMP support. The posblem is that the timer is getting incremented
> very slowly (way slower than the HZ value), just like it would be if the
> kernel was tickless. Is there an explanation for that? How can I get
> periodic
> timer ticks?
>
> AFAI understand, the HPET timer is used through the IO-APIC controller to
> trigger the processors (N.B. if the "High Resolution Timer Support" option
> wasn't checked, the timer used would  be PIT, right?) and each processor's
> LAPIC timer is used for time keeping. Please correct me if I am wrong.

Not quite, if High Resolution Timers support was disabled, you would
still use the HPET hardware instead of the pit, but you'd stay in
periodic mode. However, since you have Highres Timers on, the system
is using oneshot mode (which is necessary to trigger interrupts faster
then HZ), and likely has chosen the LAPIC timer as the interrupt
source.

In this case, the timer tick becomes an hrt event, that triggers every
HZ, instead of being caused by a periodic interrupt.

thanks
-john
