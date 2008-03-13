Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbYCMAo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbYCMAo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 20:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbYCMAou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 20:44:50 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:23362 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbYCMAot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 20:44:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GEkvJMuUk/ijz3N0gdEbc6huvd55kCyr2hfKVSXcq2MNFuuyHUm28L7MWOTaZN4IATwLrVoLPdJIQoh+8HN1z35lCYOXJKCHNRIyTXjtz2X5cove7sBBNq/t6EEWKXUnedP/b/Tdo7HkTMpqrDRrFfKNPiBp4Nf0qdIuXC/zv+U=
Message-ID: <a8e1da0803121744m1ebe0025hc323c699e5f5d9a0@mail.gmail.com>
Date: Thu, 13 Mar 2008 08:44:48 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [PATCH -mm] do not check condition twice in WARN_ON_SECS
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Marcin Slusarz" <marcin.slusarz@gmail.com>, paulmck@linux.vnet.ibm.com
In-Reply-To: <87pru0oxyv.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080312010933.GA2957@darkstar.te-china.tietoenator.com>
	 <87pru0oxyv.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 9:47 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
> Hi Dave,
>
>
>
>  Dave Young <hidave.darkstar@gmail.com> writes:
>
>  > Don't check condition twice, change WARN_ON(condition) to WARN_ON(1)
>  > Thanks Marcin Slusarz <marcin.slusarz@gmail.com> for pointing out
>  >
>  > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>  >
>  > ---
>  > include/asm-generic/bug.h |    3 ++-
>  > 1 file changed, 2 insertions(+), 1 deletion(-)
>  >
>  > diff -upr linux/include/asm-generic/bug.h linux.new/include/asm-generic/bug.h
>  > --- linux/include/asm-generic/bug.h   2008-03-12 08:45:08.000000000 +0800
>  > +++ linux.new/include/asm-generic/bug.h       2008-03-12 09:04:07.000000000 +0800
>  > @@ -80,7 +80,8 @@ extern void warn_on_slowpath(const char
>  >       int __ret_warn_on = !!(condition);                      \
>  >       if (unlikely(__ret_warn_on))                            \
>  >               if (__ratelimit(secs * HZ, 1))                  \
>  > -                     WARN_ON(condition);                     \
>  > +                     WARN_ON(1);                             \
>  > +     unlikely(__ret_warn_on);                                \
>  >  })
>
>  What's wrong with:
>
>  #define WARN_ON_SECS(condition, secs) \
>         WARN_ON(condition && __ratelimit(secs * HZ, 1))

Looks concise.
Should I update the third time?
