Return-Path: <linux-kernel-owner+w=401wt.eu-S1758892AbYDJQH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892AbYDJQH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 12:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756628AbYDJQHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 12:07:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:12143 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964AbYDJQHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 12:07:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PJbg4rpKQMzo6LVhPRkHvEsN/qFw2wXHptDF6x3oi2FlDyoKR83QkrW/WvJo+ykwCvkB8ft4vaHkb51DrggaTR+E/N2hKR51+LrG2o29+3PmscWNrm4n4W0Sjipui3NgehdUKsKbLuYTSFZWiLCGQT5BbMEY+TieSWeSETIOSlM=
Message-ID: <e2e108260804100907i58fa5d36ma0cb415c10054a2d@mail.gmail.com>
Date: Thu, 10 Apr 2008 18:07:14 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Jack Harvard" <jack.harvard@googlemail.com>
Subject: Re: gettimeofday() resolution in Linux?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <a72f6a3c0804100740s687beacbh80653107f4a7b702@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a72f6a3c0804100740s687beacbh80653107f4a7b702@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 4:40 PM, Jack Harvard
<jack.harvard@googlemail.com> wrote:
>  I would like to ask a few questions about how Linux keeps time.
>
>  As far as I understand,
>  1. Linux's time resolution is 10ms, as defined by HZ=100.
>  2. gettimeofday() can get time in microseconds, but I'm not sure about
>  the accuracy of the time finer than 10ms. Sometimes gettimeofday( )
>  can even give me microseconds results rolled backwards in time, which
>  I suspect could be caused by its accuracy. My question here is "how
>  accurate is the time from gettimeofday()"
>  3. If I want to increase the time resolution to 1ms, I can possibly
>  change HZ=1000, but if I want 1usec resolution, how can I do that? It
>  would be too busy for the processor to handle so frequent timer
>  interrupts if I just increase HZ=1000000.

You should use clock_gettime(CLOCK_MONOTONIC) instead of
gettimeofday() for interval timing. As soon as NTP software is
running, the result of gettimeofday() can jump forward or backward in
time. The result of clock_gettime() is guaranteed to be monotonic, and
additionally the resolution of clock_gettime() is higher than
gettimeofday() -- 1 ns instead of 1 us.

Changing HZ only makes sense on very old hardware that does not have a
TSC or equivalent register (e.g. the Intel 486 CPU).

Bart.
