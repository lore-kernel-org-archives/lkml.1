Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbYDJP72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbYDJP72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbYDJP7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:59:20 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:14550 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227AbYDJP7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:59:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LMFqOHBAk4vhetWvb8pz/BtP3WLCiRNQB6c/3Eihx6tg2kHjsaomSX1Xary3qtmwuD2A08ayfqi0lRVX0BCYY/cgyvBrXk2+QAQyBj1hcQeaEPmCzUX5WO5WLSj567Wj5U0+ku+i/1XWPY18wh4zVdMxtTo8LRiEd9vhh9fTR4k=
Message-ID: <a72f6a3c0804100859w4181d84ak1a63e7dec4d5b42f@mail.gmail.com>
Date: Thu, 10 Apr 2008 16:59:17 +0100
From: "Jack Harvard" <jack.harvard@googlemail.com>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Subject: Re: gettimeofday() resolution in Linux?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080410150424.GD2160@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a72f6a3c0804100740s687beacbh80653107f4a7b702@mail.gmail.com>
	 <20080410150424.GD2160@csclub.uwaterloo.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 4:04 PM, Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
> On Thu, Apr 10, 2008 at 03:40:59PM +0100, Jack Harvard wrote:
>  > I would like to ask a few questions about how Linux keeps time.
>  >
>  > As far as I understand,
>  > 1. Linux's time resolution is 10ms, as defined by HZ=100.
>
>  The timer resolution, not the time resolution.
>

ahh...that's right, gettimeofday resolution can be 1/f_proc_clk, which
will certainly be finer than 1us for processors clocked at 1mhz or
above. thanks a lot...

>
>  > 2. gettimeofday() can get time in microseconds, but I'm not sure about
>  > the accuracy of the time finer than 10ms. Sometimes gettimeofday( )
>  > can even give me microseconds results rolled backwards in time, which
>  > I suspect could be caused by its accuracy. My question here is "how
>  > accurate is the time from gettimeofday()"
>
>  On many systems gettimeofday uses the TSC, but on many multicore systems
>  the TSC on each core may be out of sync, in which case the cpu you are
>  running on may give a different gettimeofday result than another cpu,
>  which is probably a bad thing for some processes.
>
>

Perhaps X86 processors work like this - using the TSC for
gettimeofday, how about ARM processors? how can i determine how
reliable the results are from gettimeofday for arm?  i.e., whether
they are of microsecond accuracy or otherwise...

Here is an example of gettimeofday results, the time rolls back
sometimes...first timestamp is start time...second timestamp is end
time
# # ./gettimeofday
timestamp (us): 215922277
timestamp (us): 215923120 (diff) 843
# # ./gettimeofday
timestamp (us): 216158623
timestamp (us): 216153181 (diff) -5442
# # ./gettimeofday
timestamp (us): 216430758
timestamp (us): 216423223 (diff) -7535
# # ./gettimeofday
timestamp (us): 216665947
timestamp (us): 216663171 (diff) -2776
# # ./gettimeofday
timestamp (us): 216944243
timestamp (us): 216943023 (diff) -1220

>  > 3. If I want to increase the time resolution to 1ms, I can possibly
>  > change HZ=1000, but if I want 1usec resolution, how can I do that? It
>  > would be too busy for the processor to handle so frequent timer
>  > interrupts if I just increase HZ=1000000.
>
>  I don't think that would work well.
>
>  --
>  Len Sorensen
>
