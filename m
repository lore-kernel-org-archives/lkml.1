Return-Path: <linux-kernel-owner+w=401wt.eu-S1759042AbZELMMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbZELMMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 08:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbZELMME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 08:12:04 -0400
Received: from rankki.sonarnerd.net ([83.145.240.118]:15454 "EHLO
	mail.sonarnerd.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbZELMMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 08:12:01 -0400
Date: Tue, 12 May 2009 15:12:00 +0300 (EEST)
From: Jussi Laako <jussi@sonarnerd.net>
To: Peter Zijlstra <peterz@infradead.org>
cc: James Courtier-Dutton <James@superbug.co.uk>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, d.faggioli@sssup.it
Subject: Re: [RFC][PATCH] Multimedia scheduling class, take 2
In-Reply-To: <1242127152.11251.335.camel@twins>
Message-ID: <alpine.BSO.2.00.0905121502420.4712@rankki.sonarnerd.net>
References: <4959198A.3020209@sonarnerd.net>  <1230622925.16718.26.camel@twins>  <4959DE51.2020605@sonarnerd.net>  <1231756114.19771.6.camel@laptop> <496C6294.2040707@sonarnerd.net>  <4971D3D5.6040801@superbug.co.uk>  <497CF128.2060903@sonarnerd.net> 
 <1232954745.4863.4.camel@laptop>  <4A07E044.8040807@sonarnerd.net>  <1242107859.11251.301.camel@twins>  <4A094A44.30905@sonarnerd.net> <1242127152.11251.335.camel@twins>
User-Agent: Alpine 2.00 (BSO 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009, Peter Zijlstra wrote:

> There is an occasional stutter, but not much.

This is not acceptable and something to get rid of... VLC probably has 
quite a bit of buffering for audio, while my use cases are mostly for 
doing video calls, where the buffering has to be kept reasonably low to not
extend conversation latency for the audio too much.

> Thing is, adding static preemption priories into SCHED_OTHER (which is
> basically what you propose I think) doesn't really help, I can still
> load the machine high enough so that there simply isn't time available
> to decode the frames while maintaining proportional fairness -- no
> matter how preemptive you get.

First I would like to discuss possibility of assigning different 
priorities to different threads of a SCHED_OTHER process. 
(pthread_setschedparam() etc)

Second the idea is to reach nice compromise between normal SCHED_OTHER and 
hardcore SCHED_FIFO for application which fall between these two. And 
sure, the definite idea is that this SCHED_OTHER approach wouldn't be 
absolute in that sense, but would improve the overall situation.

According to my tests, full patch reduces timing misses 10x while not 
removing those completely. SCHED_FIFO removes all misses, but is a bit too 
hardcore for things like running browser-embedded flash plugin...


 	- Jussi
