Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbXCMPby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbXCMPby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbXCMPby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:31:54 -0400
Received: from hermes1.dur.ac.uk ([129.234.8.20]:48064 "EHLO hermes1.dur.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbXCMPbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:31:53 -0400
Date: Tue, 13 Mar 2007 15:35:14 +0000
From: Ash Milsted <thatistosayiseenem@gawab.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>
Subject: Re: [ck] RSDL v0.30 cpu scheduler for mainline kernels
Message-Id: <20070313153514.428dc3e1.thatistosayiseenem@gawab.com>
In-Reply-To: <200703121058.11966.kernel@kolivas.org>
References: <200703121058.11966.kernel@kolivas.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-DurhamAcUk-MailScanner: Found to be clean, Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007 10:58:11 +1100
Con Kolivas <kernel@kolivas.org> wrote:

> There are updated patches for 2.6.20, 2.6.20.2, 2.6.21-rc3 and 2.6.21-rc3-mm2 
> to bring RSDL up to version 0.30 for download here:
> 
> Full patches:
> 
> http://ck.kolivas.org/patches/staircase-deadline/2.6.20-sched-rsdl-0.30.patch
> http://ck.kolivas.org/patches/staircase-deadline/2.6.20.2-rsdl-0.30.patch
> http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-sched-rsdl-0.30.patch
> http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2-rsdl-0.30.patch
> 
> incrementals:
> 
> http://ck.kolivas.org/patches/staircase-deadline/2.6.20/2.6.20.2-rsdl-0.29-0.30.patch
> http://ck.kolivas.org/patches/staircase-deadline/2.6.20.2/2.6.20.2-rsdl-0.29-0.30.patch
> http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3/2.6.21-rc3-rsdl-0.29-0.30.patch
> http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2/2.6.21-rc3-mm2-rsdl-0.29-0.30.patch
> 
> -- 
> -ck
> _______________________________________________
> http://ck.kolivas.org/faqs/replying-to-mailing-list.txt
> ck mailing list - mailto: ck@vds.kolivas.org
> http://vds.kolivas.org/mailman/listinfo/ck

Here's my experience with RSDL 0.30 on 2.6.21-rc3-git6 under my normal
usage scenarios...

Plain desktop use (web browsing, music, etc): no noticeable change

Desktop use during kernel compile (no -j): The compile impacts desktop
use more with RSDL, but this is easily solved by nice-ing the compile
(default nice of 10 seems enough). The kind of impact I am talking about
is e.g. occasional delays in scrolling in the browser etc.

Desktop use whilst talking on Wengophone (run at nice -5): Under RSDL
some GUI use e.g. opening a new folder in nautilus causes pops (buffer
underruns) which do not occur with mainline. I suppose the changes in
RSDL might require a lower nice value for equivalent performance, but
(as a user) I am limited to -5.

Low-latency audio with JACK and Ardour2: Rock-solid performance with
either scheduler.. realtime works nicely.

Playing Quake3 (proprietary nvidia driver): Plays smoothly for both
schedulers.

So, I suppose I'd like to know what to do about the Wengophone issue,
because that really is a problem for me. I guess your re-worked -ive
nice values might help?

Ash
