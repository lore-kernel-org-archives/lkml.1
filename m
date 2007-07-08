Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbXGHSTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbXGHSTf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 14:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757226AbXGHSTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 14:19:24 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:5047 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143AbXGHSTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 14:19:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=PqS7fGR54IdmdTr62A3WUwx/9CuPLh698FjPPxxPbCEtSNjvAmLkhk3OlMHVx/y+eP8zSQ7P0xzaOLJzoh7WRxyUydpOfI4hnWSMjFR2xkykix9ekqGqqVAOZyi7fWPGDbe1GC8hMC7hRrp4H4Jkl0c/5Nl3C6g+d0EVu3LF9Go=
Message-ID: <c43b2e150707081119h36d2fcadva5fa4ea00e68599a@mail.gmail.com>
Date: Sun, 8 Jul 2007 20:19:21 +0200
From: wixor <wixorpeek@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: getrusage time measurements variations
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,
I've been doing some getrusage tests using this:

#include <stdio.h>
#include <unistd.h>
#include <sys/resource.h>

int main(void)
{
    unsigned int i;
    struct rusage ru;
    for(i=1;i;i++) asm volatile("nop");
    getrusage(RUSAGE_SELF, &ru);
    printf("%dsec %dusec\n",ru.ru_utime.tv_sec,ru.ru_utime.tv_usec);
    return 0;
}

What is good is that results do not seem to depend on other thread
activity nor disk i/o. However, each time I run this program, result
varies (from 4.039 sec to 4.062 sec). Does the actual execution time
change each time? User time should not contain .so library loading
time, nor memory allocation time (kernel part) nor anything like this.
Does getrusage measure time so accurately (1usec precision), even if
HZ is set to, let's say, 100?

But that's not very bad... Problems start, when I run this with heavy
network i/o load. I'm using ne1000 network adapter (on isa bus...
well, that's very old stuff), which seem to generate interrupt on each
packet it receives - top reports very high "hi" values, up to 20%.
Results from getrusage change to 5.2 sec. Is this variation the same
one as above, but in greater scale? Can this be eliminated?

My problem is, that I'd like to measure user time of process with
1msec resolution, but what is most important, I want the result to be
the same each time I run program. Can it be done with standard linux
kernels, or should I try some "real-time" versions?

Thanks for responses, and please CC me, I'm not in the list.
--
wixor
