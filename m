Return-Path: <linux-kernel-owner+w=401wt.eu-S932905AbZDCW53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905AbZDCW53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 18:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758427AbZDCW5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 18:57:21 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:64105 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbZDCW5U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 18:57:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CImFQdrJt0ovTrlG59vKK290TtFDtDk5edYLwRKosSwUFlgIzY7t+hj1d4PBLUk26r
         bWU0HqWN/MVSudK246XDUjjh2/d308+vh1CsngzxVvBe3YaPe4JneLlDrdUUsU1pMZA1
         NJddRgRZUEr8HQKqZg3wp/p5gBmSK46XedIvo=
MIME-Version: 1.0
In-Reply-To: <20090403223218.GD25887@aniel>
References: <20090401143622.b1885643.akpm@linux-foundation.org> 
	<20090403040649.GF3795@csclub.uwaterloo.ca> <alpine.LFD.2.00.0904022112260.4130@localhost.localdomain> 
	<20090403072507.GO5178@kernel.dk> <20090403142129.GH3795@csclub.uwaterloo.ca> 
	<49D625A0.1030202@rtr.ca> <49D66A40.5020503@garzik.org> <20090403212847.GC25887@aniel> 
	<49D68631.4030706@garzik.org> <20090403223218.GD25887@aniel>
Date: Fri, 3 Apr 2009 15:57:03 -0700
Message-ID: <72dbd3150904031557q33c5f29cr3b767131dcc2f51@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: David Rees <drees76@gmail.com>
To: Janne Grunau <j@jannau.net>
Cc: Jeff Garzik <jeff@garzik.org>, Mark Lord <lkml@rtr.ca>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       tytso@mit.edu, jesper@krogh.cc,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 3, 2009 at 3:32 PM, Janne Grunau <j@jannau.net> wrote:
> On Fri, Apr 03, 2009 at 05:57:05PM -0400, Jeff Garzik wrote:
>> Just curious, does MythTV need fsync(), or merely to tell the kernel to
>> begin asynchronously writing data to storage?
>
> quoting the TheadedFileWriter comments
>
> /*
>  *   NOTE: This doesn't even try flush our queue of data.
>  *   This only ensures that data which has already been sent
>  *   to the kernel for this file is written to disk. This
>  *   means that if this backend is writing the data over a
>  *   network filesystem like NFS, then the data will be visible
>  *   to the NFS server after this is called. It is also useful
>  *   in preventing the kernel from buffering up so many writes
>  *   that they steal the CPU for a long time when the write
>  *   to disk actually occurs.
>  */

There is no need to fsync data on a NFS mount in Linux anymore.  All
NFS mounts are mounted sync by default now unless you explicitly
specify otherwise (and then you should then know what you're getting
in to).

-Dave
