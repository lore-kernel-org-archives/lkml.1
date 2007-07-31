Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbXGaLTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbXGaLTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 07:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbXGaLSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 07:18:51 -0400
Received: from styx.suse.cz ([82.119.242.94]:60771 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750788AbXGaLSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 07:18:50 -0400
Date: Tue, 31 Jul 2007 13:30:00 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ulrich Kunitz <kune@deine-taler.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, Jan Kratochvil <honza@jikos.cz>,
       jakub@redhat.com
Subject: Re: Is PIE randomization breaking klibc binaries?
In-Reply-To: <20070725063243.GA25148@deine-taler.de>
Message-ID: <Pine.LNX.4.64.0707311326090.26532@jikos.suse.cz>
References: <20070720211300.GA21644@deine-taler.de> <46A131BF.4080404@zytor.com>
 <46A6624E.60003@redhat.com> <46A667BD.5080106@redhat.com>
 <20070724220053.GA20531@deine-taler.de> <46A68003.6060901@redhat.com>
 <46A68118.9080902@zytor.com> <20070725063243.GA25148@deine-taler.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007, Ulrich Kunitz wrote:

> The message looks like:
> sleep[7888]: segfault at 000000000004001C rip 000000000004001C rsp 
> 00007fff14776468 error 14
> Repeated calls get the same message with the stack pointer changing. 
> Other binaries (mount) have a segmentation fault at another addressi 
> (0x400184). It appears that the instruction pointer fails at the start 
> address of the klibc binary. Notify that this lies in the binary itself 
> and not in the /lib/klibc*.so object, so it appears that the klibc 
> binary sections are loaded at randomized addresses.

Hi Ulrich,

I just now quickly tried to with klibc-1.5 on i386 with the 
PIE-randomization patched kernel, and it seems to load static libraries 
fine.

I just downloaded klibc-1.5, built it, and executed a few of the programs 
in usr/utils/static, all of them worked. Does this also work for you and 
you are experiencing the problems solely when the binaries are being run 
from initramfs during boot?

I will test more shortly (on x86_64, directly from initramfs) in order to 
reproduce.

Thanks,

-- 
Jiri Kosina
SUSE Labs
