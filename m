Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0BTPQd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 10:16:33 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:46703 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab0BTPQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 10:16:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fgR04OvIFA1nh5JaBvPi3sEF6O2wWOiCySYz2Ydseltchnvn6WOMLDlY2G1Uf9wwE8
         fMrcsR7q9N0jBS3akb7litGZn8uk3PB9BjKd3GYZsX+JQaoI+LikhBniV2I/2XUgWcGE
         JstOl6f/m/E4R5Ec9LkcpMbXTnbodG454ng0A=
MIME-Version: 1.0
In-Reply-To: <201002201551.56851.arnd@arndb.de>
References: <20100220141328.GF3195@darkstar> <201002201551.56851.arnd@arndb.de>
Date: Sat, 20 Feb 2010 23:16:30 +0800
Message-ID: <a8e1da1002200716u1eb6224fr7b3d6eca1c015cb8@mail.gmail.com>
Subject: Re: [PATCH 07/18] sysctl extern cleanup - compat
From: Dave Young <hidave.darkstar@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "David S. Miller" <davem@davemloft.net>, Gerd Hoffmann <kraxel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 10:51 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 20 February 2010 15:13:28 Dave Young wrote:
>> Extern declarations in sysctl.c should be move to their own head file,
>> and then include them in relavant .c files.
>>
>> Move compat_log extern declaration to linux/compat.h
>>
>> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>
> Good idea in principle, but please don't enclose the extern
> declaration in #ifdef:
>
>> --- linux-2.6.32.orig/include/linux/compat.h  2010-02-20 14:02:24.334925488 +0800
>> +++ linux-2.6.32/include/linux/compat.h       2010-02-20 14:24:30.405627048 +0800
>> @@ -17,6 +17,9 @@
>>  #include <asm/siginfo.h>
>>  #include <asm/signal.h>
>>
>> +#ifdef CONFIG_SYSCTL
>> +extern int compat_log;
>> +#endif
>>  #define compat_jiffies_to_clock_t(x) \
>>               (((unsigned long)(x) * COMPAT_USER_HZ) / HZ)
>
> This will force a rebuild of everything that #includes linux/compat.h when CONFIG_SYSCTL
> changes, while nothing really changes.
>
> Obviously, the same goes for the entire series.

Yes, indeed. Thanks for the comments.

Actually I need resend the whole patchset with a updated version.

>
>        Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Regards
dave
