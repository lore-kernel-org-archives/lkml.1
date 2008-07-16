Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbYGPGln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbYGPGln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 02:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbYGPGlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 02:41:36 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:56516 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbYGPGlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 02:41:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mVQumupkepG7As4cZP8diUdXHx+StQpVVDIMBO7XI68LAkGh08ENNuO9sWyesb6qBn
         uaRPpAGf2xb9aIECtsa6TOxRPXalMOEkYCHmqZ6awNxYBF1/UmMPos+SQQ8SwLO78xVV
         hsFULJjoJXSQTCQtpk2Q7w6Av6C82HFVzGYss=
Message-ID: <36ca99e90807152341h28ec137do76fbf85bd50a3abe@mail.gmail.com>
Date: Wed, 16 Jul 2008 08:41:33 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 7/8] cpumask: Provide a generic set of CPUMASK_ALLOC macros
Cc: "Rusty Russell" <rusty@rustcorp.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       "Jack Steiner" <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       "Paul Jackson" <pj@sgi.com>
In-Reply-To: <20080715211430.448714000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080715211429.454823000@polaris-admin.engr.sgi.com>
	 <20080715211430.448714000@polaris-admin.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 23:14, Mike Travis <travis@sgi.com> wrote:
>  * Provide a generic set of CPUMASK_ALLOC macros patterned after the
>    SCHED_CPUMASK_ALLOC macros.  This is used where multiple cpumask_t
>    variables are declared on the stack to reduce the amount of stack
>    space required.
>
> Based on linux-2.6.tip/master at the following commit:
>
>    commit 0a91813e16ebd5c2d9b5c2acd5b7c91742112c4f
>    Merge: 9a635fa... 724dce0...
>    Author: Ingo Molnar <mingo@elte.hu>
>    Date:   Tue Jul 15 14:55:17 2008 +0200
>
> Signed-off-by: Mike Travis <travis@sgi.com>
> Cc: Paul Jackson <pj@sgi.com>
> ---
>  include/linux/cpumask.h |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> --- linux-2.6.tip.orig/include/linux/cpumask.h
> +++ linux-2.6.tip/include/linux/cpumask.h
> @@ -75,6 +75,17 @@
>  * CPU_MASK_NONE                       Initializer - no bits set
>  * unsigned long *cpus_addr(mask)      Array of unsigned long's in mask
>  *
> + *if NR_CPUS > BITS_PER_LONG
> + *   CPUMASK_ALLOC(m)                  Declares and allocates struct m *m =
> + *                                        (struct m *)kmalloc(sizeof(*m), ...)
Shouldn't you mention the GFP_KERNEL flag? And the cast should not
necessarily be mentioned in a comment.

> + *   CPUMASK_FREE(m)                   Macro for kfree(v)
                                                    kfree(m)

> + *else
> + *   CPUMASK_ALLOC(m)                  Declares struct m _m, *m = &_m
> + *   CPUMASK_FREE(m)                   Nop
> + *endif
> + *   CPUMASK_VAR(v, m)                 Declares cpumask_t *v =
> + *                                             m + offset(struct m, v)
                                                      offsetof
and why can't you use a &(m->v)?

Regards
Bert
