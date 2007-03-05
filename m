Return-Path: <linux-kernel-owner+w=401wt.eu-S1751728AbXCEBSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbXCEBSg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbXCEBSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:18:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:50330 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbXCEBSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:18:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Wanted: simple, safe x86 stack overflow detection
Date: Mon, 5 Mar 2007 02:18:24 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Andreas Krebbel <krebbel1@de.ibm.com>
References: <45E5913D.3080505@redhat.com>
In-Reply-To: <45E5913D.3080505@redhat.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703050218.25028.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1+ZhB7HxcDKghFlkdm6voCAvEPMobKLA5wd3oo
 3NrYyT0T9I05GNM/HddA2xd320Pns5UvhVJO5guadEAzF0UREx
 WZUh/QnVm9ZEx3vceXLdw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 February 2007, Chuck Ebbert wrote:
> Can we just put a canary in the threadinfo and check it on every
> task switch? What are the drawbacks?

It's not completely reliable, in case of functions that allocate
far too much stack space. You might want to take a look at the
gcc support that Andreas Krebbel implemented for s390 to check
for stack overflows:

http://gcc.gnu.org/ml/gcc-patches/2004-08/msg01308.html

I think there are some additions planned for the next gcc release,
but if you port this to i386, it will get you pretty far.

	Arnd <><
