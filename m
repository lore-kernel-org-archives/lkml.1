Return-Path: <linux-kernel-owner+w=401wt.eu-S1161771AbXECKDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161771AbXECKDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161140AbXECKDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:03:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54429 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161458AbXECKDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:03:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: finding your own dead "CONFIG_" variables
Date: Thu, 3 May 2007 12:02:56 +0200
User-Agent: KMail/1.9.6
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
References: <Pine.LNX.4.64.0705030400120.20539@localhost.localdomain> <a781481a0705030237l7d636b55t93f2ee5151cd7709@mail.gmail.com> <Pine.LNX.4.64.0705030546310.29962@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0705030546310.29962@localhost.localdomain>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705031202.56805.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18gqvSlx81AdHJk7hA+goywK2eSj0d6QJX/cS+
 QlESiEA3lY/n+2+FeQ11+dwVHF9mJalvpRh6kqGnINZkyiMQFN
 XgK/pZ3FOy70LhtZ9tYxg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 May 2007, Robert P. J. Day wrote:
> > Suggest: configfiles=$(find . -name 'Kconfig*' -or -name '*defconfig*')
> >
> > Some CONFIG_ options exist that are not declared anywhere in the
> > Kconfig files but defined directly in the arch/.../*defconfig*
> > files.
> 
> it's my understanding that entries in any defconfig files are
> *automatically* pruned at some point once a CONFIG_ variable no longer
> exists in any Kconfig file, so i'm not going to be touching those
> files.  also, adding that extra check wouldn't add anything useful to
> the output.


An interesting category would be a symbol that is

- used in a source file
- defined in an old defconfig
- not present in any Kconfig* file

If any of these exist, I would consider them _worse_ than the ones
found by your initial script, because some functionality that once
was there has been recently removed.

	Arnd <><
