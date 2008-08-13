Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbYHMIL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbYHMIL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYHMILo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:11:44 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:61627 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbYHMILn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:11:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SUlhXnRdsTCDhf1quMP1Uk/KYCHp1reMXrlJJlcBZ/Y/QRmzRWMjWz9PxaRNO12oUN
         51NWHbKKSkO1K5d1cnDMbHe+flpmrB1+0/rAHPeBs5MVgq1tgEjGG+Ptdm9KauhuA1Br
         vlqlQlYhIn/gEVVkspqHnbXuIAMzj3CRxwMkY=
Message-ID: <ac9c93b10808130111ua3d4630v63f7d3754d2ca12e@mail.gmail.com>
Date: Wed, 13 Aug 2008 10:11:40 +0200
From: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch]fastboot: remove duplicate unpack_to_rootfs()
Cc: "Shaohua Li" <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <20080813075236.GA8052@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218607669.3463.9.camel@sli10-desk.sh.intel.com>
	 <20080813074503.GB398@elte.hu> <20080813075236.GA8052@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/13, Ingo Molnar <mingo@elte.hu>:
>
>  * Ingo Molnar <mingo@elte.hu> wrote:
>
>  > the dry_run variable is now unused in unpack_to_rootfs() and could be
>  > eliminated.
>
>  also, while we are materially touching init/initramfs.c, that file has
>  collected a few uglies in the past few years, checkpatch --file says:
>
>   total: 7 errors, 7 warnings, 3 checks, 562 lines checked
>
>  it has a few other problems as well that can be seen if you look at the
>  file. Unused macros:
>
>   /* Diagnostic functions (stubbed out) */
>   #define Assert(cond,msg)
>   #define Trace(x)
>   #define Tracev(x)
>   #define Tracevv(x)
>   #define Tracec(c,x)
>   #define Tracecv(c,x)
>
>   #define STATIC static
>   #define INIT __init
>
These are not really unused. A few lines later it reads:

#include "../src/inflate.c"

These macros are used within inflate.c

(and perhaps the inclusion of inflate.c is not a good idea, maybe this
should be in lib.a
note that inflate.c is also included in init/do_mounts_rd.c;
fortunately this is all init code (which is probably why include was
used in the first place))

Frans.
