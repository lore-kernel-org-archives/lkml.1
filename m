Return-Path: <linux-kernel-owner+w=401wt.eu-S1762498AbXGZLYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762498AbXGZLYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 07:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbXGZLYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 07:24:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:61440 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756663AbXGZLYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 07:24:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [patch] nfs: fix locking in nfs/inode.c in nfs_free_open_context
Date: Thu, 26 Jul 2007 13:23:37 +0200
User-Agent: KMail/1.9.6
Cc: Christian Krafft <krafft@de.ibm.com>, linux-kernel@vger.kernel.org
References: <20070725170837.5fba5fd1@localhost> <1185384502.6585.97.camel@localhost>
In-Reply-To: <1185384502.6585.97.camel@localhost>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707261323.38310.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/H6A43D0l/y8fdtLn8R/4b2+dPlm02H6JtP3A
 4GfWRN40mLYUIOoJFk9xHqwJnSIAhBa2W4xOni/Q7fbpSL00d5
 Mgnp6mNsg3Ylr1Locmctg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2007, Trond Myklebust wrote:
> 
> On Wed, 2007-07-25 at 17:08 +0200, Christian Krafft wrote:
> 
> > Obviously the locking code in nfs_free_open_context is wrong.
> > Checking the list for entries and removing the entry should be an atomic operation.
> 
> Wrong. It is quite safe to test the structure member ctx->list for
> emptiness outside the spinlock because we have an explicit guarantee
> that nobody else has a reference to this structure, plus the
> atomic_dec_and_test() in kref_put() has acted as a memory barrier for
> us.

Well, the real question then is how the ctx can still be present in the
nfsi->open_files list. Since we are in nfs_free_open_context(), there
must not be any pointer to the ctx anywhere, but still we have this other
thread calling get_nfs_open_context() on it.

	Arnd <><
