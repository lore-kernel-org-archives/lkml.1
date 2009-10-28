Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbZJ1TYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbZJ1TYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 15:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbZJ1TYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 15:24:53 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:44057 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbZJ1TYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 15:24:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=o6kuA+921JTARW8CDlyJO7iYqDw4mMur5Oe0zfdZZl0oCJ47N2MAkr6yIqvv6emAx6
         E5V08GSFIGkinUE81IkuMpsGApiTkWVKCgG3pWshRBXi/vxNpvf7QlxykU6j2Kukwrfb
         N5D/07Zv6cB56gPF2FS1NmH0vEK9C7xpOnKUk=
MIME-Version: 1.0
Date: Wed, 28 Oct 2009 14:24:53 -0500
Message-ID: <e86b7d350910281224i7e91a1ecp9f3d15d9c36f19cb@mail.gmail.com>
Subject: Hyperthreading on 4 core CPU DECREASES performance???
From: Igor Chudov <ichudov@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At work, we have some users who run a multithreaded app, and they need
 every single bit of performance we can squeeze from computers
(financial).

We are looking into whether we can obtain additional speed performance
 from using Intel hyperthreading, as opposed to disabling
hyperthreading.

If we are able to get benefits from hyperthreading, it will be a huge
argument towards converting certain high end users desktops to Linux
from Windows XP.

I wrote a test perl script, that starts several tasks in parallel. All
these tasks perform a certain amount of calculations and exit. The
test completes when all of them exit.

The results were actually a disappointment, if the number of tasks was
equal to the number of physical cores. For the test with four parallel
subprocesses, on four CPUs, It takes longer to run it with HT than
without HT.

I think that I understand why.

What I found is that not all of these parallel tasks finish at the
same time. This happens because often times, two tasks are assigned to
two logical CPUs that share the same core, and some tasks are assigned
 to only one core, whereas some cores are idling.

I cannot believe that I am the only guy with this problem, and hope
that the Linux community has found a solution. For example, perhaps
they can assign higher priority to some logical CPUs (say, to 0, 2, 4,
6) and lower priority to others. This way the higher priority ones
would be filled with tunning tasks, before fake "shadow processors"
1,3,5,7 are utilized.

I would like to know if perhaps there is a boot option to this effect.

This is Ubuntu Hardy, 2.6.24 kernel. I tried the same with 2.6.31,
with the same effect.

This article from Intel:

http://software.intel.com/sites/oss/pdfs/mclinux.pdf

It talks about intelligent handling of multiple cores as a done deal,
but in my experience that did not actually occur.

I would like to know how can I make the scheduler to prefer to spread
the tasks across physical cores as opposed to bundling two on one core
and leaving some cores idle.
