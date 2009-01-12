Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710AbZALGnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbZALGnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 01:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZALGnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 01:43:14 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:48608 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZALGnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 01:43:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IEuX7BmPslcCRk1+3FNCn97D8j2I5DmYtjQ1+l8rWwT/ZLG8QN6xZP1f+C2v7uddfD
         fMolcsuDnOHckn28XzLIgCh0C6wJK+bimgieEdjlIv2EnkX8knBtB8APmhYgclOVb/3R
         TuyvTMZ9ZZdtCdF3MbnJAQL1JI1qhv5zqI+FE=
Message-ID: <ce0170d90901112243y2cd6fee1pc7405cee04a52ecc@mail.gmail.com>
Date: Mon, 12 Jan 2009 03:43:10 -0300
From: "Sergio Luis" <eeeesti@gmail.com>
To: "Rakib Mullick" <rakib.mullick@gmail.com>
Subject: Re: [PATCH] init: Reduce text space by removing a variable.
Cc: "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       akpm@linux-foundation.org
In-Reply-To: <b9df5fa10901112157j449d104fm1a1281a6bef409f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b9df5fa10901112157j449d104fm1a1281a6bef409f9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 2:57 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> Impact: Reduce some text space.
>
> We can carryout the function 'raid_setup' without the variable 'len'
> and using a bit compiler optimization. Which also removes 8 bytes of
> text space on my x86 system.
>
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
>
> --- linux-2.6-orig/init/do_mounts_md.c  2009-01-12 09:53:09.000000000 +0600
> +++ linux-2.6/init/do_mounts_md.c       2009-01-12 11:12:39.734543784 +0600
> @@ -243,17 +243,17 @@ static void __init md_setup_drive(void)
>
>  static int __init raid_setup(char *str)
>  {
> -       int len, pos;
> +       int pos;
>
> -       len = strlen(str) + 1;
>        pos = 0;
>
> -       while (pos < len) {
> +       while (pos < strlen(str) + 1) {

doesn't calling strlen for every iteration (and in the else statement)
add an unneeded (and unwanted) overhead?

>                char *comma = strchr(str+pos, ',');
>                int wlen;
>                if (comma)
>                        wlen = (comma-str)-pos;
> -               else    wlen = (len-1)-pos;
> +               else
> +                       wlen = strlen(str)-pos;
>
>                if (!strncmp(str, "noautodetect", wlen))
>                        raid_noautodetect = 1;
> --

Sergio.
