Return-Path: <linux-kernel-owner+w=401wt.eu-S1758451AbZJFXES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbZJFXES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 19:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbZJFXES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 19:04:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:35266 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbZJFXER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 19:04:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tjOHrxutz0ppO8bSgUEKlc0ug6XQEiIDbFQ+uBWT7FrbynUuHIghfjV4FGPGptdiXn
         ePg51F5OhVsDa7yQxqWRzmV4D2VCi37s9aifAgKNPU56YDPrTci+eCsm+F3H6L6W7c6a
         mTGdKGjYeiNgiXSvka4uwvH8tQCXNOtZXgth0=
Subject: Re: Massive ext4 filesystem corruption after a failed s2disk/ram
 cycle
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20091006214214.GC17883@mit.edu>
References: <1254863215.11577.23.camel@maxim-laptop>
	 <20091006214214.GC17883@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Oct 2009 01:02:25 +0200
Message-Id: <1254870145.11561.8.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 17:42 -0400, Theodore Tso wrote: 
> On Tue, Oct 06, 2009 at 11:06:55PM +0200, Maxim Levitsky wrote:
> > 
> > Just prior to 2.6.32 cycle I tried -next tree and noticed that after a
> > failed s2ram (here it works only once, and I test once in a whileto see
> > if fixed accidentally) I got a minor filesystem corruption. I am sorry I
> > didn't report that back then.
> 
> When you say filesystem corruption, it's important to indicate whether
> you meant that (a) you noticed that some files were had corrupted
> contents, (b) the kernel complained that the filesystem was corrupted,
> and remounted the filesystem read-only, or (c) e2fsck found and fixed
> errors.
> 
> Also, when you found errors of either class (a) or (b), did you run
> e2fsck to find and fix any potential errors?  In a few places it
> sounded like the kernel had complained about errors, but you had
> ignored them and hadn't run e2fsck to fix them.  I hope that was just
> me misunderstanding what you wrote!  Can you clarify?

Sure, kernel noticed errors, and remounted the filesystem R/O (I didn't
write anything down. really sorry)

I had rebooted the system.
Then startup scripts had booted the system to root shell

I had run fsck on the filesystem. It had plenty of files with shared
blocks, many orphaned inodes, errors in free bitmaps.


Then, after the fsck, I got many missing files (many probably went to
lost+found), some had garbage, some became truncated (0 size)

Mostly were affected files that were from recent dpkg update.


I use ubuntu 9.10, and (almost) latest -git of kernel tree.


Best regards,
Maxim Levitsky

