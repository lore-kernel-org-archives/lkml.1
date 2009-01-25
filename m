Return-Path: <linux-kernel-owner+w=401wt.eu-S1751686AbZAYXJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbZAYXJj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 18:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbZAYXJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 18:09:31 -0500
Received: from rankki.sonarnerd.net ([83.145.240.118]:37581 "EHLO
	mail.sonarnerd.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbZAYXJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 18:09:30 -0500
Message-ID: <497CF128.2060903@sonarnerd.net>
Date: Mon, 26 Jan 2009 01:09:28 +0200
From: Jussi Laako <jussi@sonarnerd.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: James Courtier-Dutton <James@superbug.co.uk>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH] Multimedia scheduling class
References: <4959198A.3020209@sonarnerd.net>	 <1230622925.16718.26.camel@twins>  <4959DE51.2020605@sonarnerd.net> <1231756114.19771.6.camel@laptop> <496C6294.2040707@sonarnerd.net> <4971D3D5.6040801@superbug.co.uk>
In-Reply-To: <4971D3D5.6040801@superbug.co.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Courtier-Dutton wrote:
>> For sure this is nice for certain tasks. I'm not entirely convinced if
>> the average media player or Flash-plugin would or should start using these.
> 
> There is never a need for media players to use this.
> Media players have time stamps on the displayed frames.
> If the timestamp on a frame indicates it has taken too long to decode
> it, the media player just skips the frame until it reaches frames that
> have non-expired time stamps. No need for any kernel help here.

This is completely irrelevant. These media players still play audio and
sync video to audio. Many of these players are not programmed in a way
that it would be safe to run these on SCHED_FIFO. Or the environment
these are running in is not safe enough. But still smooth video and
audio playback is needed, even in cases when locate database is being
rebuilt in the background and possibly other CPU and IO intensive tasks
are running. Any skipped frames make the video playback look jumpy, if
frames are lost, it should be single frame periodically, not burst of
frames at once...

Good everyday normal example is HD video played from Youtube or similar
site using Flash plugin inside browser. There can be various background
tasks running at the same time, but the video playback should still be
smooth. One may want to run thread doing video decoding at significantly
lower priority than audio decoding thread in order to maintain overall
system responsiveness in cases of high CPU load from the video decoding
part. While the audio thread shouldn't starve or miss it's deadline.
