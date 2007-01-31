Return-Path: <linux-kernel-owner+w=401wt.eu-S1752168AbXAaAzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbXAaAzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 19:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbXAaAzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 19:55:11 -0500
Received: from mout1.freenet.de ([194.97.50.132]:47090 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbXAaAzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 19:55:09 -0500
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: Andrew Morton <akpm@osdl.org>
Subject: Re: 2.6.20-rc6-mm3
Date: Wed, 31 Jan 2007 01:55:05 +0100
User-Agent: KMail/1.9.5
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <20070129204528.eb8d695e.akpm@osdl.org> <45BFC442.5000903@gmail.com> <20070130142714.9f8dd5da.akpm@osdl.org>
In-Reply-To: <20070130142714.9f8dd5da.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701310155.05474.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 30. Januar 2007 23:27 schrieb Andrew Morton:
> On Tue, 30 Jan 2007 23:18:42 +0100
> Maciej Rutecki <maciej.rutecki@gmail.com> wrote:
<...> 
> > I have two problems. First suspend to disk.
> > 
> > After suspend to disk (before resume) I check time in bios, and it's
> > correct, but during resume, I have this message:
> > 
> > "Suspending console(s)"
> > 
> > system wait 20 seconds (or more) until finish resume. Also system clock
> > was slow about this 20 seconds.
> 
> OK, thanks.  That might be due to the time-management updates as well. 
> I'll see if I can reproduce this.
> 
> If you're keen, you could test just 2.6.19-rc6+origin.patch+git-acpi.patch
> from
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out
> and see which of these problems remain.

Similar weirdness here on rc6-mm2 and rc6-rt*:
resume from disk waits unduly long.
I played with bios clock setting after I wondered why susp/res
 wouldn't work overnight:
the longer the (faked/real) suspend to disk time,
the longer the (not seen on 2.6.18-rt) waiting past the incrementing
% display, before things are running again.
After turning time backwards in bios, console mouse handler gpm experiences
"interrupted system call". 


Some waiting times from rc6-rt6 from memory:

Config			| HZ			| NO_HZ + HRESTIMERS
cmos clock unchanged	| 2s			| 6s
cmos clock += 10min	| 			| 2 minutes
cmos clock += 2 month	| 20s			| > 4minutes, test interrupted


      Karsten
