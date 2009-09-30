Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbZI3Ffc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbZI3Ffc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 01:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZI3Ffb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 01:35:31 -0400
Received: from mail-qy0-f174.google.com ([209.85.221.174]:62823 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbZI3Ffa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 01:35:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v7Dz9Ds6pU5wmCZJw7/ysQ+WHi3e6jOecUQ7jtHmj+8EFJ1mxsa09cTKyhTro7Fh4J
         scTL0XntIJ+fleHFKoPZe9YyGxMidzI2JE8ucFVmLb36uWsz3J76ieVWnieMwZSOE8SP
         t5d/Sc+b/E+fGwIeLZiXRMvoeijLTuXYFFhAM=
MIME-Version: 1.0
In-Reply-To: <1254133004-24877-1-git-send-email-21cnbao@gmail.com>
References: <1254133004-24877-1-git-send-email-21cnbao@gmail.com>
Date: Wed, 30 Sep 2009 13:35:34 +0800
Message-ID: <2375c9f90909292235p7c21776aodd855a4ffa82afa8@mail.gmail.com>
Subject: Re: [PATCH] Fix half-Y2K38 problem in timecompare_update while 
	calculating offset
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, davem@davemloft.net, patrick.ohly@intel.com,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 6:16 PM, Barry Song <21cnbao@gmail.com> wrote:
> ktime will overflow from 03:14:07 UTC on Tuesday, 19 January 2038,
> ktime_add() in timecompare_update() will overflow a half earlier.
> As a result, wrong offset will be gotten, then cause some strange
> problems.
> ---
>  kernel/time/timecompare.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/time/timecompare.c b/kernel/time/timecompare.c
> index 71e7f1a..d2d893e 100644
> --- a/kernel/time/timecompare.c
> +++ b/kernel/time/timecompare.c
> @@ -89,7 +89,7 @@ int timecompare_offset(struct timecompare *sync,
>                         * source time
>                         */
>                        sample.offset =
> -                               ktime_to_ns(ktime_add(end, start)) / 2 -
> +                               (ktime_to_ns(end) + ktime_to_ns(start)) / 2 -
>                                ts;
>
>                        /* simple insertion sort based on duration */

Just please add your Signed-off-by.

I think you catch the right thing, so

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Add Cc: Thomas Gleixner <tglx@linutronix.de>.
