Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbYERXNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbYERXNu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 19:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYERXNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 19:13:42 -0400
Received: from saeurebad.de ([85.214.36.134]:52086 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbYERXNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 19:13:42 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/6] ERR_PTR: warn when ERR_PTR parameter is not errno value
References: <20080513201813.GA5869@joi>
	<1211148273-16226-1-git-send-email-marcin.slusarz@gmail.com>
Date: Mon, 19 May 2008 01:13:20 +0200
In-Reply-To: <1211148273-16226-1-git-send-email-marcin.slusarz@gmail.com>
	(Marcin Slusarz's message of "Mon, 19 May 2008 00:04:33 +0200")
Message-ID: <87hccvurxr.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcin,

Marcin Slusarz <marcin.slusarz@gmail.com> writes:

> Check at runtime whether error argument of ERR_PTR and ERR_OR_0_PTR
> is valid. It can catch bugs which possibly lead to oops or panic earlier.
>
> Currently there are > 600 calls of ERR_PTR with non-constant argument
> in Linux kernel sources.
>
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  include/linux/err.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/err.h b/include/linux/err.h
> index cdec8b6..51e2459 100644
> --- a/include/linux/err.h
> +++ b/include/linux/err.h
> @@ -3,6 +3,7 @@
>  
>  #include <linux/compiler.h>
>  
> +#include <asm/bug.h>
>  #include <asm/errno.h>
>  
>  /*
> @@ -21,6 +22,7 @@
>  
>  static inline void *__ERR_PTR(long error)
>  {
> +	WARN_ON(!IS_ERR_VALUE(error));
>  	return (void *) error;
>  }
>  
> @@ -28,6 +30,7 @@ static inline void *__ERR_PTR(long error)
>  
>  static inline void *__ERR_OR_0_PTR(long error)
>  {
> +	WARN_ON(!IS_ERR_VALUE(error) && error);
>  	return (void *) error;
>  }

How about WARN_ON_ONCE() instead?  That would warn once for each erroneous user
which should be enough.

	Hannes
