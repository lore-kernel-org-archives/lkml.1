Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbZDFFBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbZDFFBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 01:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbZDFFBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 01:01:31 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:24030 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbZDFFBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 01:01:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=kL4GfO2M1jtBGlAKxtUY/3OgvCjS6OiQhcX+mZeQpA78Es6ID3GjSwyajtqHQIg5dq
         ztR9lP/LjLEiw+d98gy0zV9IHgkLyxOXYsTdcCBAh3jRZOcGBKpWqdnXfpGikCZH0t/i
         bZOSKo01NmV5tymZT0IxlLxUwpM7QOjQd9WL4=
MIME-Version: 1.0
Date: Mon, 6 Apr 2009 10:31:28 +0530
Message-ID: <f24b07420904052201o45c9e814q597f766749a60005@mail.gmail.com>
Subject: SCHED_RR and kernel thread
From: Bhavesh Parekh <bhaveshparekh1@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
We have a mulit-threaded application which run on linux kernel 2.6.23.
This application uses the real time thread, using the SCHED_RR policy.
We can't use the SCHED_NORMAL as the heuristic use to compute the
Dynamic priority is not suitted for our application.

As the application is CPU bound if we use the SCHED_RR in the
application then it will stale the system after some time. So we
decided to switch the Kernel thread to the SCHED_RR too.( higher
priority then application).

Now the important question here is that this kernel thread are not
design to work in SCHED_RR policy. What I mean is that  a particular
kernel thread(eg:ksoftirqd)  might take more time to finish it work if
the policy of the thread is change.

Further it is also possible that a particular thread wake-up(eg:
pdflush) and take around 20-50 ms to execution time. So I need to know
is there any test-case to test the time taken by a  particular thread
to finish it work.

-Thanks
Bhavesh
