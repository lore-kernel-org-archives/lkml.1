Return-Path: <linux-kernel-owner+w=401wt.eu-S1161135AbXCAW5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161135AbXCAW5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 17:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161132AbXCAW5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 17:57:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:60008 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161135AbXCAW5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 17:57:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: cbe-oss-dev@ozlabs.org, michael@ellerman.id.au
Subject: Re: [Cbe-oss-dev] [PATCH 14/22] spufs: use SPU master control to prevent =?iso-8859-15?q?wild=09SPU?= execution
Date: Thu, 1 Mar 2007 14:50:50 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
References: <20061120174454.067872000@arndb.de> <20061120180525.281408000@arndb.de> <1172729890.5852.40.camel@concordia.ozlabs.ibm.com>
In-Reply-To: <1172729890.5852.40.camel@concordia.ozlabs.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703011450.50935.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX18xtYZGF9qXkiAFu5sRL8wvI1nPQZhhyip50GV
 o5PkuLlJ5rRsrjWW+J7Z+qJb9Hj/XMA4NsjeXeIiQEDZ5ZPyyL
 krbo0CnVJnpuZMq2r3VSg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2007, Michael Ellerman wrote:
> On Mon, 2006-11-20 at 18:45 +0100, Arnd Bergmann wrote:
> > plain text document attachment (spufs-master-control.diff)
> > When the user changes the runcontrol register, an SPU might be
> > running without a process being attached to it and waiting for
> > events. In order to prevent this, make sure we always disable
> > the priv1 master control when we're not inside of spu_run.
> 
> Hi Arnd,
> 
> Sorry I didn't comment on this when you sent it, I wasn't paying enough
> attention. This patch confuses me, you say we should make sure we always
> disable the master control when we're not inside spu_run, but I see
> several exit paths where we leave the master run bit enabled - or maybe
> I'm reading it wrong.

I think you're right, there is at least one path that I now saw
getting out of spufs_run_spu incorrectly. In particular, when
spu_reacquire_runnable() fails, we never call the master stop,
which is a bug, but should happen very infrequently in practice.
Do you see another case where we end up with the same problem?

If not, I'll prepare a patch to fix this one case.

	Arnd <><

