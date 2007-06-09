Return-Path: <linux-kernel-owner+w=401wt.eu-S1760758AbXFIUJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758AbXFIUJQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 16:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759329AbXFIUJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 16:09:00 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:59531 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759006AbXFIUI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 16:08:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b3J7IX156m1EstkVtUSWyLX2ILpbyfSYLVuUyFO/yMuCHhagunOUzxtwOlsBlSzVZ8PJG8Nh7baMiEGzanhh9kLHQS/W7VM31+eOEU6sTp+IUxejEvEJKUPe17/fc+EbKj+N/R8/ZbUBoZEV3mDEBthkXWq96zl+41aYF5MH8gE=
Message-ID: <9a8748490706091308s47327bdet90e3f4b1a0df6330@mail.gmail.com>
Date: Sat, 9 Jun 2007 22:08:58 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: Rules on how to use sysfs in userspace programs
Cc: linux-kernel@vger.kernel.org, "Kay Sievers" <kay.sievers@vrfy.org>
In-Reply-To: <20070608203637.GA9259@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070608203637.GA9259@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/07, Greg KH <greg@kroah.com> wrote:
> Over time there have been a number of problems when sysfs has changed in
> "unexpected" ways.  Here's a document that Kay wrote a while ago that
> I'd like to add to the kernel Documentation directory to help userspace
> programmers out.
>
> Any comments or critique of this is greatly appreciated.
>

Don't forget to update Documentation/00-INDEX when you add the document :-)

More comments below.

> thanks,
>
> greg k-h
>
> ------------------------------------
>
> Rules to access device-information in the Linux kernel sysfs
>
"Rules on how to access..." perhaps?

> The kernel exported sysfs exports internal kernel implementation-details
> and depends on internal kernel-structures and layout. It is agreed upon
> kernel developers, that the Linux kernel does not provide a stable

You write "It is agreed upon kernel developers..." I would write "It
is agreed upon by the kernel developers..."

> internal API.  As sysfs is a direct export of kernel internal
> structures, the sysfs interface can't provide a stable interface too, it

Shouldn't that be "can't provide a stable interface either" ?

> may always change along with internal kernel changes.
>
> To minimize the risk of breaking users of sysfs, which are in most cases
> low-level userspace applications, with a new kernel release, the users
> of sysfs must follow some rules to use an abstract-as-possible way to

You write "to use an abstract-as-possible way to" I would have written
"to use an as abstract-as-possible way to"

> access this filesystem.  The current udev and HAL programs already
> implement this and users are encouraged to plug, if possible, into the
> abstractions these both programs provide instead of accessing sysfs

shouldn't that be "both these" not "these both" ?

> directly.
>
> But if you really do want to access sysfs, please follow the following
> rules and then your programs should work for all future versions of
> sysfs.
>
[snip]
>
> - Properties of parent devices never belong into a child device.
>   Always look at the parent devices themselves for determining device
>   context properties. If the device 'eth0' or 'sda' does not have a
>   "driver"-link, then it does not have a driver. It's value is empty.

"it's" is short for "it is", not the same as "its" which I believe is
what you want here.

>   Never copy the value of the parent-device into a child-device. Parent
>   device-properties may change dynamically without any notice to the
>   child device.
>
> - Hierarchy in a single device-tree
>   There is only one valid place in sysfs where hierarchy can be examined
>   and this is below: /sys/devices.
>   It is planned, the all device directories will end up in the tree

Don't you mean "that all device..." ?

>   below this directory.
>
> - Classification by subsystem
>   There are currently three places for classification of devices:
>   /sys/block, /sys/class and /sys/bus. It is planned, that these will
>   not contain any device-directories themselves, but only flat lists of
>   symlinks pointing to the unified /sys/devices tree.
>
>   All three places have completely different rules to access the

I believe that should be "rules on how to access the".

>   information.  It is planned to merge all three
>   classification-directories into one place at /sys/subsystem/,
>   following the current layout of the bus-directories. All buses and
>   classes, including the converted block-subsystemm, will show up
>   there.
>   The devices of a subsystem will create a symlink in the "devices"
>   directory at /sys/subsystem/<name>/devices/.
>
[snip]

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
