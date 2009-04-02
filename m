Return-Path: <linux-kernel-owner+w=401wt.eu-S933258AbZDBSyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258AbZDBSyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932071AbZDBSyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:54:19 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:48986 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762654AbZDBSyS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:54:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CQQugwrdHzgAoGCAfYNdhRQ8tDxGcxYn8P8pgL0dnTX7cXWBacruQE9KjWXyM5wxX5
         WlXGZH6Vz4vY1XOD/rzL/I2Lx91Uz0Oscv2wAzQChLXXoyPCrex7ak1qOduFrhltvIX1
         R2J+AEOqygLwbe0bQaEFmnUjVQrQ39rdtWW9k=
MIME-Version: 1.0
In-Reply-To: <20090402094247.9d7ac19f.akpm@linux-foundation.org>
References: <20090325183011.GN32307@mit.edu> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> 
	<alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> 
	<20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> 
	<20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> 
	<20090402110532.GA5132@aniel> <72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com> 
	<20090402094247.9d7ac19f.akpm@linux-foundation.org>
Date: Thu, 2 Apr 2009 11:52:24 -0700
Message-ID: <72dbd3150904021152l5cbb576aodf312b50a824bbb2@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: David Rees <drees76@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Janne Grunau <j@jannau.net>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 9:42 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> For any filesystem it is quite sensible for an application to manage
> the amount of dirty memory which the kernel is holding on its behalf,
> and based upon the application's knowledge of its future access
> patterns.
>
> But MythTV did it the wrong way.
>
> A suitable design for the streaming might be, every 4MB:
>
> - run sync_file_range(SYNC_FILE_RANGE_WRITE) to get the 4MB underway
>  to the disk
>
> - run fadvise(POSIX_FADV_DONTNEED) against the previous 4MB to
>  discard it from pagecache.

Yep, you're right.  sync_file_range is perfect for what MythTV wants to do.

Though there are cases where MythTV can read data it wrote out not too
long ago, for example, when commercial flagging, so
fadvise(POSIX_FADV_DONTNEED) may not be warranted.

-Dave
