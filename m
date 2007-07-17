Return-Path: <linux-kernel-owner+w=401wt.eu-S936684AbXGQXrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936684AbXGQXrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759194AbXGQXrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:47:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:60723 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758248AbXGQXrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:47:24 -0400
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
From: utz lehmann <lkml123@s2y4n2c.de>
To: John Stoffel <john@stoffel.org>
Cc: Rene Herman <rene.herman@gmail.com>, Bodo Eggert <7eggert@gmx.de>,
       Matt Mackall <mpm@selenic.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>
In-Reply-To: <18076.54789.359986.788880@stoffel.org>
References: <8FO1e-2jW-35@gated-at.bofh.it> <8FYWD-2eS-7@gated-at.bofh.it>
	 <8GdsH-8dc-13@gated-at.bofh.it> <8Ghmx-60z-17@gated-at.bofh.it>
	 <8Gj55-hJ-5@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it>
	 <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it>
	 <E1  <469BF104.1040703@gmail.com>
	 <1184628395.8707.15.camel@segv.aura.of.mankind>
	 <18076.54789.359986.788880@stoffel.org>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 01:46:43 +0200
Message-Id: <1184716003.9560.29.camel@segv.aura.of.mankind>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/MYKXJGE3zQMjiHQwIqp/MiYSjbj4VW01sZwi
 h2x3KVaPc2hNBL7rxAXnkUxmB4U/ONkFK3txP9BqAwah0Te4rn
 Pyc92sFeogJlGu912jwl1QcuXxE5PI/
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-17 at 10:45 -0400, John Stoffel wrote:
> utz> I have to recompile the fedora kernel rpms (fc6, f7) with 8k
> utz> stacks on my i686 server. It's using NFS -> XFS -> DM -> MD
> utz> (raid1) -> IDE disks.  With 4k stacks it crash (hang) within
> utz> minutes after using NFS.  With 8k stacks it's rock solid. No
> utz> crashes within months.
> 
> Does it give any useful information when it does crash?
>  
No, sorry. Nearly always it lock up so hard that even sysrq didn't work
anymore. Most times the console was blanked. If not, there was a line
with "do_irq" or something like that (if i remember correctly).
A few times it continuous oopsing (scrolling like mad).

I think it's just a stack overflow. Knowing that XFS + long IO stack
have problems with 4k stacks. And i have zero crashes with the
recompiled 8k stack kernels. (All kernel are the fedora ones).

Btw: In the past the server runs on slightly different hardware and
without raid1 (NFS -> XFS -> DM -> IDE disk). It runs with 4k stacks. I
had a few crashes, but i blame the hardware for it.

I don't want to make tests with the server. It's my main data storage
and i don't want to risk it.

>  Can you make
> a simple test case using ram disks instead of IDE disks and then
> building upon that?

Sorry, i don't think i can do this. My other computer, which i can use
for tests, is x86_64 based.
And IFAIK the problem on the XFS side has something to do with looking
for freespace on many AGs. So maybe a bigger and filled filesystem is
needed. And 50GB ram disks are out of question.

utz


