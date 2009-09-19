Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbZISTI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbZISTI4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 15:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZISTI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 15:08:56 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:64693 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbZISTIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 15:08:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=UZJ5Ty3sd4IB8UtJJpEjcS/fbErVb5IJDVKlrpUbRAcoz5dgEY+ulMhD5aPmhUuL4u
         c/LpF94yF85pjxra/rqZV4i1QAfbVSwmWcsokyBaluLWiH49jjEeipmYkOmWZPedbo2i
         O43pDaZaeXrJqabXlCQLGRJ0Iq58aHod4KK3I=
MIME-Version: 1.0
In-Reply-To: <200906232314.18261.arnd@arndb.de>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org> 
	<200906191433.34608.arnd@arndb.de> <8bd0f97a0906190612n687cdbbt1e752997acb68e49@mail.gmail.com> 
	<200906232314.18261.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 19 Sep 2009 15:08:39 -0400
Message-ID: <8bd0f97a0909191208j42c49a72j67dd27287eba50fa@mail.gmail.com>
Subject: Re: [PATCH 05/17] Blackfin: convert to generic checksum code
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michal Simek <monstr@monstr.eu>, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 17:14, Arnd Bergmann wrote:
> On Friday 19 June 2009, Mike Frysinger wrote:
>> >
>> > sounds like a good idea.
>>
>> how about the attached
>
> Mostly good, but needs some improvements. At least it helped me
> track down the last problem.
>
>> > lib/checksum.c: Fix another endianess bug
>>
>> hrm, still not quite :/
>>
>> the attached test code shows failures in every case
>
> When I tried running it on x86-64, it only showed failures for
> numbers 1, 2 and 4. I fixed them with this patch:
> ---
> lib/checksum: fix one more thinko
>
> When do_csum gets unaligned data, we really need to treat
> the first byte as an even byte, not an odd byte, because
> we swap the two halves later.
>
> Found by Mike's checksum-selftest module.
>
> Reported-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

shouldnt this fix have been in 2.6.31 ?  doesnt seem to be even in
latest git ...
-mike
