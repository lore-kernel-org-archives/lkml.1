Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbZJNHHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbZJNHHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbZJNHHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:07:04 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:53569 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbZJNHHD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:07:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AkgLsD/NSluywPOW5AHM3aI5crn+qozntF9EOc12nMyFioGfBrlWBd7n0ZoTpTcVlR
         9AjKzbu7RdtyrUnKwaykmkBKX3QaU02rlxy3Nnvp22JLaypwog9UuOEFr7j53123lodJ
         kzi7W6kDK7Sri07pwuWcvoukJBQ9wGMUO7XaE=
MIME-Version: 1.0
In-Reply-To: <19f34abd0910020051h5a831729vcfca50b7bd9f9104@mail.gmail.com>
References: <200909261428.06802.bart.vanassche@gmail.com>
	 <e2e108260910012341v5eab14c5o29da95ec52e75183@mail.gmail.com>
	 <19f34abd0910020051h5a831729vcfca50b7bd9f9104@mail.gmail.com>
Date: Wed, 14 Oct 2009 09:06:25 +0200
Message-ID: <e2e108260910140006n3c55b3e9h9cb4340a6bec22cc@mail.gmail.com>
Subject: Re: [PATCH 2.6.31.1] include/linux/kmemcheck.h: fix a sparse warning
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, Vegard Nossum <vegardno@ifi.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 2, 2009 at 9:51 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>
> 2009/10/2 Bart Van Assche <bart.vanassche@gmail.com>:
> > On Sat, Sep 26, 2009 at 2:28 PM, Bart Van Assche
> > <bart.vanassche@gmail.com> wrote:
> >>
> >> Checking a 2.6.31.1 kernel configured with allyesconfig/allmodconfig
> >> with sparse (make C=2) triggers a sparse warning on code that uses the
> >> kmemcheck_annotate_bitfield() macro. An example of such a warning:
> >>
> >> include/net/inet_sock.h:208:17: warning: do-while statement is not a compound statement
> >>
> >> Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
> >> Cc: Vegard Nossum <vegardno@ifi.uio.no>
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >>
> >> --- linux-2.6.31.1/include/linux/kmemcheck-orig.h       2009-09-26 13:53:44.000000000 +0200
> >> +++ linux-2.6.31.1/include/linux/kmemcheck.h    2009-09-26 13:53:56.000000000 +0200
> >> @@ -137,13 +137,13 @@ static inline void kmemcheck_mark_initia
> >>        int name##_end[0];
> >>
> >>  #define kmemcheck_annotate_bitfield(ptr, name)                         \
> >> -       do if (ptr) {                                                   \
> >> +       do { if (ptr) {                                                 \
> >>                int _n = (long) &((ptr)->name##_end)                    \
> >>                        - (long) &((ptr)->name##_begin);                \
> >>                BUILD_BUG_ON(_n < 0);                                   \
> >>                                                                        \
> >>                kmemcheck_mark_initialized(&((ptr)->name##_begin), _n); \
> >> -       } while (0)
> >> +       } } while (0)
> >>
> >>  #define kmemcheck_annotate_variable(var)                               \
> >>        do {                                                            \
> >
> > (ping)
> >
> > Did anyone already have the time to review the patch above ?
>
> A patch for this problem has already been applied in latest mainline.

Unfortunately this issue is still present in 2.6.31.4, which has been
released on October 12 (yesterday). Is the patch that has been applied
in the mainline kernel suitable for backporting ?

Bart.
