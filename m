Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbYBIIzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbYBIIzF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 03:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYBIIyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 03:54:52 -0500
Received: from 1wt.eu ([62.212.114.60]:1776 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbYBIIyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 03:54:51 -0500
Date: Sat, 9 Feb 2008 09:03:20 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mike Galbraith <efault@gmx.de>
Cc: Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Scheduler(?) regression from 2.6.22 to 2.6.24 for short-lived threads
Message-ID: <20080209080319.GO8953@1wt.eu>
References: <20080209000456.GA21021@lixom.net> <1202543920.9578.3.camel@homer.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202543920.9578.3.camel@homer.simson.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Sat, Feb 09, 2008 at 08:58:39AM +0100, Mike Galbraith wrote:
> 
> On Fri, 2008-02-08 at 18:04 -0600, Olof Johansson wrote:
> > Hi,
> > 
> > I ended up with a customer benchmark in my lap this week that doesn't
> > do well on recent kernels. :(
> > 
> > After cutting it down to a simple testcase/microbenchmark, it seems like
> > recent kernels don't do as well with short-lived threads competing
> > with the thread it's cloned off of. The CFS scheduler changes come to
> > mind, but I suppose it could be caused by something else as well.
> > 
> > The pared-down testcase is included below. Reported runtime for the
> > testcase has increased almost 3x between 2.6.22 and 2.6.24:
> > 
> > 2.6.22: 3332 ms
> > 2.6.23: 4397 ms
> > 2.6.24: 8953 ms
> > 2.6.24-git19: 8986 ms
> 
> My 3GHz P4 shows disjointed results.
> 
> 2.6.22.17-smp
> time 798 ms
> time 780 ms
> time 702 ms
> 
> 2.6.22.17-cfs-v24.1-smp
> time 562 ms
> time 551 ms
> time 551 ms
> 
> 2.6.23.15-smp
> time 254 ms
> time 254 ms
> time 293 ms
> 
> 2.6.23.15-cfs-v24-smp
> time 764 ms
> time 791 ms
> time 780 ms
> 
> 2.6.24.1-smp
> time 815 ms
> time 820 ms
> time 771 ms

How many CPUs do you have ? It's impressive to see such important variations.
I would guess from the numbers that you sometimes have 1 or 2 CPUs doing
nothing. I've already observed strange CPU usage patterns while building
kernels (bound to 50% usage on a dual-athlon), but I can't say for sure
that it was only on 2.6, so it may be related to make dependencies instead
(at least it's what I've been suspecting till now).

> 2.6.25-smp (git today)
> time 29 ms
> time 61 ms
> time 72 ms

These ones look rather strange. What type of workload is it ? Can you
publish the program for others to test it ?

Regards,
Willy

