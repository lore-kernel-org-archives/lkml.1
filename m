Return-Path: <linux-kernel-owner+w=401wt.eu-S965650AbXAZNHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965650AbXAZNHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 08:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965655AbXAZNHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 08:07:32 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:36634 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965650AbXAZNHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 08:07:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GXigIJV3ISsMMYcwbLDLDZa1Kjy3S1LjrPraBfC7Hx1+SzbRXQtQQr1Lgdzp35FEBhCxmCbCA83kD+IfxRxDoZQMk0WfTo0WXDQ5TFNMnPItBzvdkIrqHYR4lTQY1au18vEA+cP1M+hV2FCAKlOwFaSJ2CPND5LfyjPK7Lx6GXs=
Message-ID: <e6babb600701260507m51674894r5884f9a7fafa4f84@mail.gmail.com>
Date: Fri, 26 Jan 2007 06:07:29 -0700
From: "Robert Crocombe" <rcrocomb@gmail.com>
To: linux1394-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: In-tree version of new FireWire drivers available
In-Reply-To: <45B88088.4020505@joow.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <59ad55d30701231948u5f1e02d8x3d06553cb373e5be@mail.gmail.com>
	 <45B75FDB.1000004@joow.be>
	 <59ad55d30701241245l7671af23w3e19a83621c6fb51@mail.gmail.com>
	 <45B88088.4020505@joow.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/07, Pieter Palmers <pieterp@joow.be> wrote:
> I'd like to make one note here:
> We should have a way to use smaller DMA buffers than one page size. If I
> remember correctly, the page size on my system is 4096 bytes, being 1024
> quadlets. If we assume a 4 channel audio stream, this corresponds to 256
> audio samples. This means that the controller generates an interrupt
> every 256 samples, making that we can achieve a latency of 512 samples
> at best. This is unacceptable in a pro-audio environment.
>
> The current stack exhibits this problem, and I solve it by recalculating
> the max packet size, based upon the stream composition (i.e. expected
> packet size) and the requested audio buffer size, such that the
> interrupts are generated at a high enough frequency.
>
> I'm not a kernel hacker, but when looking through the code I had the
> impression that smaller DMA buffers were possible (aren't smaller
> buffers used in packet-per-buffer mode?).

I am using isochronous receive in RAW1394_DMA_PACKET_PER_BUFFER mode
because I am closing a simulation loop around the data that is
received/transmitted.  Just for giggles I cranked up a test
isochronous stream from a bus analyzer at 1kB per packet at 8kHz at
the S400 rate (i.e., one packet on each cycle start: 8MBps ), set the
machine up to listen, and was able to maintain 8kHz interrupts at ~12%
CPU utilization on a 2.8GHz Opteron.

   1744719 interrupts int 218.112 seconds is 7999.193 ints/sec

I wasn't doing anything with the data for this test, but I have had
the aforementioned sim running steady at a somewhat lower rate.  This
test ran under 2.6.20-rc5-rt10, but the more "productiony" system is
on 2.6.16-rt29.

So hopefully you can get markedly lower latencies.  Myself, I'm
tickled pink by the performance that can be achieved.

-- 
Robert Crocombe
