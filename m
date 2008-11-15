Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbYKORMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbYKORMB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 12:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbYKORLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 12:11:52 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:43362 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYKORLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 12:11:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=u60Bw48FUt29xqf50qou1wVJ87Y/WCJUzxTFcFTxN0OJ7l7FtasnRNNr0dtRUi3ZxI
         YRdD6xH9CR6I+s8/W2Cry4rqDdz7wT+AS/H/0GB6EZLef/2/yb2z4EU9dPWhk/LryPD4
         L6cPtPpE2i79tDwI2wSBFQpZ8ohY21Z2hu/fw=
Message-ID: <2375c9f90811150911l3cfba998r1ae949912b7a8df3@mail.gmail.com>
Date: Sat, 15 Nov 2008 17:11:49 +0000
From: "=?UTF-8?Q?Am=C3=A9rico_Wang?=" <xiyou.wangcong@gmail.com>
To: "Hiroshi Shimamoto" <h-shimamoto@ct.jp.nec.com>
Subject: Re: [PATCH 2/5] x86: ia32_signal: introduce COPY_SEG_STRICT
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <491E416F.5040703@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491E4101.7010405@ct.jp.nec.com> <491E416F.5040703@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2008 at 3:26 AM, Hiroshi Shimamoto
<h-shimamoto@ct.jp.nec.com> wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>
> Impact: cleanup
>
> Introduce COPY_SEG_STRICT for ia32_restore_sigcontext().
>
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  arch/x86/ia32/ia32_signal.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
> index a28790a..f74178e 100644
> --- a/arch/x86/ia32/ia32_signal.c
> +++ b/arch/x86/ia32/ia32_signal.c
> @@ -201,6 +201,12 @@ struct rt_sigframe
>        err |= __get_user(regs->x, &sc->x);     \
>  }
>
> +#define COPY_SEG_STRICT(seg)   {                       \
> +               unsigned short tmp;                     \
> +               err |= __get_user(tmp, &sc->seg);       \
> +               regs->seg = tmp | 3;                    \
> +}
> +

Since your first patch is to kill the temporary variables, then why do you
introduce a temporary variable here? It can be avoided like it was.

Can you explain the reason? :)
