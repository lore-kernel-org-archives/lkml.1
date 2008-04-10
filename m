Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbYDJTR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbYDJTR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 15:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbYDJTRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 15:17:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:58138 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbYDJTRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 15:17:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EB8YgvHKDd0NmLR1a/T/cDkyI+8K9Ajp7ZHCptTxw73jwFckf/XBJc+KU84eVGpqhQZfiKfNjHe52axVViedRx9x6aMjUFZP4WWoVN6z23Mo1WjpIDgvxaQxusNZB7ZJsxoG/eYUy1Px9QXldm2wUBCtJdkzh/dk975gmlNJfmE=
Message-ID: <cfd18e0f0804101217v4231a0a6pbbcbb980e624256d@mail.gmail.com>
Date: Thu, 10 Apr 2008 21:17:16 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch] signalfd fix for incorrect SI_QUEUE user data reporting
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0804101152090.9668@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0804101152090.9668@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 8:57 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> Michael Kerrisk found out that signalfd was not reporting back user data
> pushed using sigqueue:
>
> http://groups.google.com/group/linux.kernel/msg/9397cab8551e3123
>
> The following patch makes signalfd to report back the ssi_ptr and ssi_int
> members of the signalfd_siginfo structure.
>
>
>
> Signed-off-by: Davide Libenzi <davidel@xmailserver.org>

Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>

>
> ---
>  fs/signalfd.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> Index: linux-2.6.mod/fs/signalfd.c
> ===================================================================
> --- linux-2.6.mod.orig/fs/signalfd.c    2008-04-09 11:53:37.000000000 -0700
> +++ linux-2.6.mod/fs/signalfd.c 2008-04-09 12:05:46.000000000 -0700
> @@ -111,9 +111,14 @@
>                err |= __put_user(kinfo->si_uid, &uinfo->ssi_uid);
>                err |= __put_user((long) kinfo->si_ptr, &uinfo->ssi_ptr);
>                break;
> -       default: /* this is just in case for now ... */
> +       default:
> +               /*
> +                * This case catches also the signals queued by sigqueue().
> +                */
>                err |= __put_user(kinfo->si_pid, &uinfo->ssi_pid);
>                err |= __put_user(kinfo->si_uid, &uinfo->ssi_uid);
> +               err |= __put_user((long) kinfo->si_ptr, &uinfo->ssi_ptr);
> +               err |= __put_user(kinfo->si_int, &uinfo->ssi_int);
>                break;
>        }
>
>



-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug? Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html
