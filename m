Return-Path: <linux-kernel-owner+w=401wt.eu-S1760238AbZELLT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238AbZELLT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 07:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbZELLTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 07:19:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43748 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbZELLTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 07:19:16 -0400
Subject: Re: [RFC][PATCH] Multimedia scheduling class, take 2
From: Peter Zijlstra <peterz@infradead.org>
To: Jussi Laako <jussi@sonarnerd.net>
Cc: James Courtier-Dutton <James@superbug.co.uk>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, d.faggioli@sssup.it
In-Reply-To: <4A094A44.30905@sonarnerd.net>
References: <4959198A.3020209@sonarnerd.net>
	 <1230622925.16718.26.camel@twins>  <4959DE51.2020605@sonarnerd.net>
	 <1231756114.19771.6.camel@laptop> <496C6294.2040707@sonarnerd.net>
	 <4971D3D5.6040801@superbug.co.uk>  <497CF128.2060903@sonarnerd.net>
	 <1232954745.4863.4.camel@laptop>  <4A07E044.8040807@sonarnerd.net>
	 <1242107859.11251.301.camel@twins>  <4A094A44.30905@sonarnerd.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 12 May 2009 13:19:12 +0200
Message-Id: <1242127152.11251.335.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 13:07 +0300, Jussi Laako wrote:
> Peter Zijlstra wrote:
> > I certainly don't think the current situation is bad enough to warrant
> > things like that, media on my machines works peachy (*cheer* for XV on
> > R600).
> 
> By the way, here's a good test case for a desktop, preferably UP:
>  - run something like this in a loop:
> 	find / -type f -exec grep asd "{}" ";"
>  - run x11perf * numcpus in a loop
>  - run glxgears * numcpus
>  - go to youtube frontpage with a web browser
>  - start for example "totem" mediaplayer and play full-HD H.264 movie
> 
> Does the movie playback and audio go smoothly? Can you play youtube HD
> videos smoothly?

I don't know about youtube, that flash thing doesn't seem to deliver
full hd content, and I'm not sure where to click, but playing a full-hd
trailer from the network using vlc seems to work just fine with 4
x11perf and 4 glxgears and that find thing.

There is an occasional stutter, but not much.

Thing is, adding static preemption priories into SCHED_OTHER (which is
basically what you propose I think) doesn't really help, I can still
load the machine high enough so that there simply isn't time available
to decode the frames while maintaining proportional fairness -- no
matter how preemptive you get.


