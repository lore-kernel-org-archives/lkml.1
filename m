Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbYFWLaC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbYFWLaC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 07:30:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbYFWL3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 07:29:43 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:26096 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752341AbYFWL3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 07:29:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=ssDIbEGlMFXOmC5xHDWscPv+mN9Quj/6op46NTCTmT5Visc2dOxrhSOGpWxQC3lwWROWCjKcA26qXV3+6Dimy011M5fQo8vk4etMQZHAPACejGlgWBepzEib0avQeIFhFzWi12IjU6kMAiGiZ9+PU8HiylJvOJGcXpOEVpgY5ww=  ;
X-YMail-OSG: oGRnkvUVM1ku5PAZzOhs_SbgkgD2DxLYpwfEtm6ica79fSq2DtbtmyviMrKPOKknh1Ko9pspunbNjiQYFx9txO.uvhTyRe4OgZ575BxkHyPErPdPYr7U3ZC5QeMGTPDTKKs-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch] x86 supports NO_IRQ convention
Date: Mon, 23 Jun 2008 04:29:36 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, hpa@zytor.com
References: <200806221953.18849.david-b@pacbell.net> <20080623100823.61213c3f@lxorguk.ukuu.org.uk>
In-Reply-To: <20080623100823.61213c3f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806230429.36298.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2008, Alan Cox wrote:
> Zero is not a valid IRQ in the kernel mapping of things.

That's counter-factual:

           CPU0       CPU1       
  0:   42851354    6500253   IO-APIC-edge      timer
  1:     475459      45904   IO-APIC-edge      i8042
  8:          0          1   IO-APIC-edge      rtc0
  9:        135         18   IO-APIC-fasteoi   acpi
 12:    5232181     495206   IO-APIC-edge      i8042
 ...

That's on x86.  A quick survey of other boards around here
shows many that use IRQ 0 too.

I certainly agree it'd be convenient to be able to just test
for IRQ being nonzero.  Presumably only one driver would ever
end up using IRQ 0 on x86, so other drivers could ignore the
fact that testing for nonzero would mean "not the timer irq"
rather than "no irq assigned".

- Dave
