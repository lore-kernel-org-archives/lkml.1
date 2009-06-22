Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbZFVSLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbZFVSLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbZFVSLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:11:14 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:59763 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbZFVSLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:11:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hKHWQkKA+ZtJ0zHmX9pLa8pVh46AZQu0kERArMgnSGa228oNUQt9wGnWcbGQWZMB2n
         faPguRpMGfAJoCip6U15PlW0jGHo7Et9+9XJHV08ghx/8tI2wIsmJVSJ6zV0zs0nBNtG
         Eh2Bncs4tx/haDYCXQB8R6J8Baf6ik0hHlT6c=
Message-ID: <4A3FC84A.6060608@gmail.com>
Date: Mon, 22 Jun 2009 20:07:06 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Tim Bird <tim.bird@am.sony.com>, Jamie Lokier <jamie@shareable.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
References: <4A33A7A2.1050608@gmail.com> <20090613155957.GA16220@shareable.org> <4A34A394.5040509@gmail.com> <20090621064040.GC1656@ucw.cz> <4A3E6F28.4090404@gmail.com> <20090621205245.GC3254@elf.ucw.cz> <2ea1731b0906212333r20deb71q2f021fc79bcc8a8e@mail.gmail.com> <20090622172003.GB21149@elf.ucw.cz> <4A3FBFF0.40006@am.sony.com> <20090622173704.GC21299@elf.ucw.cz>
In-Reply-To: <20090622173704.GC21299@elf.ucw.cz>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Mon 2009-06-22 10:31:28, Tim Bird wrote:
>> Pavel Machek wrote:
>>>>> How do you handle hard-links, then?
>>>> Indeed hard-links are not supported :) Due to the design of this fs
>>>> there are some limitations explained in the documentation as not
>>>> hard-link, only private memory mapping and so on. However this
>>>> limitations don't limit the fs itself because you must consider the
>>>> special goal of this fs.
>>> I did not see that in the changelog. If it is not general purpose
>>> filesystem, it is lot less interesting.
>> PRAMFS is not a general purpose filesystem. Please read
>> the introductory post to this thread, or look at
>> http://pramfs.sourceforge.net/ for more information.
> 
> Yeah, I seen that. It directly contradicts what you say.
> 

I don't think, I think it's very clear:

"In summary, PRAMFS is a light-weight, full-featured, and
space-efficient special filesystem that is ideal for systems with a
block of fast non-volatile RAM that need to access data on it using a
standard filesytem interface."


>> Since the purpose of PRAMFS is to provide a filesystem
>> that is persistent across kernel instantions, it is not
>> designed for high speed.  Robustness in the face of
>> kernel crashes or bugs is the highest priority, so
>> PRAMFS has significant overhead to make the window
>> of writability to the filesystem RAM as small as possible.
> 
> Really? So why don't you use well known, reliable fs like ext3?
> 
>> This is not a file system one would do kernel compiles on.
>> This is where someone would keep a small amount of sensitive
>> data, or crash logs that one needed to preserve over kernel
>> invocations.
> 
> Really? Web page says:
> 
> #2. If the backing-store RAM is comparable in access speed to system
> #memory, there's really no point in caching the file I/O data in the
> #page cache. Better to move file data directly between the user buffers
> #and the backing store RAM, i.e. use direct I/O. This prevents the
> #unnecessary 
> 
> So you don't cache it "because its fast", and then it is 13MB/sec?
> 
> 									Pavel
