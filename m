Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbYJGKXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbYJGKXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbYJGKXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:23:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35827 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbYJGKXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:23:36 -0400
Date: Tue, 7 Oct 2008 12:29:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit arch
Message-ID: <20081007102942.GE20740@one.firstfloor.org>
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2> <87hc7onbvo.fsf@basil.nowhere.org> <6.0.0.20.2.20081007183452.0f052210@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6.0.0.20.2.20081007183452.0f052210@172.19.0.2>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe cmpxchg8b is good for i486 or later x86, but i386 or other architectures
> that do not have similar instruction needs some locking primitive. I think lazy

We have a cmpxchg emulation on 386. That works because only UP 386s are 
supported, so it can be done in software.

> seqlock is one option for making file->f_pos access atomic.

The question is if it's the right option. At least all the common
operations on fds (read/write) are all writers, not readers.

-Andi

-- 
ak@linux.intel.com
