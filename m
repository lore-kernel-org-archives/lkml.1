Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473AbZDCCjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbZDCCjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 22:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbZDCCjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 22:39:04 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:12692 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbZDCCjB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 22:39:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nz9RY9CxdCZUqZyUZUtc86cgVMjL/DU7o1w3gYMQaK5Xc3mAz4cFFYZkrCMhbO2wsy
         sAO89TDt3H4L6QvosNLAJGXttcbdP4QJH42WXVuvMy4xbYmdlnZTvdBWzQB2rbjerPvf
         LxkV/66RDXlj4DeINu+gfo6EWhc2B9Wf2krsI=
MIME-Version: 1.0
In-Reply-To: <49D56DF6.5020300@garzik.org>
References: <20090325183011.GN32307@mit.edu>
	 <20090401210337.GB3797@csclub.uwaterloo.ca>
	 <20090402110532.GA5132@aniel>
	 <72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com>
	 <20090402094247.9d7ac19f.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0904020947310.4130@localhost.localdomain>
	 <alpine.LFD.2.00.0904020959490.4130@localhost.localdomain>
	 <49D53787.9060503@garzik.org>
	 <alpine.LFD.2.00.0904021516540.4130@localhost.localdomain>
	 <49D56DF6.5020300@garzik.org>
Date: Thu, 2 Apr 2009 20:38:59 -0600
Message-ID: <9b1675090904021938q6600bb94m2f9fa1b23316162a@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 8:01 PM, Jeff Garzik <jeff@garzik.org> wrote:
> Linus Torvalds wrote:
> The most interesting thing I found:  the SSD does 80 MB/s for the first ~1
> GB or so, then slows down dramatically.  After ~2GB, it is down to 32 MB/s.
>  After ~4GB, it reaches a steady speed around 23 MB/s.

Isn't that the kernel IO queue, and the dd averaging of transfer
speed?  For example, once you hit the dirty ratio limit, that is when
it starts writing to disk.  So, the first bit you'll see really fast
speeds, as it goes to memory, but it averages out over time to a
slower speed.  As an example...

tdamac ~ # dd if=/dev/zero of=/tmp/bigfile bs=1M count=1
1+0 records in
1+0 records out
1048576 bytes (1.0 MB) copied, 0.00489853 s, 214 MB/s

tdamac ~ # dd if=/dev/zero of=/tmp/bigfile bs=1M count=10
10+0 records in
10+0 records out
10485760 bytes (10 MB) copied, 0.242217 s, 43.3 MB/s

Those are with /proc/sys/vm/dirty_bytes set to 1M...
echo $((1024*1024*1)) > /proc/sys/vm/dirty_bytes

It's probably better to set it much higher though.
