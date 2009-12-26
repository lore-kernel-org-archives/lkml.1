Return-Path: <linux-kernel-owner+w=401wt.eu-S1752325AbZLZEbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbZLZEbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 23:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbZLZEbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 23:31:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbZLZEbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 23:31:02 -0500
Message-ID: <4B359166.3050106@redhat.com>
Date: Fri, 25 Dec 2009 23:30:30 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@sues.cz>,
       Roland Dreier <rdreier@cisco.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch] Makefile: Unexport LANG
References: <20091224111300.GA31932@verge.net.au>
In-Reply-To: <20091224111300.GA31932@verge.net.au>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Horman wrote:
> The recent changes to setting and unexport various LC_ variables
> produces a problem on my system (Debian sid).
> 
> $ locale
> LANG=ja_JP.utf8
> LANGUAGE=ja_JP.utf8
> LC_CTYPE="ja_JP.utf8"
> LC_NUMERIC="ja_JP.utf8"
> LC_TIME="ja_JP.utf8"
> LC_COLLATE="ja_JP.utf8"
> LC_MONETARY="ja_JP.utf8"
> LC_MESSAGES="ja_JP.utf8"
> LC_PAPER="ja_JP.utf8"
> LC_NAME="ja_JP.utf8"
> LC_ADDRESS="ja_JP.utf8"
> LC_TELEPHONE="ja_JP.utf8"
> LC_MEASUREMENT="ja_JP.utf8"
> LC_IDENTIFICATION="ja_JP.utf8"
> LC_ALL=ja_JP.utf8
> 
> Without this patch:
> $ make
> make[2]: ??: ?? make ? -jN ?????????: jobserver ??????????.
> make[2]: ??: ?? make ? -jN ?????????: jobserver ??????????.
> 
> With this patch:
> $ make
> ...
> make[2]: warning: -jN forced in submake: disabling jobserver mode.
> make[2]: warning: -jN forced in submake: disabling jobserver mode.
> ...
> 
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Michal Marek <mmarek@sues.cz>
> Cc: Roland Dreier <rdreier@cisco.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> Signed-off-by: Simon Horman <horms@verge.net.au>

Tested on Fedora 11 too, and it works good. Thank you!

Tested-by: Masami Hiramatsu <mhiramat@redhat.com>

> 
> Index: linux-2.6/Makefile
> ===================================================================
> --- linux-2.6.orig/Makefile	2009-12-24 22:09:29.000000000 +1100
> +++ linux-2.6/Makefile	2009-12-24 22:10:58.000000000 +1100
> @@ -17,6 +17,7 @@ NAME = Man-Eating Seals of Antiquity
>  MAKEFLAGS += -rR --no-print-directory
>  
>  # Avoid funny character set dependencies
> +unexport LANG
>  unexport LC_ALL
>  LC_CTYPE=C
>  LC_COLLATE=C
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

