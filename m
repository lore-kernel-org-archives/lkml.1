Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbXEEXol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbXEEXol (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 19:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbXEEXol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 19:44:41 -0400
Received: from pat.uio.no ([129.240.10.15]:52879 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145AbXEEXok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 19:44:40 -0400
Subject: Re: [PATCH] Fix nfsroot build
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070505210511.GA11342@linux-mips.org>
References: <20070505210511.GA11342@linux-mips.org>
Content-Type: text/plain
Date: Sat, 05 May 2007 19:44:29 -0400
Message-Id: <1178408669.6561.69.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.104)
X-UiO-Scanned: C28181D14B73F8F23DE91B81F76D2E23166D83F4
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 120 total 1528814 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-05 at 22:05 +0100, Ralf Baechle wrote:
> CC      fs/nfs/nfsroot.o
> fs/nfs/nfsroot.c:131: error: tokens causes a section type conflict
> make[2]: *** [fs/nfs/nfsroot.o] Error 1
> 
> This is due to mixing const and non-const content in the same section
> which halfway recent gccs absolutely hate.  Fixed by dropping the const.
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> 
> diff --git a/include/linux/parser.h b/include/linux/parser.h
> index 86676f6..26b2bdf 100644
> --- a/include/linux/parser.h
> +++ b/include/linux/parser.h
> @@ -14,7 +14,7 @@ struct match_token {
>  	const char *pattern;
>  };
>  
> -typedef const struct match_token match_table_t[];
> +typedef struct match_token match_table_t[];
>  
>  /* Maximum number of arguments that match_token will find in a pattern */
>  enum {MAX_OPT_ARGS = 3};
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

