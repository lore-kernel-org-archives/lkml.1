Return-Path: <linux-kernel-owner+w=401wt.eu-S1751318AbZAZH0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbZAZH0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 02:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbZAZHZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 02:25:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44289 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbZAZHZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 02:25:56 -0500
Subject: Re: [RFC][PATCH] Multimedia scheduling class
From: Peter Zijlstra <peterz@infradead.org>
To: Jussi Laako <jussi@sonarnerd.net>
Cc: James Courtier-Dutton <James@superbug.co.uk>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <497CF128.2060903@sonarnerd.net>
References: <4959198A.3020209@sonarnerd.net>
	 <1230622925.16718.26.camel@twins>  <4959DE51.2020605@sonarnerd.net>
	 <1231756114.19771.6.camel@laptop> <496C6294.2040707@sonarnerd.net>
	 <4971D3D5.6040801@superbug.co.uk>  <497CF128.2060903@sonarnerd.net>
Content-Type: text/plain
Date: Mon, 26 Jan 2009 08:25:45 +0100
Message-Id: <1232954745.4863.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-26 at 01:09 +0200, Jussi Laako wrote:
> James Courtier-Dutton wrote:
> >> For sure this is nice for certain tasks. I'm not entirely convinced if
> >> the average media player or Flash-plugin would or should start using these.
> > 
> > There is never a need for media players to use this.
> > Media players have time stamps on the displayed frames.
> > If the timestamp on a frame indicates it has taken too long to decode
> > it, the media player just skips the frame until it reaches frames that
> > have non-expired time stamps. No need for any kernel help here.
> 
> This is completely irrelevant. These media players still play audio and
> sync video to audio. Many of these players are not programmed in a way
> that it would be safe to run these on SCHED_FIFO. Or the environment
> these are running in is not safe enough. But still smooth video and
> audio playback is needed, even in cases when locate database is being
> rebuilt in the background and possibly other CPU and IO intensive tasks
> are running. Any skipped frames make the video playback look jumpy, if
> frames are lost, it should be single frame periodically, not burst of
> frames at once...
> 
> Good everyday normal example is HD video played from Youtube or similar
> site using Flash plugin inside browser. There can be various background
> tasks running at the same time, but the video playback should still be
> smooth. One may want to run thread doing video decoding at significantly
> lower priority than audio decoding thread in order to maintain overall
> system responsiveness in cases of high CPU load from the video decoding
> part. While the audio thread shouldn't starve or miss it's deadline.

Right, and I think the solution to this problem is twofold, 1)
application writers should start writing (soft) realtime applications if
they want (soft) realtime behaviour -- there's just no way around that.

And 2), the kernel can help by providing a deadline based scheduler,
which should make the above easier and less likely to mess up the rest
of the system. ie. a deadline scheduled application will not exceed its
allotted budget, unlike a FIFO scheduled app.



