Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbYAWNJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbYAWNJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 08:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYAWNJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 08:09:13 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:14271 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbYAWNJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 08:09:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aQITHp/KJlZJ/ncIAXiFwQt+0sJWXGKzrVVOGfQP3MEtDyS8R3acan9TW31I60k8Ue3CnuOUs43/JWzRgw5uoVEJDQgUbl7xk5tROYZ7KCaF2EqLHOE+M5Hm6f3aWQVSnIZlq/ePlBMGecqQYrBrVyey0i6l2wloSRPTOE2AeS0=
Message-ID: <4df4ef0c0801230509w5c6cd1a5m35fb30b51462da4d@mail.gmail.com>
Date: Wed, 23 Jan 2008 16:09:11 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [PATCH -v8 3/4] Enable the MS_ASYNC functionality in sys_msync()
Cc: a.p.zijlstra@chello.nl, linux-mm@kvack.org, jakob@unthought.net,
       linux-kernel@vger.kernel.org, valdis.kletnieks@vt.edu, riel@redhat.com,
       ksm@42.dk, staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       protasnb@gmail.com, r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com,
       hch@infradead.org
In-Reply-To: <E1JHcG4-0002A9-46@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12010440803930-git-send-email-salikhmetov@gmail.com>
	 <1201044083504-git-send-email-salikhmetov@gmail.com>
	 <1201078035.6341.45.camel@lappy> <1201078278.6341.47.camel@lappy>
	 <E1JHc0S-00027S-8D@pomaz-ex.szeredi.hu>
	 <E1JHcG4-0002A9-46@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/23, Miklos Szeredi <miklos@szeredi.hu>:
> > > Also, it still doesn't make sense to me why we'd not need to walk the
> > > rmap, it is all the same file after all.
> >
> > It's the same file, but not the same memory map.  It basically depends
> > on how you define msync:
> >
> >  a) sync _file_ on region defined by this mmap/start/end-address
> >  b) sync _memory_region_ defined by start/end-address
>
> My mmap/msync tester program can acually check this as well, with the
> '-f' flag.  Anton, can you try that on the reference platforms?

Here it is:

$ ./a.out file -f
begin   1201085546      1201085546      1200956936
write   1201085546      1201085546      1200956936
mmap    1201085546      1201085546      1200956936
b       1201085546      1201085546      1200956936
msync b 1201085550      1201085550      1200956936
c       1201085550      1201085550      1200956936
msync c 1201085552      1201085552      1200956936
d       1201085552      1201085552      1200956936
munmap  1201085552      1201085552      1200956936
close   1201085555      1201085555      1200956936
sync    1201085555      1201085555      1200956936
$ ./a.out file -sf
begin   1201085572      1201085572      1200956936
write   1201085572      1201085572      1200956936
mmap    1201085572      1201085572      1200956936
b       1201085572      1201085572      1200956936
msync b 1201085576      1201085576      1200956936
c       1201085576      1201085576      1200956936
msync c 1201085578      1201085578      1200956936
d       1201085578      1201085578      1200956936
munmap  1201085578      1201085578      1200956936
close   1201085581      1201085581      1200956936
sync    1201085581      1201085581      1200956936
$ uname -a
FreeBSD td152.testdrive.hp.com 6.2-RELEASE FreeBSD 6.2-RELEASE #0: Fri
Jan 12 11:05:30 UTC 2007
root@dessler.cse.buffalo.edu:/usr/obj/usr/src/sys/SMP  i386
$

>
> Miklos
>
