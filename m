Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYERXFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYERXFX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 19:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYERXFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 19:05:09 -0400
Received: from saeurebad.de ([85.214.36.134]:52013 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbYERXFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 19:05:08 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/6] ERR_PTR: add ERR_OR_0_PTR
References: <20080513201813.GA5869@joi>
	<1211148067-16130-1-git-send-email-marcin.slusarz@gmail.com>
Date: Mon, 19 May 2008 01:04:44 +0200
In-Reply-To: <1211148067-16130-1-git-send-email-marcin.slusarz@gmail.com>
	(Marcin Slusarz's message of "Mon, 19 May 2008 00:01:07 +0200")
Message-ID: <87lk27usc3.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcin,

Marcin Slusarz <marcin.slusarz@gmail.com> writes:

> Some codepaths call ERR_PTR with possibly 0 argument, which is not
> a valid errno and rely on conversion from 0 to NULL pointer.
> Add ERR_OR_0_PTR function which accepts errnos and 0 as an argument.
>
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  include/linux/err.h |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/err.h b/include/linux/err.h
> index 7b5daa6..cdec8b6 100644
> --- a/include/linux/err.h
> +++ b/include/linux/err.h
> @@ -26,6 +26,13 @@ static inline void *__ERR_PTR(long error)
>  
>  #define ERR_PTR(error) (BUILD_BUG_ON(__builtin_constant_p(error) && !IS_ERR_VALUE(error)), __ERR_PTR(error))
>  
> +static inline void *__ERR_OR_0_PTR(long error)
> +{
> +	return (void *) error;
> +}
> +
> +#define ERR_OR_0_PTR(error) (BUILD_BUG_ON(__builtin_constant_p(error) && error && !IS_ERR_VALUE(error)), __ERR_OR_0_PTR(error))

ERR_OR_0_PTR could use __ERR_PTR() too.

And please break those lines ;)

	Hannes
