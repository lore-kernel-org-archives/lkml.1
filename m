Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbYJ3BYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbYJ3BYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 21:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbYJ3BYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 21:24:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:39882 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbYJ3BYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 21:24:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=twfdhtHg4EwfF51BRkMrSUaUy9YL/JqFWcHAOAuxHtJVulHYMjXQFKRjMYSJab7XXZ
         sPTxUR7kshGyfDAt9w7Wq9mRTSlycWm1lw61Pl2jDGKK8xkUWEu9OrM3pE24389sl4Vl
         Y1QXkvcsLsRJ8LR3UVEMkAKN1AsKHBI3Ih0zQ=
Message-ID: <f7848160810291824s3770257dye6b130d901920164@mail.gmail.com>
Date: Wed, 29 Oct 2008 21:24:22 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Stale NFS File Handle but !NFS
Cc: linux-kernel@vger.kernel.org, "Christoph Hellwig" <hch@lst.de>
In-Reply-To: <20081029175643.ad0f1dca.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f7848160810231458tea58cf7x362ad03743b564ed@mail.gmail.com>
	 <20081029175643.ad0f1dca.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 8:56 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 23 Oct 2008 17:58:34 -0400
> "Parag Warudkar" <parag.lkml@gmail.com> wrote:
>
>> Anyone got an idea why I am getting the below error with today's git
>> while compiling the kernel?
>>
>>   LD      arch/x86/vdso/built-in.o
>> scripts/Makefile.build:373: net/netfilter/.xt_mac.o.cmd: Stale NFS file handle
>> make[2]: stat: net/netfilter/.xt_mac.o.cmd: Stale NFS file handle
>> make[2]: *** No rule to make target `net/netfilter/.xt_mac.o.cmd'.  Stop.
>> make[1]: *** [net/netfilter] Error 2
>> make: *** [net] Error 2
>> parag@parag-desktop:~/kernel-dev/linux-2.6-wk$ rm net/netfilter/.xt_mac.o.cmd
>> rm: cannot remove `net/netfilter/.xt_mac.o.cmd': Stale NFS file handle
>> parag@parag-desktop:~/kernel-dev/linux-2.6-wk$ sudo rm
>> net/netfilter/.xt_mac.o.cmd
>>
>> Even trying 'sudo rm -f' on that file gives the same error.
>>
>> I am not using NFS at all which makes this one sound weird!
>>
>
> Is this still happening?
>
> If so, I'd be looking at that new `return ERR_PTR(-ESTALE)' in
> d_obtain_alias().

To fix it I had to fsck.ext3 - which reported/corrected unused/deleted
inode errors relating to that file.
Since make -j4 was involved in this, sounds like a race some where?

Since then I have booted the same machine with latest git 4-5 times
and compiled a few kernels - nothing bad has happened till now.

Will continue to test newer kernels since I still have few days before
I load this machine with useful data.

Parag
