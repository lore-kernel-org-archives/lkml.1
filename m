Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbYDKVnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbYDKVnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 17:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbYDKVnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 17:43:06 -0400
Received: from mail-07.jhb.wbs.co.za ([196.2.97.4]:23019 "EHLO
	mail-07.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbYDKVnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 17:43:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoQAALp4/0fEAmHEh2dsb2JhbACRUwEBAQoFCQUYmSE
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Shutdown and Reboot Regression 2.6.25-rc[78]
Date: Fri, 11 Apr 2008 23:42:48 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
References: <200804112241.44626.bonganilinux@mweb.co.za> <alpine.LFD.1.00.0804111352390.3143@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0804111352390.3143@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804112342.48830.bonganilinux@mweb.co.za>
X-Original-Subject: Re: Shutdown and Reboot Regression 2.6.25-rc[78]
X-Scan-Signature: 0f89e3e24af1c5e0150dd7bf19b00837
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 April 2008 22:58:12 Linus Torvalds wrote:
> On Fri, 11 Apr 2008, Bongani Hlope wrote:
> > I found a regression in version 2.6.25-rc7, which causes my computer not
> > to shutdown or reboot. I get a complete lock up (no keyboard and Sys-Rq)
> > just before it normally shuts down the alsa service.
> >
> > I did a git bisect and it points to this reversion:
> > [266c2e0abeca649fa6667a1a427ad1da507c6375] Make printk() console
> > semaphore accesses sensible
>
> Interesting. That commit _should_ have just moved code around with no
> actual semantic changes.
>
> Can you verify that undoing just that one commit makes current git (-rc9)
> work for you? Ie just try a
>
> 	git revert 266c2e0abeca649fa6667a1a427ad1da507c6375
>
> on top of the current tree. I just want to check, because even after
> looking at that diff again, I'm not seeing what it could actually change.
>

After about 4 restarts and 4 reboots, 2.6.25-rc9 seems to work fine with and 
without the revert. I'll do some more testing.  The assembly output files for 
kernel/printk.c don't seem that different between rc9 and rc7. I'll see what 
else I can test.

Thanx
