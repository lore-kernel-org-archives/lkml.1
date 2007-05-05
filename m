Return-Path: <linux-kernel-owner+w=401wt.eu-S934089AbXEER2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934089AbXEER2T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 13:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934101AbXEER2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 13:28:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:51843 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934089AbXEER2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 13:28:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Fulghum <paulkf@microgate.com>
Subject: Re: [PATCH] synclink_gt add compat_ioctl
Date: Sat, 5 May 2007 12:58:01 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1178215277.4369.6.camel@amdx2.microgate.com> <20070503175305.e46ed8b7.akpm@linux-foundation.org> <463BA0D8.3050403@microgate.com>
In-Reply-To: <463BA0D8.3050403@microgate.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705051258.01743.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX191usF7UfF1Bl2fm5yb0pKmzbMTSxUyO6n3FUD
 QKMvn86L/rpbbZPQqL8p59ZvObwKq3sC2AFMEH/YlYQ0kjmGVl
 Gy8Xnje/TSrJFn8QQ5wdQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2007, Paul Fulghum wrote:
> 
> > - It is fishy that apart from one outlier in kexec.h, synclink.h is the
> >   only header file which uses compat_ulong_t.  Are we doing this right?
> 
> Arnd, do you have any comment on this?

I think most others just define the compat data structures in the
same file that implements the headers, inside the same #ifdef that
hides the functions using them.
This makes sense, because the data structures here don't define
an interface, but rather describe what the interface looks like
in the 32 bit case.

> It seems like the compatible types should be available
> in something that is already commonly used like linux/types.h
> 
> I'm fine with it either way. I'm not in
> a position to be making those kinds of decisions
> for widely used infrastructure, so I'll leave
> that for someone further up the food chain.

All common compat_* data structures are defined in 
include/{linux,asm}/compat.h, which are empty if CONFIG_COMPAT=n.
It's against our normal conventions to hide declarations
inside an #ifdef, but I can see that it does keep the code
size down to make it impossible to compile code that is used
for compat on architectures that don't need it.

	Arnd <><
