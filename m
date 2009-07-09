Return-Path: <linux-kernel-owner+w=401wt.eu-S1760545AbZGIKrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760545AbZGIKrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 06:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759987AbZGIKrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 06:47:45 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:57812 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759354AbZGIKro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 06:47:44 -0400
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: kmemeleak BUG: lock held when returning to user space!
References: <20090709104202.GA3434@localdomain.by>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 09 Jul 2009 11:47:23 +0100
In-Reply-To: <20090709104202.GA3434@localdomain.by> (Sergey Senozhatsky's message of "Thu\, 9 Jul 2009 13\:42\:02 +0300")
Message-ID: <tnxeisquo90.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Jul 2009 10:47:25.0218 (UTC) FILETIME=[A547E020:01CA0082]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Senozhatsky <sergey.senozhatsky@mail.by> wrote:
> kernel: [  149.507103] ================================================
> kernel: [  149.507113] [ BUG: lock held when returning to user space! ]
> kernel: [  149.507119] ------------------------------------------------
> kernel: [  149.507127] cat/3279 is leaving the kernel with locks still held!
> kernel: [  149.507135] 1 lock held by cat/3279:
> kernel: [  149.507141]  #0:  (scan_mutex){+.+.+.}, at: [<c110707c>] kmemleak_open+0x4c/0x80
>
> problem is here:
> static int kmemleak_open(struct inode *inode, struct file *file)

It's been fixed in my kmemleak branch which I'll push to Linus:

http://www.linux-arm.org/git?p=linux-2.6.git;a=shortlog;h=kmemleak

-- 
Catalin
