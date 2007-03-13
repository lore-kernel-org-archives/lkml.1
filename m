Return-Path: <linux-kernel-owner+w=401wt.eu-S932566AbXCMSzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566AbXCMSzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 14:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932583AbXCMSzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 14:55:36 -0400
Received: from mail.gmx.net ([213.165.64.20]:33538 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932566AbXCMSzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 14:55:36 -0400
X-Authenticated: #349907
X-Provags-ID: V01U2FsdGVkX1+aDW8MPVSacUGcN/vUWAPNaMtec6rOaHRIXi40pj
	dpKZBsSBP73ild
Message-ID: <45F6F3A6.9060405@gmx.de>
Date: Tue, 13 Mar 2007 19:55:34 +0100
From: Johannes Bauer <JohannesBauer@gmx.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070313)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: x86_64 system lockup from userspace using setitimer()
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Community,

I think I've encountered a bug with the Linux kernel which results in a 
complete system lockup and which can be started without root priviliges. 
It's reproducible with 2.6.20.1 and 2.6.20.2 and only x64_64 seems affected.

Here's the code which triggers the bug (originally found by me using an 
only partly initialized "struct itimerval" structure - hence the strange 
values in it_interval):

-----8<-----8<-----8<-----8<-----8<-----8<-----8<-----8<-----8<-----
#include <stdio.h>
#include <sys/time.h>
#include <unistd.h>

int main(int argc, char **argv) {
     struct itimerval tim = {
         .it_interval = {
             .tv_sec = 140735669863712,
             .tv_usec = 4199521
         },
         .it_value = {
             .tv_sec = 0,
             .tv_usec =  100000
         }
     };
     setitimer(ITIMER_REAL, &tim, NULL);
     while (1) sleep(1);
     return 0;
}
-----8<-----8<-----8<-----8<-----8<-----8<-----8<-----8<-----8<-----

Compiled with gcc 4.1.1 with "gcc -O2 -Wall -o crash crash.c".

The sourcecode can be found at 
http://www.johannes-bauer.com/crash/crash.c and my kernel configuration 
is at http://www.johannes-bauer.com/crash/config

Any further questions: feel free to ask. Please CC me for any posts in 
this thread.

Greetings,
Johannes

-- 
"A PC without Windows is like a chocolate cake without mustard."

Johannes Bauer
91054 Erlangen
