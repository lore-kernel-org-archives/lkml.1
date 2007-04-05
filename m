Return-Path: <linux-kernel-owner+w=401wt.eu-S1767293AbXDEUhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767293AbXDEUhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbXDEUhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:37:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61546 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767293AbXDEUhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:37:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: Questions about porting perfmon2 to powerpc
Date: Thu, 5 Apr 2007 22:37:01 +0200
User-Agent: KMail/1.9.6
Cc: Kevin Corry <kevcorry@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Carl Love <carll@us.ibm.com>
References: <200704051455.34600.kevcorry@us.ibm.com> <200704052208.01753.arnd@arndb.de> <200704051532.08775.kevcorry@us.ibm.com>
In-Reply-To: <200704051532.08775.kevcorry@us.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704052237.02547.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19HZpAdpDLbEqnHzLfa96VSlsiAWUcLvu1obiR
 KRXm/iJeTNbS7y9agz8diuNFhCwrSsygjkiBwbYxCzgxhOigFZ
 Z/CC84FINYUgane6LpZWA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 April 2007, Kevin Corry wrote:
> For the moment, I made the change to topology_init() since it was the simplest 
> fix to get things working. I have considered switching the perfmon2 
> initialization to __initcall(), but there are apparently some timing issues 
> with ensuring that the perfmon2 core code is initialized before any of its 
> sub-modules. Since they could all be compiled statically in the kernel, I'm 
> not sure if there's a way to ensure the ordering of calls within a single 
> initcall level. I'll need to ask Stephane if there were any other reasons why 
> subsys_initcall() was used for perfmon2.

If they all come from the same directory, you can simply order them in
the Makefile. If a module in arch/ needs to be initialized after one in
drivers/, that's not possible though, and changing topology_init() should
be the best option.

	Arnd <><
