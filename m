Return-Path: <linux-kernel-owner+w=401wt.eu-S939371AbXHIN4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939371AbXHIN4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 09:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934827AbXHIN4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 09:56:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51224 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762128AbXHIN4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 09:56:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Date: Thu, 9 Aug 2007 14:41:25 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, ak@suse.de, heiko.carstens@de.ibm.com,
       davem@davemloft.net, schwidefsky@de.ibm.com, wensong@linux-vs.org,
       horms@verge.net.au, wjiang@resilience.com, cfriesen@nortel.com,
       zlynx@acm.org, rpjday@mindspring.com, jesper.juhl@gmail.com
References: <20070809131423.GA9927@shell.boston.redhat.com>
In-Reply-To: <20070809131423.GA9927@shell.boston.redhat.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708091441.28511.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/E4RqeTZgwG4Pkbo42kHlXP1kIpIFgvtfoaBy
 6GQodJ77MfsqM+atxadrkQvXYH+2j7f8upY2J+/0EtygwcbVGx
 WpUnPErEBRCTf55XwnZuQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 August 2007, Chris Snook wrote:
> This patchset makes the behavior of atomic_read uniform by removing the
> volatile keyword from all atomic_t and atomic64_t definitions that currently
> have it, and instead explicitly casts the variable as volatile in
> atomic_read().  This leaves little room for creative optimization by the
> compiler, and is in keeping with the principles behind "volatile considered
> harmful".
> 

Just an idea: since all architectures already include asm-generic/atomic.h,
why not move the definitions of atomic_t and atomic64_t, as well as anything
that does not involve architecture specific inline assembly into the generic
header?

	Arnd <><
