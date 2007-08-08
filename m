Return-Path: <linux-kernel-owner+w=401wt.eu-S965270AbXHHUf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965270AbXHHUf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 16:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934777AbXHHUfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 16:35:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:59624 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760831AbXHHUfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 16:35:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: SLUB doesn't work with kdump kernel on Cell
Date: Wed, 8 Aug 2007 22:34:39 +0200
User-Agent: KMail/1.9.6
Cc: Lucio Correia <ljhc@br.ibm.com>, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arndb@arndb.de>
References: <1186604151.3608.46.camel@localhost.localdomain> <Pine.LNX.4.64.0708081321400.14478@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0708081321400.14478@schroedinger.engr.sgi.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708082234.40104.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/y/zTPJ0FGAcvJCI1jQL7Kcs+rG98aBaescEy
 YfxILR5iS8Z0fngChtMlVq/Ebh0U7CE4jfQq8QaGBlU8D1ymZl
 Wjt03zNheUZXgUcNqxyyQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2007, Christoph Lameter wrote:
> 
> > I found a problem with SLUB when trying to boot a kdump kernel on a Cell
> > QS20 Blade running Fedora 7, kernel 2.6.22.5. If I use SLAB for the
> > kdump kernel, everything works ok. The fact is that SLUB doesn't find a
> > page frame for allocation in the current node, due to the flag
> > GFP_THISNODE on a call to new_slab, and stops at a BUG_ON on line 1802
> > of slub.c. 
> 
> This is due to the node 1 having only one page. Could you just switch node 
> 1 off?

the kdump kernel needs to access data on the SPUs on node 1. It might be
possible to change that so we can access the SPUs even if there is only
one node, but it's probably not easy to do.

In the future, we also may have configurations where we need to run with
memoryless nodes on a production environment, so it should really just
work.

> > I understand that this flag should not be removed, and that there is a
> > better solution, but it demonstrates the problem. Could you give me some
> > direction on the better way to solve this problem?
> 
> Do not create a node that just has one page in it?
> 
> Or make it truly empty? An empty node will cause GFP_THISNODE to fall back 
> and you then have the same useless control structure allocation as on 
> SLAB.

What makes you assume that there is one page in the node? AFAICS, it
is a CPU-only node already without any pages.

	Arnd <><

