Return-Path: <linux-kernel-owner+w=401wt.eu-S1760919AbXGEMFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760919AbXGEMFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 08:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbXGEMFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 08:05:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:49825 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbXGEMFD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 08:05:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [RFC] bloody mess with __attribute__() syntax
Date: Thu, 5 Jul 2007 14:03:16 +0200
User-Agent: KMail/1.9.6
Cc: linux-sparse@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
References: <20070705093528.GK21478@ftp.linux.org.uk>
In-Reply-To: <20070705093528.GK21478@ftp.linux.org.uk>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707051403.16789.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX195n9d1HAUsP1miJpT5OHw3plYON8KYLac6L4n
 R/t43AlKItmUZbtdrPKXDmPhuKvNk3ed/h4BJs+aIoO0vrxut6
 zTjEbzuzQJdtLwiTyyYHA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 July 2007, Al Viro wrote:
> Frankly, I would rather add a new primitive (__qualifier__) mirroring the
> __attribute__, but acting like real qualifiers do.  And switched the
> noderef et.al. to it.  The only real alternative is to have __attribute__
> behaviour dependent on its guts and that's not feasible - remember that
> there can be more than one attribute in the list insider the damn thing.
> Besides, it's bloody disgusting.
> 
> And yes, I realize that it's an incompatible change, i.e. not a step
> to be taken lightly.  Better ways out of that mess are more than
> welcome; I don't see any ;-/

Uli Weigand has put some work into making the 'Multiple Address
Spaces' feature of Embedded C work with gcc. We need that in order
to address the process address space from a program running on an SPU
on Cell, but it should syntactically be the same thing we need for
__user, __iomem, etc. I.e., iit follows the same rules as 'const'
and 'volatile' qualifiers.
AFAIK, the infrastructure for this is supposed to go into gcc-4.3,
but has not been posted publically yet. If you add something like
this to sparse, it would be good to keep it compatible with the
new gcc extension, so that gcc can do the right thing at some point
in the future for the kernel.

Uli, can you point us to any public code or specfication about the
multiple address spaces feature?

	Arnd <><
