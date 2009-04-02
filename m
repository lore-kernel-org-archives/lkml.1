Return-Path: <linux-kernel-owner+w=401wt.eu-S1765447AbZDBQeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765447AbZDBQeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762083AbZDBQeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:34:04 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:28169 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759644AbZDBQeC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:34:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qWgyk6y9mEr+iNo/JO0aP8/TS2MQDezotb3ZRY5AKEL6Dr6f4iGwdC4fhLOmmZL6uv
         ACoPuCMMIJhrbCa2FQF6qBHHgzqzxtdVZMnQSSXnkK2ZxxatEtiV1JmUMkYzoZIKPhUx
         uJweAGJFY6VLCCpyIQodJkNxwnVKvGGkFficY=
MIME-Version: 1.0
In-Reply-To: <20090402090912.cac200bb.akpm@linux-foundation.org>
References: <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> 
	<20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> 
	<20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> 
	<20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> 
	<20090402110532.GA5132@aniel> <20090402090912.cac200bb.akpm@linux-foundation.org>
Date: Thu, 2 Apr 2009 09:33:44 -0700
Message-ID: <72dbd3150904020933y515c7185p5726323c430c339b@mail.gmail.com>
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

On Thu, Apr 2, 2009 at 9:09 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 2 Apr 2009 13:05:32 +0200 Janne Grunau <j@jannau.net> wrote:
>> MythTV calls fsync every few seconds on ongoing recordings to prevent
>> stalls due to large cache writebacks on ext3.
>
> It should use sync_file_range(SYNC_FILE_RANGE_WRITE).  That will
>
> - have minimum latency.  It tries to avoid blocking at all.
> - avoid writing metadata
> - avoid syncing other unrelated files within ext3
> - avoid waiting for the ext3 commit to complete.

MythTV actually uses fdatasync, not fsync (or at least that's what it
did last time I looked at the source).  Not sure how the behavior of
fdatasync compares to sync_file_range.

Either way - forcing the data to be synced to disk a couple times
every second is a hack and causes fragmentation in filesystems without
delayed allocation.  Fragmentation really goes up if you are recording
multiple shows at once.

-Dave
