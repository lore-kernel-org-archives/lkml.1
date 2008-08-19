Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbYHSK3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbYHSK3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 06:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYHSK3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 06:29:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48238 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbYHSK3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 06:29:16 -0400
Date: Tue, 19 Aug 2008 12:31:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes to use function calls [POST 2]
Message-ID: <20080819103100.GH9807@one.firstfloor.org>
References: <patchbomb.1219083817@localhost> <48AA5C19.3010204@goop.org> <20080819093130.GF28713@elte.hu> <200808191956.59898.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808191956.59898.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm especially sore about mmap because I have a customer with a
> database that uses a lot of mmap/munmap and those calls have slowed
> down something like 50%(!!) from 2.6.early to 2.6.late.

These are small mmaps right? Also in this case no kmalloc should
be needed anyways.

AFAIK mmap flushing hasn't changed much in 2.6 and it tends
to batch well anyways in this case (unlike vmscan swapping). I would be 
careful to really optimize the real culprits which are likely elsewhere.

-Andi
