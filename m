Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547AbYGaKxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbYGaKxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbYGaKxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:53:36 -0400
Received: from [218.94.130.82] ([218.94.130.82]:1142 "HELO mail.archermind.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1750752AbYGaKxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:53:36 -0400
X-Greylist: delayed 916 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jul 2008 06:53:35 EDT
Message-ID: <4891960E.2000605@archermind.com>
Date: Thu, 31 Jul 2008 18:38:06 +0800
From: richard <yang.lu@archermind.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20071018)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: kernel  performance issue
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jul 2008 10:38:27.0363 (UTC) FILETIME=[91017730:01C8F2F9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

I have a question about the kernel performance of kernel 2.6.24. I use
"time"
to account the time cost of "date" execution, and find that the "real time"
of kernel 2.6.24 is always bigger than kernel 2.6.21 on my arm board.
For my
understanding, the time cost of 2.6.24 shouldn't be bigger than 2.6.21,
because
it is a upgrade of 2.6.21 and the its performance should be better than
2.6.21,
if I am wrong please let me know.


[root@Linux /root]#cat ./date-loop.sh
#! /bin/sh
loop=1
while [ $loop -le 50 ]
do
         date +%s
         loop=$(($loop+1))
done


Time cost in kernel 2.6.24:
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.48s
user    0m 0.06s
sys     0m 0.43s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.48s
user    0m 0.07s
sys     0m 0.42s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.48s
user    0m 0.09s
sys     0m 0.40s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.48s
user    0m 0.07s
sys     0m 0.41s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.48s
user    0m 0.07s
sys     0m 0.42s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.48s
user    0m 0.09s
sys     0m 0.40s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.48s
user    0m 0.06s
sys     0m 0.43s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.48s
user    0m 0.08s
sys     0m 0.41s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.48s
user    0m 0.09s
sys     0m 0.40s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.48s
user    0m 0.10s
sys     0m 0.39s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.48s
user    0m 0.05s
sys     0m 0.44s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.48s
user    0m 0.05s
sys     0m 0.44s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.48s
user    0m 0.09s
sys     0m 0.40s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.48s
user    0m 0.07s
sys     0m 0.42s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.48s
user    0m 0.07s
sys     0m 0.42s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.48s
user    0m 0.09s
sys     0m 0.40s
[root@Linux /root]#

Time cost in kernel 2.6.21:
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.45s
user    0m 0.08s
sys     0m 0.38s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.45s
user    0m 0.07s
sys     0m 0.39s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.45s
user    0m 0.09s
sys     0m 0.37s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.45s
user    0m 0.09s
sys     0m 0.37s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.45s
user    0m 0.08s
sys     0m 0.38s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.45s
user    0m 0.06s
sys     0m 0.40s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.45s
user    0m 0.09s
sys     0m 0.37s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.45s
user    0m 0.10s
sys     0m 0.36s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.45s
user    0m 0.04s
sys     0m 0.42s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.45s
user    0m 0.09s
sys     0m 0.37s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.45s
user    0m 0.07s
sys     0m 0.39s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.45s
user    0m 0.08s
sys     0m 0.38s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.45s
user    0m 0.10s
sys     0m 0.36s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.45s
user    0m 0.09s
sys     0m 0.37s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.45s
user    0m 0.09s
sys     0m 0.37s
[root@Linux /root]#time ./date-loop.sh > /dev/null
real    0m 0.45s
user    0m 0.07s
sys     0m 0.39s
[root@Linux /root]#

-- 






Best Regards,
Yang Lu

