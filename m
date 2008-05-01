Return-Path: <linux-kernel-owner+w=401wt.eu-S1764030AbYEAQiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764030AbYEAQiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760187AbYEAQil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:38:41 -0400
Received: from el-out-1112.google.com ([209.85.162.183]:9371 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759262AbYEAQij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:38:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bVQ0yudsVbYjXDVv3+m84hufRLuDP4Zmc4bxbpyI6AGGHh4f+Zb9Oqqioa7U6DuFAJAHXipi9B6mIuEraxswCbL17vMJSD+kjVXQCXatzD5LBv60d/FhuBteH0ZaGJFKbHiNR47WW/dIivYDhJMW8VgHAZuDtknMQTtcay4Wgi8=
Message-ID: <86802c440805010938s1fb6c3feu67a31b281223686c@mail.gmail.com>
Date: Thu, 1 May 2008 09:38:38 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete - auto detect
Cc: "Yinghai Lu" <yhlu.kernel.send@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "Mika Fischer" <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080501080927.026b6243.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804272337.40130.yhlu.kernel@gmail.com>
	 <200804290352.33543.yhlu.kernel@gmail.com>
	 <200804292025.58268.yhlu.kernel@gmail.com>
	 <200805010100.34751.yhlu.kernel@gmail.com>
	 <20080501080927.026b6243.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2008 at 8:09 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Thu, 1 May 2008 01:00:34 -0700 Yinghai Lu wrote:
>
>  >
>  > loop mtrr chunk_size and gran_size from 1M to 2G to find out optimal value.
>
>  What size step (increment) is used for these loops?
>
>
>  > so user don't need to add mtrr_chunk_size and mtrr_gran_size,
>  >
>  > if optimal value is not found, print out all list to help select less optimal
>  > value.
>  >
>  > add mtrr_spare_reg_nr= so user could set 2 instead of 1, if the card need more entries.
>  >
>  > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>  >
>
>
> > Index: linux-2.6/Documentation/kernel-parameters.txt
>  > ===================================================================
>  > --- linux-2.6.orig/Documentation/kernel-parameters.txt
>  > +++ linux-2.6/Documentation/kernel-parameters.txt
>  > @@ -613,9 +613,17 @@ and is between 256 and 4096 characters.
>  >                       that could hold holes aka. UC entries.
>  >
>  >       mtrr_gran_size=nn[KMG] [X86]
>  > -                     used for mtrr cleanup. It is granity of mtrr block.
>  > +                     used for mtrr cleanup. It is granularity of mtrr block.
>  > +                     default is 1.
>
>                         Default
>
>
>  >                       Big value could prevent small alignment use up MTRRs.
>
>                         Large value could prevent small alignment from
>                         using up MTRRs.
>
>
>  >
>  > +     mtrr_spare_reg_nr=n [X86]
>  > +                     Format: <integer>
>  > +                     range: 0,7 : spare reg number
>  > +                     default : 1
>  > +                     used for mtrr cleanup. It is spare mtrr entries number.
>
>                         Used
>
>
>  > +                     set to 2 or more if your graphical card need more.
>
>                         Set                                     needs more.
>
>
>  > +
>  >       disable_mtrr_trim [X86, Intel and AMD only]
>  >                       By default the kernel will trim any uncacheable
>  >                       memory out of your available memory pool based on
>

Ingo, can you change that directly in the patch?
or need me send another updated patch?

YH
