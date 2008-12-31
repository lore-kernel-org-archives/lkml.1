Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbYLaWZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbYLaWZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 17:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756636AbYLaWZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 17:25:05 -0500
Received: from mx02.mailboxcop.com ([206.125.223.72]:35494 "EHLO
	mx02.mailboxcop.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633AbYLaWZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 17:25:03 -0500
Message-ID: <495BF1BD.1070408@jaysonking.com>
Date: Wed, 31 Dec 2008 16:27:09 -0600
From: Jayson King <dev@jaysonking.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: arjan@linux.intel.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org,
       a.p.zijlstra@chello.nl, shaggy@linux.vnet.ibm.com, rjw@sisk.pl,
       fabio.comolli@gmail.com
Subject: Re: large intermittent latency spike 2.6.28 (and 2.6.27.10), bisect
 commit ca7e716c7833aeaeb8fedd6d004c5f5d5e14d325 -> Revert "sched_clock: prevent
 scd->clock from moving backwards"
References: <495A96FF.1000200@jaysonking.com>
In-Reply-To: <495A96FF.1000200@jaysonking.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Canit-CHI2: 0.43
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, outgoing)
X-Spam-Score: 0.10 () [Hold at 5.20] RDNS_NONE,2(1.2),6947(-1.2)
X-CanItPRO-Stream: outgoing (inherits from default)
X-Canit-Stats-ID: 333514788 - 3cd2a8df4258
X-Antispam-Training-Forget: http://mailboxcop.com/canit/b.php?i=333514788&m=3cd2a8df4258&c=f
X-Antispam-Training-Nonspam: http://mailboxcop.com/canit/b.php?i=333514788&m=3cd2a8df4258&c=n
X-Antispam-Training-Spam: http://mailboxcop.com/canit/b.php?i=333514788&m=3cd2a8df4258&c=s
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
 > Jayson King <dev@jaysonking.com> wrote:
 >> Please disregard this. ...
 >
 > can you run latencytop to see if it can pinpoint a cause of latency?

Like I said in my other reply I was running the wrong kernel when I 
wrote that (oops)... So now I am still sure it is ca7e716.

Ingo's patch makes the same change that reverting ca7e716 does here:

-	max_clock = scd->tick_gtod + TICK_NSEC;
+	max_clock = wrap_max(scd->clock, scd->tick_gtod + TICK_NSEC);


And with that change (I'm using Ingo's patch now) I can't trigger the 
hang anymore. And before, I could reliably trigger it in a short time.

Jayson

