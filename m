Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbZFWKdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbZFWKdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 06:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbZFWKda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 06:33:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:37184 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbZFWKd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 06:33:29 -0400
Subject: Re: mm: dirty page problem
From: Peter Zijlstra <peterz@infradead.org>
To: xue yong <ultraice.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <fc71709d0906230202w14da8ffdpf457f7a6ed658a28@mail.gmail.com>
References: <fc71709d0906230117h2bee4d7en9f3aadeae3cb9545@mail.gmail.com>
	 <fc71709d0906230202w14da8ffdpf457f7a6ed658a28@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 23 Jun 2009 12:33:39 +0200
Message-Id: <1245753219.19816.1586.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 17:02 +0800, xue yong wrote:
> I did some search in the changlogs between 2..6.16 adn 2.6.19.
> I found this in http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.19
> 
> and I concluded that the kernel below 2.6.19 can't tracking shared
> dirty pages, am I right?
> 
> commit edc79b2a46ed854595e40edcf3f8b37f9f14aa3f
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Mon Sep 25 23:30:58 2006 -0700
> 
>     [PATCH] mm: balance dirty pages

> commit d08b3851da41d0ee60851f2c75b118e1f7a5fc89
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Mon Sep 25 23:30:57 2006 -0700
> 
>     [PATCH] mm: tracking shared dirty pages

Correct, prior to .19 we didn't have effective tracking of dirty pages.
munmap() and msync() would walk the page tables and collect dirty pages,
but without explicit action these pages would stay hidden.

These patches you found change that by mapping clean shared pages RO and
taking a fault on the dirtying write. We once again map then RO when
they'd be written out to disk.


