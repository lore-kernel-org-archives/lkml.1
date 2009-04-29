Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbZD2Qpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbZD2Qpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 12:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZD2Qpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 12:45:42 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:59875 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbZD2Qpm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 12:45:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=j1fS4Bn8hMAJ1H+dfbzhgvJP7eTDHWj7ZcPf0vRVmklKaxSOAL1vIo7R942gLj1VvR
         s9jJ3AG7RFFZnjn8kgY3SWQ/HvOAgj0d2A+hAqm8H1380I52amiL4QcLOYAJ5cVGcBQe
         KEIN33rnpMw0UncvZmhC/KfErU6+P8z1lUS9o=
MIME-Version: 1.0
In-Reply-To: <20090221023943.GA4894@spacedout.fries.net>
References: <20090221023943.GA4894@spacedout.fries.net>
Date: Wed, 29 Apr 2009 09:45:40 -0700
X-Google-Sender-Auth: d8c7983916476a29
Message-ID: <1f1b08da0904290945j79e1b578ye415fe4ced259b15@mail.gmail.com>
Subject: Re: TSC marked unstable on suspend and resume
From: john stultz <johnstul@us.ibm.com>
To: David Fries <david@fries.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 7:39 PM, David Fries <david@fries.net> wrote:
> I'm getting TSC marked as unsable on hibernate to disk with
> 2.6.29-rc3.  The last kernel I ran 2.6.24.4 ran 300+ days without a
> problem and does not loose TSC on hibernate.
>
> I'm hibernating with `echo disk > /sys/power/state`.
> These look like the relavant messages,
>
> CPU 0 irqstacks, hard=c0379000 soft=c0378000
> PID hash table entries: 1024 (order: 10, 4096 bytes)
> Fast TSC calibration using PIT
> Detected 300.705 MHz processor.
> Calibrating delay loop (skipped), value calculated using timer frequency.. 601.41 BogoMIPS (lpj=300705)
> hibernate to disk,
> Restarting tasks ... done.
> Clocksource tsc unstable (delta = 499883531 ns)

Hmm. Seems like the clocksource watchdog is having some problem
handling state around hibernate.

Out of curiousity: Does suspend-to-ram also trigger this?

Can you send me a full dmesg log?

thanks
-john
