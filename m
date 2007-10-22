Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbXJVTLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbXJVTLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbXJVTLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:11:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:59671 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbXJVTLg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:11:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] irq_flags_t: intro and core annotations
Date: Mon, 22 Oct 2007 21:10:34 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Ralf Baechle <ralf@linux-mips.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>, torvalds@linux-foundation.org,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
References: <20071020235546.GB1825@martell.zuzino.mipt.ru> <20071022152912.GA841@linux-mips.org> <20071022112110.105b8e11.akpm@linux-foundation.org>
In-Reply-To: <20071022112110.105b8e11.akpm@linux-foundation.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710222110.34768.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/6vDUutDWMudy3o1auOmrXxdeevSbU2Pgyo1z
 Wbhd4L161XlHCjlyIlrLU6X7BEY/zId1onChPLCS6ns4xdCnfS
 hlhayvy9qVCG3vHE069+g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 October 2007, Andrew Morton wrote:
> Yes, it's always been ugly that we use unsigned long for this rather than
> abstracting it properly.
> 
> However I'd prefer that we have some really good reason for introducing
> irq_flags_t now.  Simply so that I don't needlessly spend the next two
> years wrestling with literally thousands of convert-to-irq_flags_t patches
> and having to type "please use irq_flags_t here" in hundreds of patch
> reviews. (snivel, wimper)

On a related note, should we encourage the use of spin_lock() and
spin_lock_irq() instead of spin_lock_irqsave() where possible?

On some architectures, accessing the interrupt flag is a heavyweight
operation, especially when running under a hypervisor, so a number
of drivers could benefit from being converted to not save the flags
at all instead of just changing the type of the flags variable.

	Arnd <><
