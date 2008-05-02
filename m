Return-Path: <linux-kernel-owner+w=401wt.eu-S933758AbYEBMHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933758AbYEBMHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761551AbYEBMG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:06:57 -0400
Received: from hpsmtp-eml14.kpnxchange.com ([213.75.38.114]:48685 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759921AbYEBMG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:06:57 -0400
From: Frans Pop <elendil@planet.nl>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Horrendous Audio Stutter - current git
Date: Fri, 2 May 2008 14:06:54 +0200
User-Agent: KMail/1.9.9
Cc: Parag Warudkar <parag.warudkar@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com> <200805021337.10809.elendil@planet.nl> <1209728372.13978.147.camel@twins>
In-Reply-To: <1209728372.13978.147.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805021406.55038.elendil@planet.nl>
X-OriginalArrivalTime: 02 May 2008 12:06:55.0914 (UTC) FILETIME=[03F890A0:01C8AC4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2008, Peter Zijlstra wrote:
> On Fri, 2008-05-02 at 13:37 +0200, Frans Pop wrote:
> > On Friday 02 May 2008, Peter Zijlstra wrote:
> > > > Ok, that's _WAY_ too big, something went seriously wrong. Thanks!
> > >
> > > In fact, that is exactly 1024 time too large.
> > >
> > > How does this work for you:
> >
> > Changes nothing. Values of bonus_max are unchanged and still skips.
>
> Humm, I saw some bonus_max spikes on my laptop which were fixed by that
> patchlet, ah well, the hunt goes on.

Looks like you've got it after all! With the patch in the correct place 
there are no more skips and I now get:

/proc/5182/task/5182/sched:se.bonus_max  :        39.960966
/proc/5182/task/5263/sched:se.bonus_max  :        39.960966
/proc/5182/task/5267/sched:se.bonus_max  :        39.960966
/proc/5182/task/5268/sched:se.bonus_max  :        39.960966
/proc/5182/task/5269/sched:se.bonus_max  :        39.960966
/proc/5182/task/5270/sched:se.bonus_max  :        19.990234
/proc/5182/task/5661/sched:se.bonus_max  :        39.960966

Note (mostly for Parag) that I had GROUP_SCHED disabled for these tests, but 
for me that did make not any difference with my 2.6.25-rc tests for this 
issue, nor with my tests using sched-devel earlier in the .26 merge window.

Feel free to add my
Tested-by: Frans Pop <elendil@planet.nl>

Cheers,
FJP
