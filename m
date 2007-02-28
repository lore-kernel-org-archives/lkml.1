Return-Path: <linux-kernel-owner+w=401wt.eu-S1751110AbXB1C3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110AbXB1C3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 21:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbXB1C3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 21:29:38 -0500
Received: from mail.tmr.com ([64.65.253.246]:53342 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbXB1C3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 21:29:37 -0500
Message-ID: <45E4E953.7060501@tmr.com>
Date: Tue, 27 Feb 2007 21:30:43 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: kalium@gmx.de
CC: linux-kernel@vger.kernel.org
Subject: Re: latencies due to disk writes
References: <20070226015439.97500@gmx.net>
In-Reply-To: <20070226015439.97500@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kalium@gmx.de wrote:
> Hello!
> 
> I'm experiencing extreme lags during disk writes. I have read somewhere (didn't save the URI, sigh) that this is actually related to bad (non-existing) write io priorities (CFQ only manages file reads).
> 
> I could imagine two quick, easy and probably quite effective ways to prevent such lags:
> 
> 1.) don't flush buffers to disk at once more than necessary.
> 
Actually, in many cases this is just what you do want, to avoid filling 
memory with buffered writes and then flushing them on time or memory runout.

Investigate the /proc/sys/vm/dirty_* values.

> 2.) relate CPU niceness to max write buffer fill level (ie. the point where it gets forced to be flushed to disk -- a conservative estimate would be much better than nothing): (100-5*nicelevel)%, ie. writes for processes having nice level 19 are blocked/delayed until the write buffer is below 5%. That way, the accounting is done at a higher and probably easier to access level.
> 
> Maybe I'm just talking nonsense, but nonetheless, here are my 2 cents.
> 
> Best regards,
> Mark
> 
> p.s. please CC me as I'm not subscribed to this list.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
