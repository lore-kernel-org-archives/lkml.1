Return-Path: <linux-kernel-owner+w=401wt.eu-S1751410AbXA3Ulu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbXA3Ulu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 15:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbXA3Ulu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 15:41:50 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:44020 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbXA3Ult (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 15:41:49 -0500
Message-ID: <45BFAD8A.5080005@drzeus.cx>
Date: Tue, 30 Jan 2007 21:41:46 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
MIME-Version: 1.0
To: Russell King <rmk+lkml@arm.linux.org.uk>, Jens Axboe <axboe@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: How to map high memory for block io
References: <20060127202646.GC2767@flint.arm.linux.org.uk> <43DA84B2.8010501@drzeus.cx> <43DA97A3.4080408@drzeus.cx> <20060127225428.GD2767@flint.arm.linux.org.uk> <20060128191759.GC9750@suse.de> <43DBC6E2.4000305@drzeus.cx> <20060129152228.GF13831@suse.de> <43DDC6F9.6070007@drzeus.cx> <20060130080930.GB4209@suse.de> <43DFAEC6.3090205@drzeus.cx> <20060301232913.GC4024@flint.arm.linux.org.uk>
In-Reply-To: <20060301232913.GC4024@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> Okay, I've hit this same problem (but in a slightly different way) with
> mmci.c.  The way I'm proposing to fix this for mmci is to introduce a
> new capability which says "clustering is supported by this driver."
>
> I'm unconvinced that we can safely fiddle with the queue's flags once
> the queue is in use, hence why I've gone for the init-time only solution.
> Maybe Jens can comment on that?
>
> (The side effect of this patch is that everyone ends up with clustering
> disabled until they explicitly update their driver to enable it - which
> results in us defaulting to a safe operation mode.)
>
>   

Ok, time to warm up this old chestnut. I "solved" my immediate problem
with wbsd, and this got forgotten. AFAICT, mmci.c and the rest of the
lot are still broken in the sense that they use kmap but exceed page
limits (which happens to work on non-highmem pages).

I think the right solution is to let them use page_address() instead.
Would that be correct?

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

