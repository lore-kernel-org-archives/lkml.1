Return-Path: <linux-kernel-owner+w=401wt.eu-S1757855AbZE3XLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbZE3XLQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 19:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755349AbZE3XKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 19:10:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56648 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753833AbZE3XKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 19:10:50 -0400
Date: Sun, 31 May 2009 00:10:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "Larry H." <research@subreption.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page 
 allocator
Message-ID: <20090531001052.40ac57d2@lxorguk.ukuu.org.uk>
In-Reply-To: <84144f020905301353y2f8c232na4c5f9dfb740eec4@mail.gmail.com>
References: <20090528090836.GB6715@elte.hu>
	<20090530075033.GL29711@oblivion.subreption.com>
	<4A20E601.9070405@cs.helsinki.fi>
	<20090530082048.GM29711@oblivion.subreption.com>
	<20090530173428.GA20013@elte.hu>
	<20090530180333.GH6535@oblivion.subreption.com>
	<20090530182113.GA25237@elte.hu>
	<20090530184534.GJ6535@oblivion.subreption.com>
	<20090530190828.GA31199@elte.hu>
	<4A21999E.5050606@redhat.com>
	<84144f020905301353y2f8c232na4c5f9dfb740eec4@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's pretty damn obvious that Larry's patches have a much bigger
> performance impact than using kzfree() for selected parts of the
> kernel. So yes, I do expect him to benchmark and demonstrate that
> kzfree() has _performance problems_ before we can look into merging
> his patches.

We seem to be muddling up multiple things here which is not helpful.

There are three things going on

#1 Is ksize() buggy ?

#2 Using kzfree() to clear specific bits of memory (and I question the
kzfree implementation as it seems ksize can return numbers much much
bigger than the allocated space you need to clear - correct but oversize)
or using other flags. I'd favour kzfree personally (and fixing it to work
properly)

#3 People wanting to be able to select for more security *irrespective*
of performance cost. Which is no different to SELinux for example.


Conflating them all into one mess is causing confusion

