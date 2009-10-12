Return-Path: <linux-kernel-owner+w=401wt.eu-S932410AbZJLOtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410AbZJLOtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932385AbZJLOtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:49:12 -0400
Received: from mx03.syneticon.net ([78.111.66.105]:38098 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354AbZJLOtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:49:11 -0400
Message-ID: <4AD341B2.6000704@wpkg.org>
Date: Mon, 12 Oct 2009 16:48:18 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20091009)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: pernegger@gmail.com, arjan@infradead.org
Subject: Re: *Really* bad I/O latency with md raid5+dm-crypt+lvm
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Summary: I was hoping to use a layered storage setup, namely lvm on
> dm-crypt on md raid5 for a new box I'm setting up, but that isn't
> looking so good since a single heavyish writer will monopolise any and
> all I/O on the "device". F. ex. while cp'ing a few GB of data from an
> external disk to the array it takes ~10sec to run ls and ~2min to
> start aptitude. Clueless attempts at a diagnosis below.

Did you try running strace to see where ls pauses?

Did you try running latencytop (and generally, top/htop while doing your 
tests)?


(...)

> Anyway, as soon as I copy something to the array or create a larger
> (upwards of a few hundred MiB) tar archive the box becomes utterly
> unresponsive until that job is finished. Even on the local console the
> completion time for a simple ls or cat is of the order of tens of
> seconds, just forget about launching emacs.
> Now I know that people have been ranting about desktop responsiveness
> for a while but that was very much an abstract thing for me until now.

I think the above (big latency when doing some bigger IO) is a general 
Linux problem.

I see similar behaviour on quite powerful hardware, i.e. Core i7, 8 GB 
RAM, 2x HDD in a software RAID-1 array (no dm-crypt), when tarring 
something big, or writing dd if=/dev/zero of=/home/me/bigfile - doing ls 
in another terminal or just starting top can take up to a minute.

Quite interestingly, background RAID synchronization have almost no 
effect on latency.

(...)


> According to openssl speed aes-256-cbc the CPUs encryption speed is
> ~113 MiB/s (single core, est. for 512b blocks). Obviously the array is
> much faster than that. I can't find the benchmarks ATM but the numbers
> seemed plausible for 70 MiB/s (optimistic est. for sequential access)
> disks at the time.

You can find some dm-crypt benchmarks i.e. here:

http://blog.wpkg.org/2009/04/23/cipher-benchmark-for-dm-crypt-luks/

Obviously, they will not match your hardware.

Also note that dm-crypt is not "SMP-ready", so whatever hardware you 
have, it will only use once CPU - this may seriously limit the 
performance, depending on your usage and hardware.


-- 
Tomasz Chmielewski


