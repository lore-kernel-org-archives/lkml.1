Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbZINLty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbZINLty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 07:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbZINLtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 07:49:53 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:53469 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbZINLtx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 07:49:53 -0400
MIME-Version: 1.0
In-Reply-To: <4AADEA82.8000500@np.css.fujitsu.com>
References: <4AADEA82.8000500@np.css.fujitsu.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 14 Sep 2009 13:49:41 +0200
Message-ID: <ac3eb2510909140449v6428a2e0jf3d3cc5200973b4c@mail.gmail.com>
Subject: Re: [GIT BISECT -next] mem.c: could not login on console of fedora 10
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: Jiri Kosina <jkosina@suse.cz>, gregkh <gregkh@suse.de>,
       LKLM <linux-kernel@vger.kernel.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/14 Jin Dongming <jin.dongming@np.css.fujitsu.com>:
> When I build and boot -next on fedora 10, I can not login anymore.
> When I input the user name and password, the system does not output
> any message and requires user to input the user name and password
> again and again.
>
> I find the patch which caused this problem with "GIT BISECT" command.
> And the patch is
>    commit 7c4b7daa1878972ed0137c95f23569124bd6e2b1
>    "mem_class: use minor as index instead of searching the array".
>
> Though I don't know the real reason why user could not login, I
> confirmed the patch I made as following could resolve the problem on
> fedora 10.
>
> Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
> ---
>  drivers/char/mem.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index bed3503..0491cdf 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -878,8 +878,8 @@ static const struct memdev {
>        [ 4] = { "port", &port_fops, NULL },
>  #endif
>        [ 5] = { "zero", &zero_fops, &zero_bdi },
> -       [ 6] = { "full", &full_fops, NULL },
> -       [ 7] = { "random", &random_fops, NULL },
> +       [ 7] = { "full", &full_fops, NULL },
> +       [ 8] = { "random", &random_fops, NULL },
>        [ 9] = { "urandom", &urandom_fops, NULL },
>        [11] = { "kmsg", &kmsg_fops, NULL },
>  #ifdef CONFIG_CRASH_DUMP

Yeah, that looks messed up and it seems like the right fix.
Greg, care to merge that into the patch in your tree?

Thanks for the fix and sorry,
Kay
