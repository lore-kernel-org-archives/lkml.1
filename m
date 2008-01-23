Return-Path: <linux-kernel-owner+w=401wt.eu-S1753719AbYAWKxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbYAWKxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 05:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYAWKxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 05:53:11 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35309 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbYAWKxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 05:53:09 -0500
To: salikhmetov@gmail.com
CC: miklos@szeredi.hu, linux-mm@kvack.org, jakob@unthought.net,
       linux-kernel@vger.kernel.org, valdis.kletnieks@vt.edu, riel@redhat.com,
       ksm@42.dk, staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, r.e.wolff@bitwizard.nl,
       hidave.darkstar@gmail.com, hch@infradead.org
In-reply-to: <4df4ef0c0801230237g2f26f0d1j2d2ada2ce62ba284@mail.gmail.com>
	(salikhmetov@gmail.com)
Subject: Re: [PATCH -v8 4/4] The design document for memory-mapped file times update
References: <12010440803930-git-send-email-salikhmetov@gmail.com>
	 <1201044083554-git-send-email-salikhmetov@gmail.com>
	 <E1JHbs1-00025n-Ac@pomaz-ex.szeredi.hu> <4df4ef0c0801230237g2f26f0d1j2d2ada2ce62ba284@mail.gmail.com>
Message-Id: <E1JHdE4-0002Jk-QG@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 23 Jan 2008 11:53:00 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've already written in the cover letter that functional tests passed
> successfully.
>
> debian:~/times# ./times /mnt/file
> begin   1201084493      1201084493      1201084281
> write   1201084494      1201084494      1201084281
> mmap    1201084494      1201084494      1201084495
> b       1201084496      1201084496      1201084495

Ah, OK, this is becuase mmap doesn't actually set up the page tables
by default.   Try adding MAP_POPULATE to the flags.

Please also try

   ./times /mnt/file -s

Thanks,
Miklos
