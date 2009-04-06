Return-Path: <linux-kernel-owner+w=401wt.eu-S1761545AbZDFWEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761545AbZDFWEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759387AbZDFWEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:04:23 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:42094 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbZDFWEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:04:22 -0400
MIME-Version: 1.0
In-Reply-To: <003001c9b6ff$a9259ce0$fb70d6a0$@com>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com> 
	<alpine.LFD.2.00.0904060803141.4023@localhost.localdomain> 
	<20090406151054.GD5178@kernel.dk> <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain> 
	<20090406183157.GD7376@mit.edu> <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain> 
	<002501c9b6f3$f85b4910$e911db30$@com> <20090406211931.GB8586@mit.edu> 
	<003001c9b6ff$a9259ce0$fb70d6a0$@com>
Date: Mon, 6 Apr 2009 15:04:05 -0700
Message-ID: <2c0942db0904061504l6504934bi446f7425fcd38470@mail.gmail.com>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
From: Ray Lee <ray-lk@madrabbit.org>
To: Hua Zhong <hzhong@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 6, 2009 at 2:35 PM, Hua Zhong <hzhong@gmail.com> wrote:
>> I've added workarounds for 2.6.30 that provide the replace-via-rename
>> and replace-via-truncate workarounds for ext3 data=writeback cases.
>> See commits e7c8f507 and f7ab34ea.
>>
>> There won't be an implied fsync for newly created files, yes, but you
>> could have crashed 5 seconds earlier, at which point you would have
>> lost the newly created file anyway.  Replace-via-rename and
>> replace-via-truncate solves the problem for applications which are
>> editing pre-existing files, which was most of people's complaints
>> about depending on data=ordered semantics.
>
> I am not talking about "most" people's complaints. There are use cases for
> ext3 far beyond the desktop.
>
> I worked on a user-space library on top of ext3 before on embedded systems.
> It may not have been the case for me but I could well imagine where it could
> get too clever and depend upon "ordered".

Speaking as another embedded Linux guy, I don't update kernels on my
embedded platforms willy-nilly, nor do I design a library that relies
upon some default behavior without specifying it explicitly. That's
just one of the prices of doing embedded development.

Your argument seems to be that someone may be relying upon default
kernel behavior and, at the same time, is willing to continually
upgrade their kernel. I'd argue that person is, y'know, nuts. If
they're willing to upgrade their kernel on something that has that
stringent of requirements, then they should be willing to force a
mount option at the same time.

If they're willing to upgrade their kernel blindly, then they
shouldn't be doing embedded development.
