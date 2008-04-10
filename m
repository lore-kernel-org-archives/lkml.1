Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbYDJPtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbYDJPtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756704AbYDJPtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:49:41 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:44052 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140AbYDJPtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:49:40 -0400
Message-ID: <47FE36EE.7020307@nortel.com>
Date: Thu, 10 Apr 2008 09:49:02 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jack Harvard <jack.harvard@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: gettimeofday() resolution in Linux?
References: <a72f6a3c0804100740s687beacbh80653107f4a7b702@mail.gmail.com>
In-Reply-To: <a72f6a3c0804100740s687beacbh80653107f4a7b702@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Apr 2008 15:49:05.0527 (UTC) FILETIME=[67F39870:01C89B22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Harvard wrote:

> 1. Linux's time resolution is 10ms, as defined by HZ=100.

As others have said, this is not the time resolution, but the tick time. 
  In other words, this is the smallest amount of sleep that you can 
normally ask for, but you can obtain a timestamp with much more accuracy.

> 2. gettimeofday() can get time in microseconds, but I'm not sure about
> the accuracy of the time finer than 10ms.

Barring bugs, it should be accurate to microseconds.

> Sometimes gettimeofday( )
> can even give me microseconds results rolled backwards in time, which
> I suspect could be caused by its accuracy. My question here is "how
> accurate is the time from gettimeofday()"

This is due to bugs.  There was a recent thread called "gettimeofday() 
jumping into the future" which just fixed a problem in this area, and 
there have been other such issues in the past.  In particular, I think 
AMD multicore systems don't sync the TSC on the cores.

Usually it's possible to force the system to use something other than 
the TSC for timestamping.  This is generally somewhat slower but less 
likely to be buggy.

Chris

