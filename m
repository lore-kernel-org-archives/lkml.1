Return-Path: <linux-kernel-owner+w=401wt.eu-S1752240AbYCLAhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbYCLAhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 20:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbYCLAh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 20:37:29 -0400
Received: from el-out-1112.google.com ([209.85.162.177]:40900 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYCLAh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 20:37:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EWw8Yish7olpiVI18XejYIKmTreKJD2KT4U6Na0raL1ujOuTv6RwI8mW2ygVgv/xuKtY7wv9gLCNQC3APbm5YniKMstlCC0HlnX0qCCKDw/YDBohlVkkMTp4Rn/iic1uEYCng/GHmMYWeG+YaYBEUdY/i9KenWJiwKJZXMIwhcI=
Message-ID: <a8e1da0803111737k32efe341pc752d1a679fee46b@mail.gmail.com>
Date: Wed, 12 Mar 2008 08:37:27 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Marcin Slusarz" <marcin.slusarz@gmail.com>
Subject: Re: [PATCH] [2/3] add WARN_ON_SECS macro
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       paulmck@linux.vnet.ibm.com
In-Reply-To: <20080311192031.GA7178@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080310063437.GB6745@darkstar.te-china.tietoenator.com>
	 <20080311192031.GA7178@joi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 3:20 AM, Marcin Slusarz
<marcin.slusarz@gmail.com> wrote:
>
> On Mon, Mar 10, 2008 at 02:34:37PM +0800, Dave Young wrote:
>  > Add WARN_ON_SECS macro for some serious case which need repeat the
>  > warnings, but with some ratelimit.
>  >
>  > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>  >
>  > ---
>  > include/asm-generic/bug.h |    8 ++++++++
>  > 1 file changed, 8 insertions(+)
>  >
>  > diff -upr linux/include/asm-generic/bug.h linux.new/include/asm-generic/bug.h
>  > --- linux/include/asm-generic/bug.h   2008-03-10 13:27:03.000000000 +0800
>  > +++ linux.new/include/asm-generic/bug.h       2008-03-10 13:27:14.000000000 +0800
>  > @@ -3,6 +3,7 @@
>  >
>  >  #include <linux/compiler.h>
>  >
>  > +
>  >  #ifdef CONFIG_BUG
>  >
>  >  #ifdef CONFIG_GENERIC_BUG
>  > @@ -75,6 +76,13 @@ extern void warn_on_slowpath(const char
>  >       unlikely(__ret_warn_once);                              \
>  >  })
>  >
>  > +#define WARN_ON_SECS(condition, secs) ({                     \
>  > +     int __ret_warn_on = !!(condition);                      \
>  > +     if (unlikely(__ret_warn_on))                            \
>  > +             if (__ratelimit(secs * HZ, 1))                  \
>  > +                     WARN_ON(condition);                     \
>  > +})
>  > +
>  >  #ifdef CONFIG_SMP
>  >  # define WARN_ON_SMP(x)                      WARN_ON(x)
>  >  #else
>
>  Do you really want to check the condition twice?

Thanks, WARN_ON(1) will be better.

>
>  Marcin
>
