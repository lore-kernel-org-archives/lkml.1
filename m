Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab0CDDA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:00:28 -0500
Received: from mail-qy0-f172.google.com ([209.85.221.172]:56312 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab0CDDAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:00:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U3H4eq+O0CLAIFSos8wZCLtHKUhrCzzLI/AEkdlrCJ90RZclzggpPaUo5d7Nc5oISa
         /sqDFXRl2Gc0akh8JzLKOWD63ZxtGBGcyFPsZvWSbkHh2RjM5WqXc92TzdVfJGvQGPrQ
         pbqiJ3e16rK/wHFtlplSNAkW0TQVvcQ9E5E9c=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.1002232249440.28195@bogon.housecafe.de>
References: <dda83e781002141023t2abe95b8w83f59d6f411f68a2@mail.gmail.com>
	 <alpine.DEB.2.01.1002142229470.28195@bogon.housecafe.de>
	 <dda83e781002232131i53b59c8eu7192257fc4e4f3e0@mail.gmail.com>
	 <alpine.DEB.2.01.1002232249440.28195@bogon.housecafe.de>
Date: Wed, 3 Mar 2010 19:00:24 -0800
Message-ID: <dda83e781003031900x3ca243d9kba1df3a8b0e04105@mail.gmail.com>
Subject: Re: reiserfs issue with 2.6.32.8
From: Bret Towe <magnade@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       reiserfs-devel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 11:03 PM, Christian Kujau <lists@nerdbynature.de> wrote:
> On Tue, 23 Feb 2010 at 21:31, Bret Towe wrote:
>> ok attached is strace log of cp on 2.6.32.9
>
> I've run cp through strace as well (copying something from an XFS
> partition to a reiserfs partition, I guess that's what you did too), and
> noticed a small difference at the end:
>
> < open("/home/foo/1", O_RDONLY)          = 3
> < fstat(3, {st_mode=S_IFREG|0640, st_size=755, ...}) = 0
> < open("2", O_WRONLY|O_CREAT|O_EXCL, 0640) = 4
>
> While your cp(1) did:
>
>> open("downloads/[DB]_Bleach_258_[27104F7A].avi", O_RDONLY) = 3
>> fstat(3, {st_mode=S_IFREG|0644, st_size=178308328, ...}) = 0
>> open("/mdhd/media/Episodes/unwatched/[DB]_Bleach_258_[27104F7A].avi", O_WRONLY|O_CREAT|O_EXCL, 0644) = -1 EINVAL (Invalid argument)
>
>
> And open(2) will return -EINVAL when:
>   - The implementation does not support synchronised I/O for this file.
>   - The value of the oflag argument is not valid.
>
> As we're not passing O_SYNC, it's the latter, if I read this correctly. Which
> still doesn't explain *why* (the filesystem?) returns "invalid flag".
>
>> now I've had a hd drop out of raid (running checks on it atm)
>
> Hm, maybe it's all hardware related after all, let's see what these checks
> turn up. Strange though, that nothing gets reported in dmesg...

well the hardware update ended up changing more than I thought it would
now on 32bit from 64bit so config is completely new also for the kernel
end result tho is I'm on a 2.6.33 kernel and no issues
