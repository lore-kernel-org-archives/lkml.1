Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbXFWN5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbXFWN5E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610AbXFWN4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:56:53 -0400
Received: from server145.whmcpanel.net ([69.72.254.178]:50424 "EHLO
	server459.whmcpanel.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbXFWN4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:56:53 -0400
From: Alberto Gonzalez <info@gnebu.es>
To: Paolo Ornati <ornati@fastwebnet.it>
Subject: Re: Question about fair schedulers
Date: Sat, 23 Jun 2007 15:56:36 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200706230007.15622.info@gnebu.es> <200706231001.02497.info@gnebu.es> <20070623152653.05ebac64@localhost>
In-Reply-To: <20070623152653.05ebac64@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706231556.36430.info@gnebu.es>
X-PopBeforeSMTPSenders: info@gnebu.es
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server459.whmcpanel.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - gnebu.es
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 June 2007, Paolo Ornati wrote:
> But the fact is, the "interactivity estimator" is too fragile, and when
> it fails it can do much damage.
>
>
> Fair scheduler instead:
> 	- are robust
> 	- provide consistent behaviour
> 	- provide good interactivity within the bounds of fairness

Yes, this is what I have concluded from this thread. Trying to guess which 
tasks should have higher priority is not the right approach. It's not a CPU 
scheduler's business to decide about priorities.

> > In my very simple test scenario the mainline scheduler
> > did behave much better.
>
> Of course... because of the two competing processes the
> "interactive" (for you) one needs 60%, that is more than it's 50% fair
> share.
>
> The real solution is to use nice levels so the scheduler doesn't have
> to guess what process is more important.

Yes, this seems to be the right approach from all the opinions I've heard.

> And yes, programs/distributions should set good defaults for you... and
> if they don't, just complain to them  :)

I'm sure they'll do once a fair scheduler goes into mainline :)

I guess what I was missing from the beginning is that "fair" means that the 
scheduler will be fair among tasks that have the same priority, but if a task 
has a higher priority, it _will_ get more CPU. So we'll just have to mark 
applications like video players, audio players or games with a high priority, 
others like encoders or compilers with low priority, and leave the rest 
(browsers, word processors, email readers, etc...) as normal priority. This 
way a fair scheduler would be able to give each task right amount of CPU.

That sounds like a good solution to me.

Thanks,
Alberto.
