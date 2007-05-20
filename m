Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbXETPF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbXETPF1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 11:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756677AbXETPFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 11:05:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:60260 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571AbXETPFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 11:05:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] Fix/add raw1394 CONFIG_COMPAT code
Date: Sun, 20 May 2007 17:03:36 +0200
User-Agent: KMail/1.9.6
Cc: Petr Vandrovec <petr@vandrovec.name>, dan@dennedy.org,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20070507021447.GA22197@vana.vc.cvut.cz> <200705200155.26825.arnd@arndb.de> <464F900A.10900@s5r6.in-berlin.de>
In-Reply-To: <464F900A.10900@s5r6.in-berlin.de>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705201703.37561.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18+CTR2k8lb9EIhtO0M7YBxq8XfRY9zz0LnzoB
 F2R15YvBbamvP/VE4Wt2pzafxW/0ob0BGmkvIFqj9bvhunTF1j
 s7/6Hgy88cWwA+lzyPU3g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 May 2007, Stefan Richter wrote:
> 
> > Note that this data structure only needs conversion on x86_64 and ia64, but
> > not on powerpc and other 64 bit architectures that align __u64 also in
> > 32 bit mode.
> 
> Is this conversion just unnecessary or actually harmful on ppc64 and others?

With the current patch, the compat_ioctl function does not handle the ppc32
version of the structure at all, so it's broken there, it would at least
need a 

	case RAW1394_IOC_GET_CYCLE_TIMER:
		err = raw1394_ioctl(NULL, file, cmd, arg);
		break;

	Arnd <><
