Return-Path: <linux-kernel-owner+w=401wt.eu-S1759097AbXFVXGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbXFVXGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 19:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXFVXGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 19:06:09 -0400
Received: from server145.whmcpanel.net ([69.72.254.178]:60761 "EHLO
	server459.whmcpanel.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbXFVXGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 19:06:08 -0400
X-Greylist: delayed 3516 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jun 2007 19:06:08 EDT
From: Alberto Gonzalez <info@gnebu.es>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Question about fair schedulers
Date: Sat, 23 Jun 2007 00:07:15 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706230007.15622.info@gnebu.es>
X-PopBeforeSMTPSenders: info@gnebu.es
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server459.whmcpanel.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - gnebu.es
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

First I'd like to say I'm not a programmer or even a geek, just a normal user, 
so my question might be very basic or even stupid. If so, please excuse me.

I've been reading about CFS and SD schedulers here on the list and my basic 
understanding is that they try to improve interactivity by being completely 
fair, i.e., giving the same amount of CPU time to each task running at a 
given time. There is something I don't get about this, so today I tried a 
little test with the -ck kernel comparing it to mainline.

Let's say I have a HD video that uses ~70% CPU. Let's say I want to watch it 
while I encode my music to vorbis (or rip a DVD). This is the only reasonable 
scenario I can imagine on a normal desktop, since most desktops have the CPU 
idle or under 10% usage during 95% of the time and a CPU scheduler makes no 
difference (maybe people on this list compile a few kernels every day, but 
that's not what most normal users like me do).

Ok, so what will a fair scheduler do in this case? It is my understanding that 
it would give 50% CPU to each task, resulting in the video dropping frames. 
Is this correct?

Now, the _ideal_ solution for this situation would be to give ~70% to the 
video and the rest (~30%) to the encoder. But this goes against fairness, 
doesn't it? Yet most reports I've read about these two fair schedulers say 
that videos play smoother under load. What am I missing?

If I ask this question is because today I tested it and found that using 
the -ck kernel (with SD scheduler) the video would drop frames, while with 
the mainline kernel it played fine.

My conclusion is that SD behaves as expected: it's more fair. But for a 
desktop, shouldn't an "intelligently unfair" scheduler be better?

Thanks for any insights.

P.S: As a second thought, a fair scheduler could behave really good in other 
scenarios, like a server running a busy forum on apache+mysql+php. Besides, 
this is a more real world scenario (and easier to benchmark). Why aren't 
people testing these schedulers under this kind of load?
