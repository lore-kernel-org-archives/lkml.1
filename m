Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbXKXUL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbXKXUL6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 15:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbXKXULu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 15:11:50 -0500
Received: from japan.chezphil.org ([77.240.5.4]:3669 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbXKXULt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 15:11:49 -0500
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sat, 24 Nov 2007 20:11:45 +0000
Subject: Re: No error when inotify_add_watch(/an/NFS/file)
Message-ID: <1195935105978@dmwebmail.japan.chezphil.org>
In-Reply-To: <20071124195958.GB12864@fieldses.org>
References: <20071124195958.GB12864@fieldses.org>
X-Mailer: Decimail Webmail 3alpha16
MIME-Version: 1.0
Content-Type: text/plain; format="flowed"
From: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
X-SPF-Guess: pass
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:
> On Fri, Nov 23, 2007 at 11:20:55PM +0000, Phil Endecott wrote:
>> Dear Experts,
>>
>> NFS doesn't work with inotify (and it looks like it can't, certainly not 
>> before NFS v4.1).  However, if I give an NFS filename to 
>> inotify_add_watch(), I don't get an error.
>>
>> If it indicated an error in this case then I could easily fall back to some 
>> sort of polling.  Without an error, I need some other way to detect NFS 
>> (and any other non-inotify-compatible filesystems).
>>
>> Any thoughts?
>
> The one reason I can think of that you might want that behavior is if
> you know you only access a given piece of the filesystem from one client
> at a time, and you still want inotify to work in that situation.

That's a good point.

> (I'm assuming inotify still notifies you of changes that are made on the same
> client.)

A quick test suggest that it does.

> But maybe you could handle that case by allowing inotify_add_watch() in
> the case where the nfs filesystem was mounted with the "nolock" option,
> and failing it otherwise, and telling people to turn on nolock if
> they're sure they know what they're doing.

I'm not sure what your rationale for proposing that is, and I don't 
think it helps in my scenario; a user wants their inotify-using 
application to "just work", not to be told to "sudo re-mount".

I suppose that I just need some way to determine whether I will get 
all, some, or none of the events that I've asked for.


Phil.




