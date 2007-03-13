Return-Path: <linux-kernel-owner+w=401wt.eu-S933069AbXCMUCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069AbXCMUCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933082AbXCMUCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:02:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933069AbXCMUCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:02:16 -0400
Message-ID: <45F7033B.2030204@redhat.com>
Date: Tue, 13 Mar 2007 16:02:03 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Johannes Bauer <JohannesBauer@gmx.de>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       schwab@suse.de
Subject: Re: x86_64 system lockup from userspace using setitimer()
References: <45F6F3A6.9060405@gmx.de>
In-Reply-To: <45F6F3A6.9060405@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Bauer wrote:
> Dear Community,
> 
> I think I've encountered a bug with the Linux kernel which results in a
> complete system lockup and which can be started without root priviliges.
> It's reproducible with 2.6.20.1 and 2.6.20.2 and only x64_64 seems
> affected.
> 
> Here's the code which triggers the bug (originally found by me using an
> only partly initialized "struct itimerval" structure - hence the strange
> values in it_interval):
> 
> -----8<-----8<-----8<-----8<-----8<-----8<-----8<-----8<-----8<-----
> #include <stdio.h>
> #include <sys/time.h>
> #include <unistd.h>
> 
> int main(int argc, char **argv) {
>     struct itimerval tim = {
>         .it_interval = {
>             .tv_sec = 140735669863712,
>             .tv_usec = 4199521
>         },
>         .it_value = {
>             .tv_sec = 0,
>             .tv_usec =  100000
>         }
>     };
>     setitimer(ITIMER_REAL, &tim, NULL);
>     while (1) sleep(1);
>     return 0;
> }
> -----8<-----8<-----8<-----8<-----8<-----8<-----8<-----8<-----8<-----
> 
> Compiled with gcc 4.1.1 with "gcc -O2 -Wall -o crash crash.c".
> 
> The sourcecode can be found at
> http://www.johannes-bauer.com/crash/crash.c and my kernel configuration
> is at http://www.johannes-bauer.com/crash/config
> 
> Any further questions: feel free to ask. Please CC me for any posts in
> this thread.

Could this be fixed by:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8bfd9a7a229b5f3d3eda5d7d45c2eebec5b4ba16

[PATCH] hrtimers: prevent possible itimer DoS

?

