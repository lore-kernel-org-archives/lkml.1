Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbYL3Tfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbYL3Tfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 14:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbYL3Tfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 14:35:47 -0500
Received: from mx01.mailboxcop.com ([206.125.223.71]:47644 "EHLO
	mx01.mailboxcop.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbYL3Tfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 14:35:46 -0500
Message-ID: <495A788B.3010001@jaysonking.com>
Date: Tue, 30 Dec 2008 13:37:47 -0600
From: Jayson King <dev@jaysonking.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: problem with "sched: revert back to per-rq vruntime"?
References: <495948E0.8040502@jaysonking.com>
In-Reply-To: <495948E0.8040502@jaysonking.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Canit-CHI2: 0.50
X-Bayes-Prob: 0.9891 (Score 4, tokens from: @@RPTN, outgoing)
X-Spam-Score: 4.10 (****) [Hold at 5.20] RDNS_NONE,2(1.2),6947(-1.2),Bayes(0.9891,4.0)
X-CanItPRO-Stream: outgoing (inherits from default)
X-Canit-Stats-ID: 333068985 - dd8405089393
X-Antispam-Training-Forget: http://mailboxcop.com/canit/b.php?i=333068985&m=dd8405089393&c=f
X-Antispam-Training-Nonspam: http://mailboxcop.com/canit/b.php?i=333068985&m=dd8405089393&c=n
X-Antispam-Training-Spam: http://mailboxcop.com/canit/b.php?i=333068985&m=dd8405089393&c=s
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's some times using bash, for example. Let me know if there are some 
other tests I can do.

It shows on vanilla 2.6.28, a huge increase in latency (about 37X to 
39X) starting bash -i when the CPU is loaded with 100% nice tasks, 
relative to idle CPU. But after reverting 
f9c0b0950d5fd8c8c5af39bc061f27ea8fddcac3 the latency increase is not as 
great (about 2X).

# running bash -i on vanilla 2.6.28,
# with idle CPU
[jayson@atlas tmp]$ time bash -i -c 'exit'
exit

real    0m0.020s
user    0m0.008s
sys     0m0.014s
[jayson@atlas tmp]$ time bash -i -c 'exit'
exit

real    0m0.020s
user    0m0.014s
sys     0m0.005s
[jayson@atlas tmp]$ time bash -i -c 'exit'
exit

real    0m0.020s
user    0m0.008s
sys     0m0.009s



# running bash -i on vanilla 2.6.28,
# with 100% nice CPU usage
[jayson@atlas tmp]$ time bash -i -c 'exit'
exit

real    0m0.753s
user    0m0.011s
sys     0m0.011s
[jayson@atlas tmp]$ time bash -i -c 'exit'
exit

real    0m0.752s
user    0m0.012s
sys     0m0.012s
[jayson@atlas tmp]$ time bash -i -c 'exit'
exit

real    0m0.786s
user    0m0.010s
sys     0m0.008s



# running 2.6.28 reverted f9c0b0950d5fd8c8c5af39bc061f27ea8fddcac3,
# with idle CPU
[jayson@atlas tmp]$ time bash -i -c 'exit'
exit

real    0m0.021s
user    0m0.012s
sys     0m0.007s
[jayson@atlas tmp]$ time bash -i -c 'exit'
exit

real    0m0.020s
user    0m0.012s
sys     0m0.011s
[jayson@atlas tmp]$ time bash -i -c 'exit'
exit

real    0m0.020s
user    0m0.011s
sys     0m0.012s



# running 2.6.28 reverted f9c0b0950d5fd8c8c5af39bc061f27ea8fddcac3,
# with 100% nice CPU usage
[jayson@atlas tmp]$ time bash -i -c 'exit'
exit

real    0m0.043s
user    0m0.010s
sys     0m0.009s
[jayson@atlas tmp]$ time bash -i -c 'exit'
exit

real    0m0.046s
user    0m0.011s
sys     0m0.007s
[jayson@atlas tmp]$ time bash -i -c 'exit'
exit

real    0m0.047s
user    0m0.011s
sys     0m0.006s




Jayson

