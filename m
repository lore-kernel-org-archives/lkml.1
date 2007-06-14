Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbXFNVhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbXFNVhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 17:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755270AbXFNVhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 17:37:45 -0400
Received: from comtv.ru ([217.10.32.17]:64866 "EHLO comtv.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884AbXFNVho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 17:37:44 -0400
X-UCL: actv
Date: Fri, 15 Jun 2007 01:37:36 +0400 (MSD)
From: malc <av1474@comtv.ru>
X-X-Sender: malc@linmac.oyster.ru
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] sched: accurate user accounting
In-Reply-To: <20070614211828.GA21243@elte.hu>
Message-ID: <Pine.LNX.4.64.0706150129430.3526@linmac.oyster.ru>
References: <200703251159.03616.kernel@kolivas.org>
 <Pine.LNX.4.64.0703252107590.31900@linmac.oyster.ru> <200703260901.54943.kernel@kolivas.org>
 <200703260957.34798.kernel@kolivas.org> <Pine.LNX.4.64.0703261439270.2621@linmac.oyster.ru>
 <20070328113743.GA5615@elte.hu> <Pine.LNX.4.64.0706142149020.2991@linmac.oyster.ru>
 <20070614204253.GA14076@elte.hu> <Pine.LNX.4.64.0706150052190.3404@linmac.oyster.ru>
 <20070614211828.GA21243@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007, Ingo Molnar wrote:

>
> * malc <av1474@comtv.ru> wrote:
>
>>> the alternating balancing might be due to an uneven number of tasks
>>> perhaps? If you have 3 tasks on 2 cores then there's no other
>>> solution to achieve even performance of each task but to rotate them
>>> amongst the cores.
>>
>> One task, one thread. I have also tried to watch fairly demanding
>> video (Elephants Dream in 1920x1080/MPEG4) with mplayer, and CFS moves
>> the only task between cores almost every second.
>
> hm, mplayer is not running alone when it does video playback: Xorg is
> also pretty active. Furthermore, the task you are using to monitor
> mplayer counts too. The Core2Duo has a shared L2 cache between cores, so
> it is pretty cheap to move tasks between the cores.
>

Well just to be sure i reran the test with `-vo null' (and fwiw i tried
few completely different output drivers) the behavior is the same. I'm
not running Core2Duo but X2, but guess that does not really matter here.

As for the task that monitors, i've written it myself (there are two
monitoring methods, one(the accurate) does not depend on contets of
`/proc/stat' at all), so it can be cheaply (for me) changed in any
way one wants. Sources are available at the same place where screenshot
was found.

>>> well, precise/finegrained accounting patches have been available for
>>> years, the thing with CFS is that there we get them 'for free',
>>> because CFS needs those metrics for its own logic. That's why this
>>> information is much closer to reality now. But note: right now what
>>> is affected by the changes in the CFS patches is /proc/PID/stat
>>> (i.e. the per-task information that 'top' and 'ps' displays, _not_
>>> /proc/stat) - but more accurate /proc/stat could certainly come
>>> later on too.
>>
>> Aha. I see, it's just that integral load for hog is vastly improved
>> compared to vanilla 2.6.21 [...]
>
> hm, which ones are improved? Could this be due to some other property of
> CFS? If your app relies on /proc/stat then there's no extra precision in
> those cpustat values yet.

This is what it looked like before: 
http://www.boblycat.org/~malc/apc/load-x2-hog.png

Now integral load matches the one obtained via the "accurate" method.
However the report for individual cores are of by around 20% percent.

Though i'm not quite sure what you mean by "which ones are improved".

> i've Cc:-ed Balbir Singh and Dmitry Adamushko who are the main authors
> of the current precise accounting code in CFS. Maybe i missed some
> detail :-)

Oh, the famous "With enough eyeballs, all bugs are shallow." in action.

-- 
vale
