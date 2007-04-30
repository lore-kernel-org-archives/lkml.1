Return-Path: <linux-kernel-owner+w=401wt.eu-S1946871AbXD3Wx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946871AbXD3Wx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 18:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946874AbXD3Wx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 18:53:58 -0400
Received: from mail14.syd.optusnet.com.au ([211.29.132.195]:56075 "EHLO
	mail14.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946871AbXD3Wxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 18:53:55 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Bill Davidsen <davidsen@tmr.com>, ck@vds.kolivas.org
Subject: Re: [REPORT] 2.6.21 vs. 2.6.21-sd046 vs. 2.6.21-CFSv7
Date: Tue, 1 May 2007 08:51:40 +1000
User-Agent: KMail/1.9.5
Cc: Linux Kernel M/L <linux-kernel@vger.kernel.org>
References: <463643A9.5040009@tmr.com>
In-Reply-To: <463643A9.5040009@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705010851.41375.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 May 2007 05:29, Bill Davidsen wrote:
> System: Intel 6600 Core2duo, 2GB RAM, X nice 0 for all tests, display
> using i945G framebuffer

Bill thanks for testing.
>
> Test: playing a 'toon with mplayer while kernel build -j20 running.

Umm I don't think make -j20 is a realistic load on 2 cores. Not only does it 
raise your load to 20 but your I/O bandwidth will even be struggling. If 
video playback was to be smooth at that size a load it would suggest some 
serious unfairness. I'm not just pushing the fairness barrow here; I mean it 
would need to be really really unfair unless your combined X and video 
playback cpu combined added up to less than 1/20th of your total cpu power 
(which is possible but I kinda doubt it). Do you really use make -j20 to 
build regularly?

> Tuning: not yet, all scheduler parameters were default
>
> Result: base 2.6.21 showed some pauses and after the pause the sound got
> louder for a short time (<500ms). With sd-0.46 the playback had many
> glitches and finally just stopped with the display looping on a small
> number of frames and no sound. The skips were repeatable, the hang was
> only two of five runs, I didn't let them go until the make finished
> (todo list) but killed the mplayer after 10-15 sec. No glitches observed
> with cfsv7, I thought I saw one but repeating with granularity set to
> 500000 and then with no make running convinced me that it's just a
> crappy piece of animation at that point.

I did notice on your followup email that nice +10 of the 20 makes fixed the 
playback which sounds pretty good.

> I ran glxgears, again sd-0.46 had frequent pauses and uneven fps
> reported. Stock 2.6.21 had a visible pause when the frame rate was
> output, otherwise minimal pauses. CFSv7 appeared smooth at about 250 fps.

I assume you mean glxgears when you're running make -j20 again here.

> All tests gave acceptable typing echo, it seems that X is getting enough
> time at that load to echo without major issues.

That's nice; shows stability under load.

> I will be doing tests with server load later this week, have to add disk
> for the database.

Great.

> Hope this initial report is useful, I may be able to update ctxbench
> later today and try that.

Also good.

-- 
-ck
