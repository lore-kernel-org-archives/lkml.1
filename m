Return-Path: <linux-kernel-owner+w=401wt.eu-S1761558AbYFEVMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761558AbYFEVMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 17:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbYFEVLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 17:11:50 -0400
Received: from smtp.movial.fi ([62.236.91.34]:51465 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbYFEVLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 17:11:49 -0400
Message-ID: <53210.84.249.59.97.1212700307.squirrel@webmail.movial.fi>
In-Reply-To: <20080605114213.239d66aa.akpm@linux-foundation.org>
References: <1212690397-25693-1-git-send-email-dmitri.vorobiev@movial.fi>
    <20080605114213.239d66aa.akpm@linux-foundation.org>
Date: Fri, 6 Jun 2008 00:11:47 +0300 (EEST)
Subject: Re: [PATCH 0/2] Remove BKL from the bfs driver
From: "Vorobiev Dmitri" <dmitri.vorobiev@movial.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Dmitri Vorobiev" <dmitri.vorobiev@movial.fi>, tigran@aivazian.fsnet.co.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu,  5 Jun 2008 21:26:35 +0300
> Dmitri Vorobiev <dmitri.vorobiev@movial.fi> wrote:
>
>> This removes quite a few instances of BKL usage in the bfs
>> driver. Given the purpose and the user base of this driver,
>> I do not believe that a finer-granularity lock than the big
>> fat filesystem-wide mutex I have implemented here is needed.
>
> How well tested was this?  With lockdep enabled?
>

Frankly speaking, I performed just some basic tests like mounting
a BFS partition, creating a few files on it, reading and writing
files, unmounting the partition, etc. Yes, lockdep was enabled.

> Because the new mutex cannot be taken recursively, whereas the BKL can.
> And there's potential for ab/ba deadlocks with, for example, i_mutex.
>
> However I don't see any such problems from a moderately intensive
> review.

OK, thank you for the review and for picking up the patches.

Dmitri
