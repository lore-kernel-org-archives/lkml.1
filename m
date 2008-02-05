Return-Path: <linux-kernel-owner+w=401wt.eu-S1758375AbYBERLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375AbYBERLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 12:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbYBERKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 12:10:39 -0500
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:34013 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbYBERKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 12:10:36 -0500
Date: Tue, 5 Feb 2008 09:10:05 -0800
From: Robin Lee Powell <rlpowell@digitalkingdom.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Monthly md check == hung machine; how do I debug?
Message-ID: <20080205171005.GA9284@digitalkingdom.org>
References: <20080203212155.GF12173@digitalkingdom.org> <200802042140.55521.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802042140.55521.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 09:40:55PM +1100, Nick Piggin wrote:
> On Monday 04 February 2008 08:21, Robin Lee Powell wrote:
> > I've got a machine with a 4 disk SATA raid10 configuration using
> > md. The entire disk is loop-AES encrypted, but that shouldn't
> > matter here.
> >
> > Once a month, Debian runs:
> >
> >     /usr/share/mdadm/checkarray --cron --all --quiet
> >
> > and the machine hangs within 30 minutes of that starting.
> >
> > It seems that I can avoid the hang by not having "mdadm
> > --monitor" running, but I'm not certain if that's the case or if
> > I've just been lucky this go-round.
> >
> > I'm on kernel 2.6.23.1, my own compile thereof, x86_64, AMD
> > Athlon(tm) 64 Processor 3700+.
> >
> > I've looked through all the 2.6.23 and 2.6.24 Changelogs, and I
> > can't find anything that looks relevant.
> >
> > So, how can I (help you all) debug this?
> 
> Do you have a serial console? Does it respond to pings?

No and yes.

> Can you try to get sysrq+T traces, and sysrq+P traces, and post
> them?

I played with those after you suggested it, but without serial
console had no way to capture them.

I was able to solve the problem, however, like so:

132c133
< # CONFIG_PREEMPT_NONE is not set
---
> CONFIG_PREEMPT_NONE=y
134,135c135,136
< CONFIG_PREEMPT=y
< CONFIG_PREEMPT_BKL=y
---
> # CONFIG_PREEMPT is not set
> # CONFIG_PREEMPT_BKL is not set

-Robin

-- 
Lojban Reason #17: http://en.wikipedia.org/wiki/Buffalo_buffalo
Proud Supporter of the Singularity Institute - http://singinst.org/
http://www.digitalkingdom.org/~rlpowell/ *** http://www.lojban.org/
