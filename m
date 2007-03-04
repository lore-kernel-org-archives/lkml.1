Return-Path: <linux-kernel-owner+w=401wt.eu-S1750714AbXCDUyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750714AbXCDUyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 15:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbXCDUyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 15:54:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:52335 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbXCDUyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 15:54:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Sun, 4 Mar 2007 21:53:32 +0100
User-Agent: KMail/1.9.6
Cc: Christoph Hellwig <hch@infradead.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
       alex@clusterfs.com, suzuki@in.ibm.com,
       Ulrich Drepper <drepper@redhat.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <200703032345.33137.arnd@arndb.de> <0DA8B217-DDD4-4E05-B000-DEBE3BE55B94@cam.ac.uk>
In-Reply-To: <0DA8B217-DDD4-4E05-B000-DEBE3BE55B94@cam.ac.uk>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703042153.35425.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1//PSssMOzstOVYIVvOxB1H0dI4p/8HKSNji0U
 DdadXuVy3JfLDtufvUizRFW3XB7/RkxE/bTdEkqTzgylTm+3kv
 IK+IEHOolUbstzupFpQ2Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 March 2007, Anton Altaparmakov wrote:
> > A generic_fallocate makes sense to me iff we can do it in the kernel
> > more significantly more efficiently than in glibc, e.g. by using only
> > a single page in page cache instead of one for each page to be  
> > preallocated.
> >
> > If  glibc is smart enough to do an optimal implementation, I fully  
> > agree
> > with you.
> 
> glibc cannot ever be smart enough because a file system driver will  
> always know better and be able to do things in a much more optimized  
> way.

Ok, that's not what I meant. It's obvious that the file system itself
can do better than both VFS and glibc. The question is whether VFS can
be better than glibc on file systems that don't offer their own
implementation of the fallocate operation.

	Arnd <><
