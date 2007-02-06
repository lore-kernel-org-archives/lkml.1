Return-Path: <linux-kernel-owner+w=401wt.eu-S1030594AbXBFXkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030594AbXBFXkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:40:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030595AbXBFXkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:40:03 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55435 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030590AbXBFXj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:39:59 -0500
Date: Tue, 6 Feb 2007 15:39:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitriy Monakhov <dmonakhov@sw.ru>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/1][RFC] mm: prepare_write positive return value
Message-Id: <20070206153915.a6e6f8d7.akpm@linux-foundation.org>
In-Reply-To: <87ejp37kid.fsf@sw.ru>
References: <87ejp37kid.fsf@sw.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Feb 2007 11:33:46 +0300
Dmitriy Monakhov <dmonakhov@sw.ru> wrote:

> Almost all read/write operation handles data with chunks(segments or pages)
> and result has integral behaviour for folowing scenario: 
> for_each_chunk() {
>      res = op(....);
>      if(IS_ERROR(res))
>            return progress ? progress : res;
>      progress += res;
> }
> prepare_write may has integral behaviour in case of blksize < pgsize,
> for example we successfully allocated/read some blocks, but not all of them,
> and than some error happend. Currently we eliminate this progress by doing
> vmtrunate() after prepare_has failed.
> It is good to have ability to signal about this progress. Interprete positive
> prepare_write() ret code as bytes num that fs ready to handle at this moment.
> I've ask SAW, he think it is sane. This size always less than PAGE_CACHE_SIZE
> so it less than AOP_TRUNCATED_PAGE too.
>  
> BTH: This approach was used in OpenVZ 2.6.9 kernel in order to make FS with 
> delayed allocation more correct, and its works well.
> I think not everybody will happy about this,  but let's discuss all advantages
> and disadvantages of this change.

That seems to be a logical change.  We'd need to review all the callers and
callees to make sure that they handle this change correctly.

Your changes deviate quite a lot from standard kernel coding style.  Please fix
that.

Please cc linux-ext4@vger.kernel.org on the next version of these patches.  I'm
seriously running out of bandwidth over here and ext4 has other maintainers.

Thanks.
