Return-Path: <linux-kernel-owner+w=401wt.eu-S934629AbZGQNeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934629AbZGQNeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 09:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934558AbZGQNeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 09:34:18 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:59981 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934449AbZGQNeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 09:34:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BinXELCwWp/T3OzSJPaBFKwlbAZvU/KsFHyzbmbQdg5g1m7M7JLkRSYKkUjBuC74eC
         otDYY+n/mvmdv26rF+U/iM/Pn01QpkDev+1eZhf0m0CUgbV4E4o+BTA7+NYPP1G3/c9y
         MUck8cXJcJ80kf4+3aANtrkfHPxK6FGK1NK88=
MIME-Version: 1.0
In-Reply-To: <20090717083432.GB3378@localdomain.by>
References: <20090711191556.GA3845@localdomain.by>
	 <20090711235530.GA3231@localdomain.by>
	 <20090713124834.5c3ecc5d@lxorguk.ukuu.org.uk>
	 <20090714162837.GC3145@localdomain.by>
	 <20090715110533.62daf05e@lxorguk.ukuu.org.uk>
	 <20090715102733.GA3055@localdomain.by>
	 <20090715113042.5dbb5822@lxorguk.ukuu.org.uk>
	 <20090715170351.GB3139@localdomain.by>
	 <a8e1da0907161751t4c9e40f6k8f1ab27dc7c17291@mail.gmail.com>
	 <20090717083432.GB3378@localdomain.by>
Date: Fri, 17 Jul 2009 21:34:14 +0800
Message-ID: <a8e1da0907170634l1daec371q556af18c4efc7c57@mail.gmail.com>
Subject: Re: possible regression with pty.c commit
From: Dave Young <hidave.darkstar@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 4:34 PM, Sergey
Senozhatsky<sergey.senozhatsky@mail.by> wrote:
> On (07/17/09 08:51), Dave Young wrote:
>> >  d945cb9cce20ac7143c2de8d88b187f62db99bdc "pty: Rework the pty layer to use  the normal buffering logic"
>> >  and REVERTED a6540f731d506d9e82444cf0020e716613d4c46c "ppp: Fix throttling bugs"
>> >
>> > seems to work.
>>
>> I have same result, the pppoe connection is unstable with the patch.
>> Are there better solution for this issue?
>>
>
> Hello Dave.
> The solution is in rc3-git2.
> Linus has reverted "throttling" commits.
>
> git log drivers/net/ppp_async.c
> git log drivers/net/ppp_synctty.c
> 4a21b8cb3550f19f838f7c48345fbbf6a0e8536b
> Revert "ppp: Fix throttling bugs"
>
> Requested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
>
>        Sergey

Thanks for tell, and then the  "scheduling in atomic" problem?

> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.9 (GNU/Linux)
>
> iJwEAQECAAYFAkpgN5gACgkQfKHnntdSXjRg0wQAhef6hdvDaOXuQSsxFLH/l9H1
> 99NtAA8ewJ7Rx6/lNkzLu9n/A8qJtdoZxNP9xQDeBbeMXaH+NA5+FSo48mGbb/jp
> ePjb3vIIOzRRqGWsKYFdn0m4JW5Bw/2IvVFbHBPfa9C+ZDBPodiyDHI9gZi8bF99
> xc5uyDLAlCksK+WYu+s=
> =BLJz
> -----END PGP SIGNATURE-----
>
>



-- 
Regards
dave
