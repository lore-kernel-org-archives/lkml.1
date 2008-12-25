Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbYLYSSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbYLYSSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 13:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755342AbYLYSRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 13:17:33 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:58666 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbYLYSRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 13:17:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Fy5eqbSZmx6LvORHsHt1/n14dp1WKA8RbNSB1Hvvf5e+iIBK3NhGuW9Lw7buXQqRhH
         F9UWzrwO5vwxxmtlD6cYcXM7CxqoLZa3YtPStreHVrgA4jCQQeiNRVBF/C0IsZFhu5qp
         YJyuQxOJkMQdrsISVyljchVl+mTAcWM62srn0=
Message-ID: <c6d9bea0812251017u6a271fc0j5d26b8bbe3407877@mail.gmail.com>
Date: Thu, 25 Dec 2008 13:17:28 -0500
From: "C. Scott Ananian" <cscott@laptop.org>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [RFC PATCH -v4 00/14] fsnotify, dnotify, and inotify
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, "Eric Paris" <eparis@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081222232125.GA25334@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
	 <c6d9bea0812181536p2a3aaeacmbd6af0474279b7b@mail.gmail.com>
	 <1229916126.29604.47.camel@localhost.localdomain>
	 <c6d9bea0812221159h30b0501dm8f48d93e0cb53bfa@mail.gmail.com>
	 <20081222210410.GL28946@ZenIV.linux.org.uk>
	 <c6d9bea0812221508n75f03ebdsff5bcbabe56eae56@mail.gmail.com>
	 <20081222232125.GA25334@infradead.org>
X-Google-Sender-Auth: 274d674ec1eb3b6d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2008 at 6:21 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Dec 22, 2008 at 06:08:08PM -0500, C. Scott Ananian wrote:
>> That's not correct, as /proc/self/fd/<num> and the getcwd syscall make
>> clear.
>
> No.  These take a file descriptor into account, which _does_ have a
> unique path.

getcwd doesn't actually hold a file descriptor to the working
directory.  If you reread my message, you'll find that I was explicit
about where the information was stored.

>> struct inode has a i_dentry member, and via its d_parent links
>> you can reconstruct the path, as __d_path in fs/dcache.c does.
>
> reconstruct _a_ path inside the same filesystem, ignoring which link is
> wanted, and inside which mount.

Right.  If you go back and reread my message, I made clear that that
was sufficient.

But Al's question is more relevant, and I'll try to restate the
problem for him, since it's clear that none of the existing *notify
interfaces was written with an eye towards making possible races
easily manageable.
  --scott

-- 
                         ( http://cscott.net/ )
