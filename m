Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbXDCWHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbXDCWHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 18:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbXDCWHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 18:07:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50901 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbXDCWHd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 18:07:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ulrich Drepper <drepper@redhat.com>
Subject: Re: missing madvise functionality
Date: Wed, 4 Apr 2007 00:07:16 +0200
User-Agent: KMail/1.9.6
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>
References: <46128051.9000609@redhat.com>
In-Reply-To: <46128051.9000609@redhat.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704040007.16916.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Pk3TUZyWD8X3FxI8D9T9MmkY7pxh/cksMNdI
 QKWpvRGXztYOfp7h37pkaWini5afNN/ccVMghhUV4iLH6+4geX
 OzjrlnvKT/D4C+1fy08fg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 April 2007, Ulrich Drepper wrote:
> The problem is glibc has to work around kernel limitations.  If the
> malloc implementation detects that a large chunk of previously allocated
> memory is now free and unused it wants to return the memory to the
> system.  What we currently have to do is this:
> 
>   to free:      mmap(PROT_NONE) over the area
>   to reuse:     mprotect(PROT_READ|PROT_WRITE)
> 
> Yep, that's expensive, both operations need to get locks preventing
> other threads from doing the same.

I thought this is what the read_zero_pagealigned hack [1] was used
for (read from /dev/zero replaces target pages with empty_zero_page).
Now if read_zero_pagealigned does not solve _this_ scenario, is it
good for anything else then? 
Can we simply kill that function as a misfeature and avoid future
pain arising from it?

	Arnd <><

[1] http://lkml.org/lkml/1997/1/16/49
