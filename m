Return-Path: <linux-kernel-owner+w=401wt.eu-S1031584AbXD3T6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031584AbXD3T6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 15:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031585AbXD3T6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 15:58:49 -0400
Received: from pool-72-92-185-191.albyny.east.verizon.net ([72.92.185.191]:50959
	"EHLO posidon.tmr.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031584AbXD3T6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 15:58:47 -0400
Message-ID: <46364A75.9080003@tmr.com>
Date: Mon, 30 Apr 2007 15:58:45 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [REPORT] 2.6.21 vs. 2.6.21-sd046 vs. 2.6.21-CFSv7
References: <463643A9.5040009@tmr.com>
In-Reply-To: <463643A9.5040009@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> System: Intel 6600 Core2duo, 2GB RAM, X nice 0 for all tests, display 
> using i945G framebuffer
> 
> Test: playing a 'toon with mplayer while kernel build -j20 running.
> 
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
> 
> I ran glxgears, again sd-0.46 had frequent pauses and uneven fps 
> reported. Stock 2.6.21 had a visible pause when the frame rate was 
> output, otherwise minimal pauses. CFSv7 appeared smooth at about 250 fps.
> 
> All tests gave acceptable typing echo, it seems that X is getting enough 
> time at that load to echo without major issues.
> 
> I will be doing tests with server load later this week, have to add disk 
> for the database.
> 
> Hope this initial report is useful, I may be able to update ctxbench 
> later today and try that.
> 
Followup: I reran with sd-0.46, setting rr_interval to 40, and then 5 
(default was 16). Neither appeared to give a useful video playback. I 
did try setting the make to nice 10, and that made the playback 
perfectly smooth, as well as response to skip forward and volume change 
happening when the key was pressed instead of eventually.

I also tried raising the nice of X to -10, that made things better on 
display, but I winder if it will let X run ahead of the nice-0 raid threads.

Is this my hardware or is there a really odd behavior here? The sd seems 
to be too fair to cope well with this realistic load, and expecting 
users to nice things is probably morally correct but unrealistic.
