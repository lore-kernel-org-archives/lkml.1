Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab0BCQGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:06:01 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:60257 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375Ab0BCQF7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:05:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LIbr72eB8TgAOmp9Q1CQa0PhjbrDnf1Xu3ngLk5n66LbGrzAnUzHC9zh6bwTyMlCa8
         pXOszrlBages01jl/UR+k1sz9JzZVrvAQE1YPysNiHWRySIodg7EYxJ3h7YK9gNQorsR
         LyHItf2LaIMUSPIk4OOanNEBi/3OwCp9Pvwic=
MIME-Version: 1.0
In-Reply-To: <1265043026-24987-4-git-send-email-dvhltc@us.ibm.com>
References: <1265043026-24987-1-git-send-email-dvhltc@us.ibm.com>
	 <1265043026-24987-4-git-send-email-dvhltc@us.ibm.com>
Date: Wed, 3 Feb 2010 17:05:58 +0100
X-Google-Sender-Auth: 7e419606b7f5cb1a
Message-ID: <520f0cf11002030805q35029925u36f544f7d37faedb@mail.gmail.com>
Subject: Re: [PATCH 3/3] kernel-shark: fix unitialized handle compile warnings
From: John Kacur <jkacur@redhat.com>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 1, 2010 at 5:50 PM, Darren Hart <dvhltc@us.ibm.com> wrote:
> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> ---
>  kernel-shark.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/kernel-shark.c b/kernel-shark.c
> index 9dedf48..222381c 100644
> --- a/kernel-shark.c
> +++ b/kernel-shark.c
> @@ -596,10 +596,10 @@ void kernel_shark(int argc, char **argv)
>                if (ret >= 0)
>                        input_file = default_input_file;
>        }
> -       if (handle)
> -               handle = tracecmd_open(input_file);
> +       handle = tracecmd_open(input_file);
>
> -       info->handle = handle;
> +       if (handle)
> +               info->handle = handle;
>
>        /* --- Main window --- */
>
> --

This looks correct, but I'm wondering if it is safe to continue if the
call to tracecmd_open fails?
