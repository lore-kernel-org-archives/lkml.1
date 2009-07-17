Return-Path: <linux-kernel-owner+w=401wt.eu-S934150AbZGQHHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934150AbZGQHHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 03:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933474AbZGQHHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 03:07:18 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:33985 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933462AbZGQHHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 03:07:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I0rRHtlekiWVRZ2FjX3oIx7nrhJCGBHQ+xwQAkmZOR4V15dShhs24ra4dkxMdJeIxf
         uCW84eqo9N3fERJJoyZIEbAHKgcNGIR8xK3JeNR/B0wzPACadX0Poslq3NwxOa9lOTmO
         qu7wItNC4S334/h0hOY8j3QOkgDusVicKN0GM=
MIME-Version: 1.0
In-Reply-To: <f5a7b3810906040414me72f8b6h583ff3c05b99693@mail.gmail.com>
References: <f5a7b3810905220417m5bbef733s54524e1180a9d4f7@mail.gmail.com>
	 <cfd18e0f0906012207i61621045je6d98db91d986c5f@mail.gmail.com>
	 <f5a7b3810906040414me72f8b6h583ff3c05b99693@mail.gmail.com>
Date: Fri, 17 Jul 2009 12:37:16 +0530
Message-ID: <f5a7b3810907170007i33bc5b01sf2dd2810e4615c41@mail.gmail.com>
Subject: Re: adjtimex system man page EINVAL
From: naresh kamboju <naresh.kernel@gmail.com>
To: mtk.manpages@gmail.com
Cc: ziegler@uni-freiburg.de, akpm@linux-foundation.org, johnstul@us.ibm.com,
       zippel@linux-m68k.org, linux-kernel@vger.kernel.org,
       saji.kumar@wipro.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Michael Kerrisk,

As per our discussion … I have sent below mail explaining the issue
with adjtimex man page.
Is that information and patch  OK?

When would be the next man page release?

Please let me know if there are any issues.

Best regards
Naresh Kamboju



On Thu, Jun 4, 2009 at 4:44 PM, naresh kamboju<naresh.kernel@gmail.com> wrote:
> Dear Michael Kerrisk,
>
> After comparing the changes between 2.6.25 and 2.6.29 kernels
> As per my understanding EINVAL error check is removed with
> timex.offset after 2.6.25 kernels and above.
>
> To make sure the offset value following lines are added in
> linux-2.6.29/kernel/time/ntp.c +80
>
>
> +       /*
> +        * Scale the phase adjustment and
> +        * clamp to the operating range.
> +        */
> +       offset = min(offset, MAXPHASE);
> +       offset = max(offset, -MAXPHASE);
> +
>
>
> I have attached patch as adjtimex_man.patch
>
>
> Best wishes,
> Naresh Kamboju
>
> Signed-off-by: Naresh Kamboju < naresh.kernel@gmail.com >
> diff -Naurb man-pages-3.21/man2/adjtimex.2 man-pages-3.21_mod/man2/adjtimex.2
> --- man-pages-3.21/man2/adjtimex.2      2009-04-15 21:35:32.000000000 +0530
> +++ man-pages-3.21_mod/man2/adjtimex.2  2009-06-04 14:19:34.000000000 +0530
> @@ -118,7 +118,8 @@
>  .B EINVAL
>  An attempt is made to set
>  .I buf.offset
> -to a value outside the range \-131071 to +131071,
> +to a value outside the range \-131071 to +131071 applicable upto 2.6.25
> +kernels, EINVAL error check with buf.offset been removed from 2.6.25 and above,
>  or to set
>  .I buf.status
>  to a value other than those listed above,
>
>
>
>
>
> On Tue, Jun 2, 2009 at 10:37 AM, Michael Kerrisk
> <mtk.manpages@googlemail.com> wrote:
>> Naresh,
>>
>> On Fri, May 22, 2009 at 1:17 PM, naresh kamboju <naresh.kernel@gmail.com> wrote:
>>> Hi,
>>>
>>> Regarding adjtimex system man page,
>>>
>>> Since there are modifications noticed in
>>> /kerel/time/ntp.c
>>> /include/linux/timex.h
>>>
>>> compared with /kerel/time/ntp.c 2.6.23 and 2.6.29 and above i have
>>> attached adjtimex_2.6.23_vs_2.6.29.log : line number 330.
>>>
>>> In adjtimex (2) man page under the EINVAL Error check section changes
>>> are required w.r.t buf.offset.
>>> Could you conform and update the man page.
>>
>> Could you please summarize in a couple of sentence what the actual
>> changes are that you think are required.
>>
>> Cheers,
>>
>> Michael
>>
>>
>> --
>> Michael Kerrisk
>> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
>> git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
>> man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
>> Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
>>
>
