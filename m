Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbZFEOkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbZFEOkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbZFEOko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:40:44 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:36209 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbZFEOkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:40:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=L8+CF3xcPsA7W59VMQnH+pRsZb3qxfPCXGebNzi0FVlcBtJEiy+Y0UVDX4eyztwjwY
         Q4cMpqIUt/XLRMhidE+UP9AshgZH32aFt/XCpVAZ+sBNFop5SCpGkF9QXz49tWBQePaV
         yuv7u9fF6PjbvlOZY7f1E0VvOrWPulwYocOC8=
Message-ID: <4A292E61.3050204@gmail.com>
Date: Fri, 05 Jun 2009 17:40:33 +0300
From: Aioanei Rares <krnl.list@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: linux-ext4@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Mild filesystem corruption on ext4 (no journal)
References: <4A28F83F.4030704@tuffmail.co.uk>
In-Reply-To: <4A28F83F.4030704@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Hi,
>
> I run ext4 without a journal on my cheap netbook with a 4 gig SSD.  I 
> suspect "without a journal" is significant, I don't think I'm doing 
> anything else strange.
>
> When I upgrade libc from 2.7 (debian stable) to 2.9 (debian unstable), 
> the locale breaks every reboot, and I have to repair it by running 
> locale-gen.  This happened now when I only upgraded libc, in order to 
> play with signalfd().  It also happened before, when I upgraded the 
> entire machine to debian unstable (which I later reverted).
>
> The problem is that /usr/lib/locale/locale-archive gets corrupted when 
> I reboot.  The exact corruption differs with each reboot (i.e. the 
> md5sum differs).  Last time, the first ~70K was overwritten with data 
> from xorg.log and my web browsing history.  I have copies of the 
> original and corrupted state which I can send, the full file is 1.3 
> megs, but I can limit it to the first 70K, since that's all that was 
> corrupted.
>
> To try and rule out a faulty userspace program, I marked the file as 
> read-only (chmod a-w) and immutable (chattr +i).  After a reboot, the 
> file was still read-only and immutable, yet it still became corrupted.
>
> Also, I ran md5sum in the shutdown scripts, after mounting the root 
> filesystem read-only (which is also preceeded by a sync in a different 
> script).  This showed that the file did not appear corrupted at this 
> point.  (Though maybe it was ok in page-cache, but corrupted on-disk).
>
> The locale-archive file is read by the libc locale routines using 
> mmap().  The mapping is read only and is not modified.  It seems 
> likely that some process has it mapped when the kernel shuts down.
>
> I tried reproducing this by writting a minimal daemon which maps a 
> copy of the locale-archive file, and starting it just before the 
> filesystem is remounted read-only.  It didn't work though; this copy 
> of the locale-archive file remained uncorrupted.
>
> I forced a fsck on boot, and the filesystem was reported to be clean.  
> I am currently running with e2fsprogs v1.41.6 (from debian unstable), 
> and a custom-built kernel, 2.6.30-rc7.
>
> Thanks in advance!
> Alan
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
I suspect, although I might be wrong, that this is not a kernel-related
problem.
