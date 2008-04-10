Return-Path: <linux-kernel-owner+w=401wt.eu-S1759762AbYDJPEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759762AbYDJPEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbYDJPEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:04:25 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:39100 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918AbYDJPEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:04:25 -0400
Date: Thu, 10 Apr 2008 11:04:24 -0400
To: Jack Harvard <jack.harvard@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: gettimeofday() resolution in Linux?
Message-ID: <20080410150424.GD2160@csclub.uwaterloo.ca>
References: <a72f6a3c0804100740s687beacbh80653107f4a7b702@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a72f6a3c0804100740s687beacbh80653107f4a7b702@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 03:40:59PM +0100, Jack Harvard wrote:
> I would like to ask a few questions about how Linux keeps time.
> 
> As far as I understand,
> 1. Linux's time resolution is 10ms, as defined by HZ=100.

The timer resolution, not the time resolution.

> 2. gettimeofday() can get time in microseconds, but I'm not sure about
> the accuracy of the time finer than 10ms. Sometimes gettimeofday( )
> can even give me microseconds results rolled backwards in time, which
> I suspect could be caused by its accuracy. My question here is "how
> accurate is the time from gettimeofday()"

On many systems gettimeofday uses the TSC, but on many multicore systems
the TSC on each core may be out of sync, in which case the cpu you are
running on may give a different gettimeofday result than another cpu,
which is probably a bad thing for some processes.

> 3. If I want to increase the time resolution to 1ms, I can possibly
> change HZ=1000, but if I want 1usec resolution, how can I do that? It
> would be too busy for the processor to handle so frequent timer
> interrupts if I just increase HZ=1000000.

I don't think that would work well.

-- 
Len Sorensen
