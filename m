Return-Path: <linux-kernel-owner+w=401wt.eu-S1030519AbXCCWpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030519AbXCCWpn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 17:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030525AbXCCWpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 17:45:43 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:50121 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030519AbXCCWpl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 17:45:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Sat, 3 Mar 2007 23:45:32 +0100
User-Agent: KMail/1.9.6
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
       alex@clusterfs.com, suzuki@in.ibm.com,
       Ulrich Drepper <drepper@redhat.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <1172789056.11165.42.camel@kleikamp.austin.ibm.com> <20070301233819.GB31072@infradead.org>
In-Reply-To: <20070301233819.GB31072@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703032345.33137.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:bf0b512fe2ff06b96d9695102898be39
X-Provags-ID2: V01U2FsdGVkX187hxnkAl2bmVoDE8OouzPq64An58Ztuva8cdN
 y9tU5WuvVlxHUMxQ6PlmbXv0SoOYjwf8NR4Kf6Xc3AR06phKET
 TWbi3xGgEEogC2hNUPQ7A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 March 2007 00:38:19 Christoph Hellwig wrote:
> > Forgive me if I haven't put enough thought into it, but would it be
> > useful to create a generic_fallocate() that writes zeroed pages for any
> > non-existent pages in the range?  I don't know how glibc currently
> > implements posix_fallocate(), but maybe the kernel could do it more
> > efficiently, even in generic code.  Maybe we don't care, since the major
> > file systems can probably do something better in their own code.
>
> I'd be more happy to have the write out zeroes loop in glibc.  And
> glibc needs to have it anyway, for older kernels.

A generic_fallocate makes sense to me iff we can do it in the kernel
more significantly more efficiently than in glibc, e.g. by using only
a single page in page cache instead of one for each page to be preallocated.

If  glibc is smart enough to do an optimal implementation, I fully agree
with you.

	Arnd <><
