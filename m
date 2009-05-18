Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbZERHGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbZERHGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755643AbZERHGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:06:32 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:8292 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbZERHGb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:06:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q0W2P4vLEDYpFtL+R6jf5CBdBG1rLiP8rP9qkpx88yx1zzETgtdTsudK0vZu3fUlcW
         lO0OMyCyVwitDVBTBa75NcAFs+lqdBH0sLymnn6XMSurZiLNuP4AI2lba4JKQdJL1kSs
         UmP9MMMkEpu3AP6hgmfMlKI/JybLGQdtYMHJc=
MIME-Version: 1.0
In-Reply-To: <de72ca4e0905172314q3c55ec52ic9ab762a0352a91d@mail.gmail.com>
References: <de72ca4e0905172314q3c55ec52ic9ab762a0352a91d@mail.gmail.com>
Date: Mon, 18 May 2009 12:36:32 +0530
Message-ID: <de72ca4e0905180006m6c4456c3h96750fe39e7f8379@mail.gmail.com>
Subject: Re: linux-kernel@vger.kernel.org
From: Sudarshan Soma <sudarshan12s@gmail.com>
To: Sudarshan Soma <sudarshan12s@gmail.com>,
       Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like i can't call exit(-1)in signal handlers as its
Asynchronous—signal-safe function. As my application wont register any
exit handler functions, is this safe to use??

Please suggest if there are better alternatives.

On Mon, May 18, 2009 at 11:44 AM, Sudarshan Soma <sudarshan12s@gmail.com> wrote:
> --- On Sat, 16/5/09, Robert Hancock <hancockrwd@gmail.com> wrote:
>
>
>    From: Robert Hancock <hancockrwd@gmail.com>
>    Subject: Re: patch related to SIGSEGV handling in multiple threads
> and hung threads
>    To: "Sudarshan Soma" <sudarshan12s@gmail.com>
>    Cc: linux-kernel@vger.kernel.org
>    Date: Saturday, 16 May, 2009, 6:45 AM
>
>    Sudarshan Soma wrote:
>    > Hi ,
>    > I have a program which will create multiple threads. One of the thread
>    > receives SIGSEGV and it prints stacktrace in its handler and calls
>    > _exit(-1). The call to exit wont terminate all threads in  a process
>    > and hence thread hangs here. This causes resouce leaks and other
>    > problems. It is seen only on linux 2.4.20.
>    >
>    > For printing stacktrace it uses
>    > __builtin_return_address and __builtin_frame_address
>    >
>    >
>    > The same program works fine on linux 2.6.26 kernel. It  will exit the
>    > whole process when one of its thread dies as above.
>    >
>    >
>    > Please let me know the patch details or any workaround, if any. This
>    > is a bit urgent, so please let me know for any pointers , if any
>    >
>    > Thanks and Best Regards,
>    > Pavan.
>
> [Robert]
>    That doesn't seem surprising, the old LinuxThreads thread
> implementation normally used with the 2.4 kernels was pretty poor.
> However it would likely be better to re-raise the signal rather than
> trying to exit out of the signal handler.
>
>
> [Pavan]
> Thanks Robert.
> using exit(-1) instead of exit(0) does terminate all the threads in
> the process in my sample program.  Please suggest if this workaround
> is safe for now.
>
> I would like to kill whole process(and its threads) when one of the
> thread gets SIGSEGV signal. Could you please eloborate , how could i
> achieve the same by raising SIGSEGV signal again..
>
> Best Regards,
> Pavan.
>
