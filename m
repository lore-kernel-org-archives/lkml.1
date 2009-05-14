Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbZENLEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbZENLEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 07:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbZENLEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 07:04:15 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:55913 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbZENLEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 07:04:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EfqeZ7nzMW5ianrVCMt0kElJMjLjfxzmDIZnRXBpug80YET4CJed5K+aEnA1MBReaF
         FDhq3ebS11rVxkM/eDFzb+nxI727Z/qx2S2gL6KQIeEguW7pfjhCtOlozhvGG6cc73Ph
         HEuqBsBJ3anq75mIVQABh0FH2eBy0xoEC/NdA=
MIME-Version: 1.0
In-Reply-To: <4A09AFD1.5090604@suse.com>
References: <a4423d670905120940r5de3eab7v7e8e92d89107b962@mail.gmail.com>
	 <4A09AFD1.5090604@suse.com>
Date: Thu, 14 May 2009 15:04:13 +0400
Message-ID: <a4423d670905140404n719f21f3jd841bf6fed3fd7be@mail.gmail.com>
Subject: Re: 2.6.30-rc5: reiserfs is broken on parisc (bisected)
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-parisc@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       reiserfs-devel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/12 Jeff Mahoney <jeffm@suse.com>:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Alexander Beregalov wrote:
>> Hi
>>
>> ab17c4f02156c4f75d7fa43a5aa2a7f942d47201 is the first bad commit
>> (reiserfs: fixup xattr_root caching)
>>
>> Kernel panics when init tries to remount rootfs (reiserfs) with
>> read-write access.
>> Read-only access works fine.
>>
>> No more messages on the screen before panic.
>>
>> Is it endianess related?
>
> No, not at all. There was a problem with the xattr code if the kernel
> was built with xattrs disabled. It assumed that
> REISERFS_SB(s)->xattr_root would be available, which isn't the case when
> xattrs aren't enabled. Part of it has been cleaned up in -git1, and I've
> sent Al some additional patches to fix the rest of it up.
>
> There's a thread called "reiserfs xattr fixups" that contains 4 patches.
> The patch marked with * is the one I believe will fix your problem.
>
> - - reiserfs: cleanup ifdefs
> - - reiserfs: deal with NULL xattr root w/ xattrs disabled *
> - - reiserfs: fixup perms when xattrs are disabled
> - - reiserfs: allow exposing privroot w/ xattrs enabled
>
It works!
Thanks Jeff.
