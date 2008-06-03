Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbYFCL1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbYFCL1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 07:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbYFCL1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 07:27:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:13674 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbYFCL1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 07:27:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=weuj0zGXbFqzjWRIqJOQuXSK6FPC/mGkESKfS+PB02znWzJIBrktYQHpdo2yJcOolTR3KP/gYAZXX0mOG7YPBZwgPHS3fsvDqgq0neJ840C/2i9JmiYUYAEhIrwlL/bwl6JQhS6ritAWDfeSNOyHbo9g5cspImf8mN6IdQ6hAoo=
Message-ID: <cfd18e0f0806030427p22a274dev746e1656662f34f6@mail.gmail.com>
Date: Tue, 3 Jun 2008 13:27:42 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] utimensat() non-conformances and fixes [v3]
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, drepper@redhat.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-man@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20080603112221.GW28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <482D4665.4050401@gmail.com>
	 <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu> <48401E7E.9090304@gmail.com>
	 <cfd18e0f0806030405u1c32b114pa0fdd979f36f87fb@mail.gmail.com>
	 <E1K3URo-0005sj-JW@pomaz-ex.szeredi.hu>
	 <20080603112221.GW28946@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2008 at 1:22 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Jun 03, 2008 at 01:13:00PM +0200, Miklos Szeredi wrote:
>> > > I'm not sure of the correct way to get the required nameidata (to do a
>> > > vfs_permission() call) from the file descriptor.  Can you give me a
>> > > tip there?
>> >
>> > Could you point me at the right way of doing this?
>>
>> You don't need nameidata for this at all.  Just call permission() with
>> a NULL nameidata.
>>
>> Ugly API?  Yes, will be cleaned up if we manage to find some common
>> ground with the VFS maintainers.
>
> As soon as I'm done with sysctls...
>
> FWIW, I very much doubt that you are right wrt required permissions, though.
> AFAICS, intent here is "if you can write to file, you can touch the timestamps
> anyway" and having descriptor opened for write gives that, current permissions
> be damned.

The standard is pretty clear on this point:

[[
Only a process with the effective user ID equal to the user ID of the
file, or with write access to the file, or with appropriate privileges
may use futimens( ) or utimensat( ) with a null pointer as the times
argument or with both tv_nsec fields set to the special value
UTIME_NOW.
]]

The crucial words here are "a process ... with write access to the
file" -- in other words, the permissions are determined by the
process's credentials, not by the access mode of the file descriptor.
I was not 100% sure on that to start with, so I did check it out with
one of the folk at The Open Group, to make sure of my understanding.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
