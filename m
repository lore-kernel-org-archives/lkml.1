Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbZGGOGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbZGGOGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbZGGOFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:05:55 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:35245 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048AbZGGOFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:05:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Uz65/gyopdnyKdcUR1YiDtNTCOeGzPSbzW3QXKoPDOL9BsqRrMYSxpB40NNqhx2Fxv
         XrwP7M9XiSJilM72u+rvmKTg6yWEDnbhme7c7fqFwE+vnhal4LWfjvkbAJneqA4uBEb9
         ov4RWBXqvjumlGpUFyNP5fjGVrJ/FREi6A+Sc=
MIME-Version: 1.0
In-Reply-To: <a5d9929e0907011336g31599a29hca3c204f1b53b775@mail.gmail.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
	 <5Hhc7UkUKEO.A.5zE.DjASKB@chimera>
	 <a5d9929e0907011336g31599a29hca3c204f1b53b775@mail.gmail.com>
Date: Tue, 7 Jul 2009 22:05:52 +0800
Message-ID: <2375c9f90907070705p1ae6ebe4x61bda34dd072c1c@mail.gmail.com>
Subject: Re: [Bug #13660] Crashes during boot on 2.6.30 / 2.6.31-rc, random 
	programs
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Joao Correia <joaomiguelcorreia@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 4:36 AM, Joao Correia<joaomiguelcorreia@gmail.com> wrote:
> No formal patch has been sent yet, that i am aware of. I have made
> some changes following suggestion by Americo Wang advise, to the
> following:
>
> (patch by Ingo)
>
> diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
> index 699a2ac..031f4c6 100644
> --- a/kernel/lockdep_internals.h
> +++ b/kernel/lockdep_internals.h
> @@ -65,7 +65,7 @@ enum {
>  * Stack-trace: tightly packed array of stack backtrace
>  * addresses. Protected by the hash_lock.
>  */
> -#define MAX_STACK_TRACE_ENTRIES        262144UL
> +#define MAX_STACK_TRACE_ENTRIES        1048576UL
>
>  extern struct list_head all_lock_classes;
>  extern struct lock_chain lock_chains[];
>
> and afterwards, a new bug popped up, solved by changing
>
> include/linux/sched.h
>
> # define MAX_LOCK_DEPTH 48UL
>
> to
>
> # define MAX_LOCK_DEPTH 96UL
>
>
> I have now found a third limit bug, related to MAX_LOCKDEP_CHAINS,
> which was hidden so far, which im trying to raise and replicate. This
> is being discussed in detail in another message exchange on the lkml,
> between me and Americo.

How about changing MAX_LOCKDEP_CHAINS_BITS to 16?

kernel/lockdep_internals.h:59:#define MAX_LOCKDEP_CHAINS_BITS	15

And can you make a complete patch and send it to lkml with Peter and me
Cc'ed?

Thank you!
