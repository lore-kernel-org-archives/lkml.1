Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbYIJTZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbYIJTZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYIJTZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:25:10 -0400
Received: from gw.goop.org ([64.81.55.164]:54448 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbYIJTZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:25:09 -0400
Message-ID: <48C81F12.9040208@goop.org>
Date: Wed, 10 Sep 2008 12:25:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Rambaldi <rambaldi@xs4all.nl>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.27-rc6 xen soft lockup
References: <48C7BB39.6090700@xs4all.nl> <48C7FB83.8080904@goop.org> <48C81537.8080409@xs4all.nl>
In-Reply-To: <48C81537.8080409@xs4all.nl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rambaldi wrote:
> The machine has two Intel(R) Xeon(R) E5420's so that gives a total of
> 8 cpu's
> During the time of the lockup the cpu load, as measured with cacti,
> was about 4%
> with a increase to 15% at the time the BUG was triggered. So I would
> say mostly idle
> but not very idle.

So that's the cpu load within the domain?  How about the overall system
load?  What other domains are running?

>
> > Did anything fail or misbehave?
> No nothing failed or misbehaved (as far as I could tell)
>
> With dynticks I guess you mean: CONFIG_NO_HZ ; this option is not set.

(In general its a good idea to set it for virtual machines, to avoid
spuriously scheduling vcpus.)

> I have attached my .config. I have also attached the output of
> (date ; cat /proc/interrupts ; sleep 10 ; date ;  cat /proc/interrupts
> )> /tmp/interrupts
> to give an impression about the number of interrupts after 11:30 hours
> of uptime.

Well, there were 1001 interrupts on cpu 1 in that interval, which shows
that the timer interrupts are going at full rate on the idle cpu.

I'm a bit confused.  I'm not sure what would trigger a lockup at that
point, unless it really stopped taking interrupts for a while. 
Unfortunately the RIP and backtrace are not particularly helpful.  I'm
assuming the message is spurious, and indicates some other kind of
timekeeping bug.

> Any other info that you need?

Full dmesg output, for completeness.

    J
