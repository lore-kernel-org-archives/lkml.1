Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbYETNui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbYETNui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 09:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYETNu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 09:50:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:18933 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbYETNu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 09:50:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dH+sfPmX6PFqonYDD8fHBb7uBd8ecNMEf5HqyoqlGnSR07sexe6CejUaICBtb2K2k9r9fkrRjIIU4ex2GeQQl8dkQledANU809rz6UWQdMnuK0OXfBGqZ6GKvvNMt+EcTHK4m2XilzNlICNtOyQmGxuABb4XnzLRlvujHpKfbI8=
Message-ID: <7b9198260805200650g70ffbcd2p21e10a6b600cadd1@mail.gmail.com>
Date: Tue, 20 May 2008 14:50:26 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH] Introduce filesystem type tracking
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080520134306.GA28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1211196126-7442-1-git-send-email-tspink@gmail.com>
	 <7b9198260805200606u6ebc2681o8af7a8eebc1cb96@mail.gmail.com>
	 <20080520134306.GA28946@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/20 Al Viro <viro@zeniv.linux.org.uk>:
> On Tue, May 20, 2008 at 02:06:42PM +0100, Tom Spink wrote:
> [snip]
>
>> I'm just adding people to CC here, but also I had a couple of thoughts
>> after reviewing my own code.
>>
>> I see that do_kern_mount is encapsulated with the BKL, but would it be
>> wise to introduce a lock (e.g. a mutex) now for reading and updating
>> nr_mounts (and hence calling ->init), rather than wait for the BKL
>> removal to come round here?
>>
>> Also, have I got all the cases where a filesystem is unmounted,
>> because I now see umount_tree, and am wondering if decrementing the
>> nr_mounts field should be done in here, in the loop of vfsmounts... or
>> is it sufficient to leave it at the end of do_umount?

Hi Al,

> No, you have not and no, doing that anywhere near that layer is hopeless.
>
>        a) Instances of filesystem can easily outlive all vfsmounts,
> let alone their attachment to namespaces.

I see!  Whoops...

>        b) What should happen if init is done in the middle of exit?

Okay, I guess *some* sort of locking is in order. :)

>        c) Why do we need to bother, anyway?

Well, just for the reason I mentioned, I saw the posting about XFS
starting threads (when compiled into the kernel), but there's no use
of an XFS filesystem at all - there was a suggestion that something
like this be tried, so I thought I'd give it a go.

Thanks for replying!

-- 
Regards,
Tom Spink
