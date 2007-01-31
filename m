Return-Path: <linux-kernel-owner+w=401wt.eu-S932480AbXAaJI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbXAaJI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 04:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932461AbXAaJI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 04:08:28 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:3981 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437AbXAaJI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 04:08:26 -0500
Message-ID: <45C05F1C.30609@sw.ru>
Date: Wed, 31 Jan 2007 12:19:24 +0300
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jeff Layton <jlayton@redhat.com>, Bodo Eggert <7eggert@gmx.de>,
       akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH] pipefs unique inode numbers
References: <Pine.LNX.4.58.0701302314210.2203@be1.lrz> <45BFEE85.30203@redhat.com> <Pine.LNX.4.64.0701301726280.3611@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0701301726280.3611@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

>>Also, that patch would break many 32-bit programs not compiled with large
>>offsets when run in compatibility mode on a 64-bit kernel. If they were to
>>do a stat on this inode, it would likely generate an EOVERFLOW error since
>>the pointer address would probably not fit in a 32 bit field.
>>
>>That problem was the whole impetus for this set of patches.
> 
> 
> Well, we have that problem with the slowly incrementing "last_ino" too.
> 
> Should we make "last_ino" be "static unsigned int" instead of "long"?
yes. it is what the 1st patch (AFAIK commited to -mm) from Jeff.

> Does anybody actually even use the old stat() with 32-bit interfaces? We 
> warn for it, and we've done so for a long time.. I dont' remember people 
> even complaining about the warning, so..
Yes, we saw this happening multiple times already.
e.g. many OpenVZ users run 32bit VEs on 64bit host OS.
due to this bug some apps (e.g. postfix) complain about EOVERFLOW returned by stat()
and fail to work.
I also observed similar bug on Debian 3.0 which has 'find' compiled w/o FILE_OFFSETS=64,
but NFS partition used 64bit inode numbers.

Thanks,
Kirill
