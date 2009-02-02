Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbZBBRLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbZBBRLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 12:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZBBRLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 12:11:13 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:54559 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbZBBRLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 12:11:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QaOgNgLdvH3I0uJuQiyeZiDkIXXqTdtBEct+7aRXTzxkweRygR0ZFi7gJa+YjzZGJ4
         8u6+RelVB/FtvHYffrWTNPcH8bSlROV1nA/JDYbN/aPmKKIVku9i1CGX2nBLduTZj5NT
         /uDii9NuTNu9l605Sg33xsL3GAkAhuEbquFZQ=
MIME-Version: 1.0
In-Reply-To: <20090201164915.GA29264@elte.hu>
References: <1233385816.17794.16.camel@localhost.localdomain>
	 <20090131164410.GA11189@elte.hu>
	 <1233469811.5846.14.camel@localhost.localdomain>
	 <20090201103936.GA30157@elte.hu> <20090201164915.GA29264@elte.hu>
Date: Mon, 2 Feb 2009 12:11:10 -0500
Message-ID: <8bd0f97a0902020911h6cc45be0m8b2affb5a531d160@mail.gmail.com>
Subject: Re: [git pull -tip] headers_check fixes for other architectures
From: Mike Frysinger <vapier.adi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       hskinnemoen@atmel.com, cooloney@kernel.org, tony.luck@intel.com,
       ralf@linux-mips.org, dhowells@redhat.com, matthew@wil.cx,
       chris@zankel.net, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 1, 2009 at 11:49, Ingo Molnar wrote:
> These are the remaining ones on x86:
>
>     17 /dev/shm/tip/usr/include/linux/reiserfs_fs.h
>     12 /dev/shm/tip/usr/include/linux/soundcard.h
>      6 /dev/shm/tip/usr/include/asm/setup.h
>      3 /dev/shm/tip/usr/include/linux/nubus.h
>      2 /dev/shm/tip/usr/include/linux/in6.h
>      1 /dev/shm/tip/usr/include/mtd/jffs2-user.h
>      1 /dev/shm/tip/usr/include/linux/socket.h
>      1 /dev/shm/tip/usr/include/linux/coda_psdev.h
>      1 /dev/shm/tip/usr/include/asm/prctl.h
>
> They are all of the "extern's make no sense in userspace" type. What was the
> verdict, are they worth touching, or should we turn off this warning in
> 'make headers_check'?

the warning wouldnt have been added if it didnt make sense ... like it
says, prototypes for kernel functions make no sense in userspace
headers

as for how it gets solved, we can either patch it manually or
automatically delete the prototypes ... but since prototypes are a big
difficult to match properly with regexes, the former will probably be
saner right now.
-mike
