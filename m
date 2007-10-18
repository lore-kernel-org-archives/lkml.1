Return-Path: <linux-kernel-owner+w=401wt.eu-S1763321AbXJRA31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763321AbXJRA31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762742AbXJRA3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:29:00 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:50570 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762658AbXJRA26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:28:58 -0400
Date: Wed, 17 Oct 2007 18:27:56 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Problem:  CPU sleep when calling a function in another object for
 the first time.
In-reply-to: <fa.tipEk8FmQyQBLuKMUWoW6rAg1Yc@ifi.uio.no>
To: John Marconi <john.marconi@utstar.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <4716A88C.2050204@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.tipEk8FmQyQBLuKMUWoW6rAg1Yc@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Marconi wrote:
> Hello,
> 
> I have been seeing a problem in which one of my CPUs goes to sleep for
> 40ms in the middle of running a user-space program.  The problem occurs
> when I have a function in object file X call another function in object
> file Y.  If I add a gettimeofday right before the function call occurs,
> and then also right at the beginning of the called function, I see a
> 40ms delay.  This only occurs on the first call to any function in file
> Y.  Once a function in file Y is called, all other calls to functions in
> this file are immediate.
> 
> I have added a kernel profiler to the timer interrupt of this CPU - and
> find that during this 40ms period, the CPU is in r4k_wait - which looks
> like cpu_idle is running.  It almost seems like file Y is being loaded
> into memory to be used.
> 
> The program in question is using pthreads and each thread is on a
> separate CPU.  Each CPU is dedicated to running a single thread and
> nothing else.  The files X and Y are two object files linked into a
> single ELF binary.  The kernel version is 2.6.14 and this is a MIPS
> based processor.
> 
> Does anyone have any ideas why this delay might be occurring?

Binaries get loaded into memory on demand, so it's quite possible that 
that part of the executable hasn't been loaded until something calls a 
function within it.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/
