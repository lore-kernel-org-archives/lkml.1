Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbYGXMKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbYGXMKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbYGXMKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:10:05 -0400
Received: from saeurebad.de ([85.214.36.134]:41272 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbYGXMKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:10:04 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, lomp0101@gmx.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Bug 11046] New: Kernel bug in mm/bootmem.c on Sparc machines
References: <bug-11046-27@http.bugzilla.kernel.org/>
	<20080706132049.4019e09f.akpm@linux-foundation.org>
	<20080723.202533.114601491.davem@davemloft.net>
	<20080723203836.e0c14568.akpm@linux-foundation.org>
Date: Thu, 24 Jul 2008 14:09:38 +0200
In-Reply-To: <20080723203836.e0c14568.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 23 Jul 2008 20:38:36 -0700")
Message-ID: <877ibb7abh.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 23 Jul 2008 20:25:33 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
>
>> From: Andrew Morton <akpm@linux-foundation.org>
>> Date: Sun, 6 Jul 2008 13:20:49 -0700
>> 
>> > On Sun,  6 Jul 2008 13:02:28 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
>> > 
>> > > http://bugzilla.kernel.org/show_bug.cgi?id=11046
>>  ...
>> > > Here is the BUG:
>> > > 
>> > > [    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 4.11.5 2003/11/12 10:40'
>> > > [    0.000000] PROMLIB: Root node compatible: 
>> > > [    0.000000] Linux version 2.6.25.10 (root@sparc1) (gcc version 4.1.2
>> > > 20061115 (prerelease) (Debian 4.1.1-21)) #5 SMP Sun Jul 6 21:05:42 CEST 2008
>> > > [    0.000000] console [earlyprom0] enabled
>> > > [    0.000000] ARCH: SUN4U
>> > > [    0.000000] Ethernet address: 00:03:ba:7a:f3:d6
>> > > [    0.000000] Kernel: Using 2 locked TLB entries for main kernel image.
>> > > [    0.000000] Remapping the kernel... done.
>> > > [    0.000000] kernel BUG at mm/bootmem.c:125!
>> 
>> This can only happen if you attach a zero-sized initrd to the kernel.
>> 
>> I see platforms like x86 sometimes have explicit checks for a zero
>> size to guard reserve_bootmem() and similar calls, but if that's what
>> callers are all going to do doesn't it make better sense for
>> reserve_bootmem_core() to just return instead of BUG on a zero size
>> argument?
>
> Sounds logical.
>
> Johannes just rewrote the bootmem code, but from a quick read it
> appears that this behaviour has been retained.

In the new version, zero sized ranges are okay for reservation and
freeing.  It still bugs on allocation, though.

> So if we're going to change it in 2.6.26, we'll need a separate patch.

	Hannes
