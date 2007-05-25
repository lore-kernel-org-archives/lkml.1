Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbXEYWp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbXEYWp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 18:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbXEYWpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 18:45:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:54657 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbXEYWpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 18:45:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [patch 5/7] ps3: Disk Storage Driver
Date: Sat, 26 May 2007 00:45:09 +0200
User-Agent: KMail/1.9.6
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <20070525083607.784351000@sonycom.com> <200705252243.41508.arnd@arndb.de> <Pine.LNX.4.62.0705252318160.2657@pademelon.sonytel.be>
In-Reply-To: <Pine.LNX.4.62.0705252318160.2657@pademelon.sonytel.be>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705260045.09722.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/c7ACOOCxBoWSbRXafqwcG3b0IGmHDbbbmsIe
 e/uaQ2VXClku4uwKwKFXrqDDONtP18KvfL0Qy0mXlgIEVAM46p
 RwRtkGdgQEJlHjgR5FN0w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 May 2007, Geert Uytterhoeven wrote:
> On Fri, 25 May 2007, Arnd Bergmann wrote:
>
> > Ok, but why does it call wait_for_completion() then?
> > I thought you could end_that_request_* from the interrupt handler instead.
> 
> Actually I tried that first, but I ran into other problems, like my request
> handler being called continuously and requests gotten stuck. But maybe it was
> just a locking bug on my side.
> 
> I can retry, but a disadvantage will be that there will be less code shared
> with ps3flash and ps3rom.

Not sure how much difference it will make performance-wise, but the context
switch for each bio adds some extra cost at least. Changing it
means you no longer share the ps3stor_read_write_sectors, but can at
the same time simplify the disk driver, so that won't hurt in total.

I don't care much, but I think it's worth trying.

	Arnd <><
