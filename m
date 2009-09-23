Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbZIWHVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbZIWHVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 03:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbZIWHVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 03:21:33 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:64599 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbZIWHVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 03:21:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ko1I/hTABtVygG1tF+8reXtXyTd7Z4e2ODlJCGFTdOePletJwm2/fj3M8scikXidaM
         ncYuLksWoJuFj8N8KEePqxfpT2/7N6DZq0eeJccHdoxrxYIKUug582MfkAg946LcLa/g
         QohlAa0LS/7OEMOMHhTtKnGwD1wmXU+Y5PqZA=
MIME-Version: 1.0
In-Reply-To: <20090923091958.6a0f9d58@hyperion.delvare>
References: <4AB8FC88.8020608@s5r6.in-berlin.de>
	 <20090923091958.6a0f9d58@hyperion.delvare>
Date: Wed, 23 Sep 2009 10:21:34 +0300
X-Google-Sender-Auth: ccfd00f1f6adcd25
Message-ID: <84144f020909230021h76400174q4bb6c9bcd39d576b@mail.gmail.com>
Subject: Re: v2.6.31-7381-g7fa0772: new build warnings: kmemcheck, 
	__deprecated, hugetlb, radeon
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Jean Delvare <khali@linux-fr.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Eric B Munson <ebmunson@us.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Dave Airlie <airlied@linux.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 10:19 AM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Stefan,
>
> On Tue, 22 Sep 2009 18:34:16 +0200, Stefan Richter wrote:
>> Latest git compiles with extreme noise:
>>
>> In file included from include/net/inet_connection_sock.h:23,
>>                   from include/linux/tcp.h:178,
>>                   from include/linux/ipv6.h:215,
>>                   from include/net/ipv6.h:16,
>>                   from include/linux/sunrpc/clnt.h:25,
>>                   from include/linux/nfs_fs.h:52,
>>                   from kernel/sysctl.c:48:
>> include/net/inet_sock.h: In function 'inet_reqsk_alloc':
>> include/net/inet_sock.h:208: warning: ISO C90 forbids mixed declarations
>> and code
>>
>> Vegard, this is obviously caused by commit
>> 45e3ff82708c65c895d5c5882aff17ecf62a80b5.
>
> Actually not, it's caused by commit
> 181f7c5dd3832763bdf2756b6d2d8a49bdf12791
> (kmemcheck: add missing braces to do-while in kmemcheck_annotate_bitfield)
>
> And the fix would be:
>
> From: Jean Delvare <khali@linux-fr.org>
> Subject: Fix build warning in kmemcheck_annotate_bitfield
>
> Fix the following build warning:
>
> include/net/inet_sock.h: In function 'inet_reqsk_alloc':
> include/net/inet_sock.h:208: warning: ISO C90 forbids mixed declarations
> and code
>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  include/linux/kmemcheck.h |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> --- linux-2.6.32-pre.orig/include/linux/kmemcheck.h     2009-09-23 08:19:34.000000000 +0200
> +++ linux-2.6.32-pre/include/linux/kmemcheck.h  2009-09-23 09:05:30.000000000 +0200
> @@ -145,10 +145,12 @@ static inline bool kmemcheck_is_obj_init
>
>  #define kmemcheck_annotate_bitfield(ptr, name)                         \
>        do {                                                            \
> +               int _n;                                                 \
> +                                                                       \
>                if (!ptr)                                               \
>                        break;                                          \
>                                                                        \
> -               int _n = (long) &((ptr)->name##_end)                    \
> +               _n = (long) &((ptr)->name##_end)                        \
>                        - (long) &((ptr)->name##_begin);                \
>                BUILD_BUG_ON(_n < 0);                                   \
>                                                                        \

Oh, I was looking at an old version. The fix looks good to me, thanks Jean!

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
